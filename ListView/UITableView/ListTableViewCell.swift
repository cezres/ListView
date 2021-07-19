//
//  ListTableViewCell.swift
//  ListView
//
//  Created by azusa on 2021/7/19.
//

import UIKit

public typealias AnyListTableViewCell = UITableViewCell & AnyListViewCell

open class ListTableViewCell<T: ListViewCellModel>: UITableViewCell, ListViewCell {
    public typealias Model = T
    
    open var model: T?
    
    open class func contentHeight(for model: T) -> CGFloat {
        return 0
    }
    
    open func setup(_ model: T) {
    }
}
