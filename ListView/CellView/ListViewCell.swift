//
//  CellView.swift
//  ListView
//
//  Created by azusa on 2021/8/13.
//

import UIKit

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

    public func setup(_ model: AnyListViewCellModel) {
        if let model = model as? Model {
            self.model = model
            setup(model)
        } else if let differenceModel = model as? AnyDifferenceListViewCellModel, let model = differenceModel.model as? Model {
            self.model = model
            setup(model)
        }
    }

    public func setup(_ model: Model) {
        self.model = model
    }
}
