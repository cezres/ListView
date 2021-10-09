//
//  DifferenceCellModel.swift
//  ListView
//
//  Created by azusa on 2021/8/13.
//

import UIKit
import DifferenceKit

public protocol ListViewDataDifferentiable {
    func hash(into hasher: inout Hasher)
}

struct AnyDifferenceListViewData: AnyListViewData, Hashable, Differentiable {
    func setupView(_ view: UIView) {
        model.setupView(view)
    }

    var reuseIdentifier: String {
        model.reuseIdentifier
    }

    var cellClass: UIView.Type {
        model.cellClass
    }

    func contentHeight(for contentView: UIView) -> CGFloat {
        model.contentHeight(for: contentView)
    }

    func didSelectItem() {
        model.didSelectItem()
    }

    static func == (lhs: AnyDifferenceListViewData, rhs: AnyDifferenceListViewData) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {
        model.hash(into: &hasher)
    }

    let model: AnyListViewData & ListViewDataDifferentiable
}
