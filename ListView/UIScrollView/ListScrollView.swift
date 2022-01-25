//
//  ListScrollView.swift
//  ListView
//
//  Created by azusa on 2021/8/30.
//

import UIKit
import DifferenceKit

class ListScrollView: UIScrollView {
    var dataSource: [AnyListViewCellModel] = [] {
        didSet {
            reloadData(data: dataSource)
        }
    }

    var data: [AnyListViewCellModel] = []

    var cells: [UIView] = []

    private var caches: [[String: UIView]] = []

    func dequeueReusableCell(withModel model: AnyListViewCellModel) -> UIView {
        let cell: UIView
        if let index = caches.firstIndex(where: { $0.keys.first == model.reuseIdentifier }), let result = caches.remove(at: index).values.first {
            cell = result
        } else if let result = (model.cellClass as AnyClass).alloc() as? UIView {
            result.perform(#selector(UIView.init(frame:)), with: CGRect(x: 0, y: 0, width: 200, height: 100))
            cell = result
            cell.isUserInteractionEnabled = true
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectItem(_:))))
        } else {
            fatalError("Invalid View type")
        }
        addSubview(cell)
        model.setupView(cell)
        return cell
    }

    @objc func didSelectItem(_ gesture: UIGestureRecognizer) {
        guard let index = cells.firstIndex(where: { $0 == gesture.view }) else {
            return
        }
        data[index].didSelectItem()
        endEditing(true)
    }

    func cacheReusableCell(withCell cell: UIView, for model: AnyListViewCellModel) {
        caches.insert([model.reuseIdentifier: cell], at: 0)
        if caches.count > 10 {
            _ = caches.dropLast()
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        cells.enumerated().forEach { (index, cell) in
            cell.frame = .init(
                x: 0,
                y: index == 0 ? 0 : cells[index - 1].frame.maxY,
                width: bounds.width,
                height: data[index].contentHeight(for: self)
            )
        }
        contentSize = .init(width: bounds.width, height: cells.last?.frame.maxY ?? 0)
    }
}

// MARK: Load Data
extension ListScrollView {
    func reloadData(data: [AnyListViewCellModel]) {
        if case .none = window {
            cells.enumerated().forEach {
                cacheReusableCell(withCell: $0.element, for: self.data[$0.offset])
                $0.element.removeFromSuperview()
            }

            if let data = data as? [ListViewCellModelDifferentiable & AnyListViewCellModel] {
                self.data = data.map { AnyDifferenceListViewCellModel(model: $0) }
            } else {
                self.data = data
            }
            cells = self.data.map { dequeueReusableCell(withModel: $0) }
            setNeedsLayout()
            return
        }

        guard let newData = data as? [ListViewCellModelDifferentiable & AnyListViewCellModel],
              let oldData = self.data as? [AnyDifferenceListViewCellModel] else {
            cells.enumerated().forEach {
                cacheReusableCell(withCell: $0.element, for: self.data[$0.offset])
                $0.element.removeFromSuperview()
            }

            if let data = data as? [ListViewCellModelDifferentiable & AnyListViewCellModel] {
                self.data = data.map { AnyDifferenceListViewCellModel(model: $0) }
            } else {
                self.data = data
            }
            cells = self.data.map { dequeueReusableCell(withModel: $0) }
            setNeedsLayout()
            return
        }

        let changeset = StagedChangeset(
            source: oldData,
            target: newData.map {
                AnyDifferenceListViewCellModel(model: $0)
            }
        )

        reload(using: changeset)
    }

    func reload(using stagedChangeset: StagedChangeset<[AnyDifferenceListViewCellModel]>) {
        for changeset in stagedChangeset {
            let oldData = data
            data = changeset.data

            if !changeset.elementDeleted.isEmpty {
                changeset.elementDeleted.reversed().forEach {
                    let cell = cells.remove(at: $0.element)
                    cell.removeFromSuperview()
                    cacheReusableCell(withCell: cell, for: oldData[$0.element])
                }
            }

            if !changeset.elementInserted.isEmpty {
                changeset.elementInserted.forEach {
                    let view = dequeueReusableCell(withModel: data[$0.element])
                    cells.insert(view, at: $0.element)
                }
            }

            if !changeset.elementUpdated.isEmpty {
                changeset.elementUpdated.forEach {
                    let oldCell = cells.remove(at: $0.element)
                    oldCell.removeFromSuperview()
                    cacheReusableCell(withCell: oldCell, for: oldData[$0.element])

                    let newCell = dequeueReusableCell(withModel: data[$0.element])
                    cells.insert(newCell, at: $0.element)
                }
            }

            for (source, target) in changeset.elementMoved {
                let sourceView = cells.remove(at: source.element)
                cells.insert(sourceView, at: target.element)
            }
        }
        setNeedsLayout()
    }
}
