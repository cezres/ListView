//
//  UICollectionViewExtensions.swift
//  ListView
//
//  Created by azusa on 2021/7/19.
//

import UIKit

extension UICollectionView {
    public func register(_ model: AnyListViewCellModel.Type) {
        register(model.cellClass, forCellWithReuseIdentifier: model.reuseIdentifier)
    }

    public func dequeueReusableCell(withModel model: AnyListViewCellModel, for indexPath: IndexPath) -> AnyListCollectionViewCell {
        register(model.cellClass, forCellWithReuseIdentifier: model.reuseIdentifier)
        let cell = dequeueReusableCell(withReuseIdentifier: model.reuseIdentifier, for: indexPath) as! AnyListCollectionViewCell
        cell.setup(model)
        return cell
    }

    public func reloadVisibleCells() {
        visibleCells.map {
            ($0, self.indexPath(for: $0)!)
        }.forEach {
            let (cell, indexPath) = $0
            self.delegate?.collectionView?(self, willDisplay: cell, forItemAt: indexPath)
        }
    }
}
