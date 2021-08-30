//
//  CellModel.swift
//  ListView
//
//  Created by azusa on 2021/8/13.
//

import Foundation
import UIKit

public protocol ListViewCellModel: AnyListViewCellModel {
    associatedtype View: ListViewCell
}

extension ListViewCellModel {
    public var cellClass: AnyListViewCell.Type { View.self }

    public func contentHeight(for contentView: UIView) -> CGFloat {
        View.contentHeight(for: self)
    }
}
