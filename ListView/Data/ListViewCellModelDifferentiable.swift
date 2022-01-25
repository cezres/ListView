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

    /// ContentIdentifiable
    typealias DifferenceIdentifier = Int

    var differenceIdentifier: Int {
        reuseIdentifier.hashValue
    }

    /// ContentEquatable
    func isContentEqual(to source: AnyDifferenceListViewCellModel) -> Bool {
        source.hashValue == hashValue
    }

    /// Equatable
    static func == (lhs: AnyDifferenceListViewCellModel, rhs: AnyDifferenceListViewCellModel) -> Bool {
        lhs.hashValue == rhs.hashValue
    }

    /// Hashable

    func hash(into hasher: inout Hasher) {
        model.hash(into: &hasher)
    }

    /// AnyListViewCellModel

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

    let model: AnyListViewCellModel & ListViewCellModelDifferentiable
}
