//
//  AnyListViewCellModel.swift
//  ListView
//
//  Created by azusa on 2021/8/13.
//

import Foundation
import UIKit

public protocol AnyListViewCellModel {
    var reuseIdentifier: String { get }

    var cellClass: UIView.Type { get }

    func contentHeight(for contentView: UIView) -> CGFloat

    func setupView(_ view: UIView)

    func didSelectItem()
}

extension AnyListViewCellModel {
    public var reuseIdentifier: String { String(describing: Self.self) }

    public func didSelectItem() {}
}
