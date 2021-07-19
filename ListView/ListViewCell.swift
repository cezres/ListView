//
//  ListViewCell.swift
//  ListView
//
//  Created by azusa on 2021/7/19.
//

import UIKit

public protocol AnyListViewCell: NSObjectProtocol {
    static func contentHeight(for model: AnyListViewCellModel) -> CGFloat
    @discardableResult func setup(_ model: AnyListViewCellModel) -> Self
}

public protocol ListViewCell: AnyListViewCell {
    associatedtype Model: AnyListViewCellModel
    
    var model: Model? { get set }
    
    static func contentHeight(for model: Model) -> CGFloat
    func setup(_ model: Model)
}

extension ListViewCell {
    public static func contentHeight(for model: AnyListViewCellModel) -> CGFloat {
        if let model = model as? Model {
            return contentHeight(for: model)
        } else {
            return 0
        }
    }

    @discardableResult
    public func setup(_ model: AnyListViewCellModel) -> Self {
        if let model = model as? Model {
            self.model = model
            setup(model)
        }
        return self
    }
    
    public func setup(_ model: Model) {
        self.model = model
    }
}
