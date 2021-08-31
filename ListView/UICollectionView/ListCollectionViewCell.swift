//
//  ListCollectionViewCell.swift
//  ListView
//
//  Created by azusa on 2021/7/19.
//

import UIKit

public typealias AnyListCollectionViewCell = UICollectionViewCell & AnyListViewCell

open class ListCollectionViewCell<T: ListViewCellModel>: UICollectionViewCell, ListViewCell {
    public typealias Model = T

    open var model: T?

    open class func contentHeight(for model: T) -> CGFloat {
        0
    }

    open func setup(_ model: T) {
    }
}
