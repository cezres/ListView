//
//  AnyCellView.swift
//  ListView
//
//  Created by azusa on 2021/8/13.
//

import UIKit

public protocol AnyListViewCell: NSObjectProtocol {
    
    static func contentHeight(for model: AnyListViewCellModel) -> CGFloat
    
    func setup(_ model: AnyListViewCellModel)
    
}
