//
//  AnyListViewData.swift
//  ListView
//
//  Created by azusa on 2021/8/13.
//

import Foundation
import UIKit

public protocol AnyListViewData {
    var reuseIdentifier: String { get }

    var cellClass: UIView.Type { get }

    func contentHeight(for contentView: UIView) -> CGFloat

    func didSelectItem()

    func setupView(_ view: UIView)
}

extension AnyListViewData {
    public var reuseIdentifier: String { String(describing: Self.self) }

    public func didSelectItem() {}
}
