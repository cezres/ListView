//
//  DifferenceCellModel.swift
//  ListView
//
//  Created by azusa on 2021/8/13.
//

import UIKit
import DifferenceKit

public protocol ListViewCellModelDifferentiable {
    func hash(into hasher: inout Hasher)
}

struct AnyDifferenceListViewCellModel: AnyListViewCellModel, Hashable, Differentiable {
    func setup(in view: UIView) {
        model.setup(in: view)
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

    static func == (lhs: AnyDifferenceListViewCellModel, rhs: AnyDifferenceListViewCellModel) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    func hash(into hasher: inout Hasher) {
        model.hash(into: &hasher)
    }

    let model: AnyListViewCellModel & ListViewCellModelDifferentiable
}
