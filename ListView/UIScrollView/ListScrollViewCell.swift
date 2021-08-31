//
//  ListScrollViewCell.swift
//  ListView
//
//  Created by azusa on 2021/8/30.
//

import UIKit

public typealias AnyListScrollViewCell = UIView & AnyListViewCell

open class ListScrollViewCell<T: ListViewCellModel>: UIView, ListViewCell {
    
    public typealias Model = T
    
    open var model: T?
    
    open class func contentHeight(for model: T) -> CGFloat {
        0
    }
    
    open func setup(_ model: T) {
    }
    
}
