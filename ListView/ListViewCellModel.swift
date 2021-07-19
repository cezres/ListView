//
//  ListViewCellModel.swift
//  ListView
//
//  Created by azusa on 2021/7/19.
//

import UIKit

public protocol AnyListViewCellModel {
    static var reuseIdentifier: String { get }
    static var cellClass: AnyListViewCell.Type { get }
    func contentSize(for contentView: UIView) -> CGSize
}

extension AnyListViewCellModel {
    public var reuseIdentifier: String { Self.reuseIdentifier }
    public var cellClass: AnyListViewCell.Type { Self.cellClass }
}

public protocol ListViewCellModel: AnyListViewCellModel {
    associatedtype View: ListViewCell
}

extension ListViewCellModel {
    public static var reuseIdentifier: String { String(describing: self) }
    public static var cellClass: AnyListViewCell.Type { View.self }
    
    public func contentSize(for contentView: UIView) -> CGSize {
        return .init(width: contentView.bounds.width, height: View.contentHeight(for: self))
    }
}

public protocol ListViewCellModelAction {
    var action: () -> Void { get }
}
