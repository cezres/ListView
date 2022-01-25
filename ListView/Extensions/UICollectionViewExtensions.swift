//
//  UICollectionViewExtensions.swift
//  ListView
//
//  Created by azusa on 2021/7/19.
//

import UIKit

extension UICollectionView {
    public func dequeueReusableCell(withModel model: AnyListViewCellModel, for indexPath: IndexPath) -> UICollectionViewCell {
        register(model.cellClass, forCellWithReuseIdentifier: model.reuseIdentifier)
        let cell = dequeueReusableCell(withReuseIdentifier: model.reuseIdentifier, for: indexPath)
        model.setupView(cell)
        return cell
    }
}
