//
//  ListScrollView.swift
//  ListView
//
//  Created by azusa on 2021/8/30.
//

import UIKit
import DifferenceKit

class ListScrollView: UIScrollView {
    var dataSource: [AnyListViewData] = [] {
        didSet {
            reloadData(data: dataSource)
        }
    }

    var data: [AnyListViewData] = []

    var cells: [UIView] = []

    private var caches: [[String: UIView]] = []

    func dequeueReusableCell(withModel model: AnyListViewData) -> UIView {
        let cell: UIView
        if let index = caches.firstIndex(where: { $0.keys.first == model.reuseIdentifier }), let result = caches.remove(at: index).values.first {
            cell = result
        } else if let result = (model.cellClass as AnyClass).alloc() as? UIView {
            result.perform(#selector(UIView.init(frame:)), with: CGRect.zero)
            cell = result
            cell.isUserInteractionEnabled = true
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didSelectItem(_:))))
        } else {
            cell = UIView()
        }
        addSubview(cell)
        model.setupView(cell)
        return cell
    }

    func cacheReusableCell(withCell cell: UIView, for model: AnyListViewCellModel) {
    @objc func didSelectItem(_ gesture: UIGestureRecognizer) {
        guard let index = cells.firstIndex(where: { $0 == gesture.view }) else {
            return
        }
        data[index].didSelectItem()
        endEditing(true)
    }

        caches.insert([model.reuseIdentifier: cell], at: 0)
        if caches.count > 10 {
            _ = caches.dropLast()
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        cells.enumerated().forEach { (index, cell) in
            cell.frame = .init(
                x: 0,
                y: index == 0 ? 0 : cells[index - 1].frame.maxY,
                width: bounds.width,
                height: data[index].contentHeight(for: self)
            )
        }
    }
}

// MARK: Load Data
extension ListScrollView {
    func reloadData(data: [AnyListViewData]) {
        if case .none = window {
            cells.enumerated().forEach {
                cacheReusableCell(withCell: $0.element, for: self.data[$0.offset])
                $0.element.removeFromSuperview()
            }

            if let data = data as? [ListViewDataDifferentiable & AnyListViewData] {
                self.data = data.map { AnyDifferenceListViewData(model: $0) }
            } else {
                self.data = data
            }
            cells = data.map { dequeueReusableCell(withModel: $0) }
            setNeedsLayout()
            return
        }

        guard let newData = data as? [ListViewDataDifferentiable & AnyListViewData],
              let oldData = self.data as? [AnyDifferenceListViewData] else {
            cells.enumerated().forEach {
                cacheReusableCell(withCell: $0.element, for: self.data[$0.offset])
                $0.element.removeFromSuperview()
            }

            self.data = data
            cells = data.map { dequeueReusableCell(withModel: $0) }
            setNeedsLayout()
            return
        }

        let changeset = StagedChangeset(
            source: oldData,
            target: newData.map {
                AnyDifferenceListViewData(model: $0)
            }
        )

        reload(using: changeset)
    }

    func reload(using stagedChangeset: StagedChangeset<[AnyDifferenceListViewData]>) {
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
