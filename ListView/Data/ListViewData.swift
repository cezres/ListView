//
//  CellModel.swift
//  ListView
//
//  Created by azusa on 2021/8/13.
//

import Foundation
import UIKit

public protocol ListViewData: AnyListViewData {
    associatedtype View: UIView

    func setupView(_ view: View)
}

extension ListViewData {
    public var cellClass: UIView.Type { View.self }

    public func setupView(_ view: UIView) {
        if let differenceModel = self as? AnyDifferenceListViewData {
            differenceModel.model.setupView(view)
        } else if let view = view as? View {
            setupView(view)
        }
    }
}
