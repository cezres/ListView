//
//  ListScrollView.swift
//  ListView
//
//  Created by azusa on 2021/8/30.
//

import UIKit
import SnapKit
import DifferenceKit

public class ListScrollView: UIView {
    
    public var data: [AnyListViewCellModel] = [] {
        didSet {
            reloadData(data: data)
        }
    }
    
    private var items: [AnyListViewCellModel] = []
    private var cells: [AnyListScrollViewCell] = []
    private var caches: [[String: AnyListScrollViewCell]] = []
    
    func dequeueReusableCell(withModel model: AnyListViewCellModel) -> AnyListScrollViewCell {
        let cls: AnyClass = model.cellClass
        let cell: AnyListScrollViewCell
        
        if let index = caches.firstIndex(where: { $0.keys.first == model.reuseIdentifier }), let result = caches.remove(at: index).values.first {
            cell = result
        } else if let result = cls.alloc() as? AnyListScrollViewCell {
            result.perform(#selector(UIView.init(frame:)), with: CGRect.zero)
            cell = result
        } else {
            cell = EmptyListScrollViewCell()
        }
        addSubview(cell)
        cell.setup(model)
        return cell
    }
    
    func cacheReusableCell(withCell cell: AnyListScrollViewCell, for model: AnyListViewCellModel) {
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
    
    func reloadData(data: [AnyListViewCellModel]) {
        if case .none = window {
            if let data = data as? [ListViewCellModelDifferentiable & AnyListViewCellModel] {
                items = data.map { AnyDifferenceListViewCellModel(model: $0) }
            } else {
                items = data
            }
            cells = items.map { dequeueReusableCell(withModel: $0) }
            setNeedsLayout()
            return
        }
        
        guard let newData = data as? [ListViewCellModelDifferentiable & AnyListViewCellModel],
              let oldData = items as? [AnyDifferenceListViewCellModel] else {
            cells.enumerated().forEach {
                cacheReusableCell(withCell: $0.element, for: items[$0.offset])
                $0.element.removeFromSuperview()
            }
            
            items = data
            cells = items.map { dequeueReusableCell(withModel: $0) }
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
            let oldDatas = items
            items = changeset.data

            if !changeset.elementDeleted.isEmpty {
                changeset.elementDeleted.reversed().forEach {
                    let cell = cells.remove(at: $0.element)
                    cell.removeFromSuperview()
                    cacheReusableCell(withCell: cell, for: oldDatas[$0.element])
                }
            }

            if !changeset.elementInserted.isEmpty {
                changeset.elementInserted.forEach {
                    let view = dequeueReusableCell(withModel: items[$0.element])
                    cells.insert(view, at: $0.element)
                }
            }

            if !changeset.elementUpdated.isEmpty {
                changeset.elementUpdated.forEach {
                    let oldCell = cells.remove(at: $0.element)
                    oldCell.removeFromSuperview()
                    cacheReusableCell(withCell: oldCell, for: oldDatas[$0.element])
                    
                    let newCell = dequeueReusableCell(withModel: items[$0.element])
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


// MARK: Empty View
struct EmptyListScrollViewCellModel: ListViewCellModel {
    typealias View = EmptyListScrollViewCell
}

class EmptyListScrollViewCell: ListScrollViewCell<EmptyListScrollViewCellModel> {
    override class func contentHeight(for model: EmptyListScrollViewCellModel) -> CGFloat {
        20
    }
    
    func setup(_ model: AnyListViewCellModel) {
        backgroundColor = .white
    }
}
