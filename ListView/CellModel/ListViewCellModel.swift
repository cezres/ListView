//
//  CellModel.swift
//  ListView
//
//  Created by azusa on 2021/8/13.
//

import Foundation
import UIKit

public protocol ListViewCellModel: AnyListViewCellModel {
    associatedtype View: UIView

    func setup(in view: View)
}

extension ListViewCellModel {
    public var cellClass: UIView.Type { View.self }

    public func setup(in view: UIView) {
        if let differenceModel = self as? AnyDifferenceListViewCellModel {
            differenceModel.model.setup(in: view)
        } else if let view = view as? View {
            setup(in: view)
        }
    }
}
