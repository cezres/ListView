//
//  ListViewDataSource.swift
//  ListView
//
//  Created by azusa on 2021/8/25.
//

import Foundation
import class PromiseKit.Promise

public protocol ListViewDataSource {
    var items: [AnyListViewCellModel] { get }

    var hasMoreData: Bool { get }

    func refresh() -> Promise<[AnyListViewCellModel]>

    func loadMore() -> Promise<[AnyListViewCellModel]>
}

extension ListViewDataSource {
    public var hasMoreData: Bool { false }

    public func refresh() -> Promise<[AnyListViewCellModel]> { .init(resolver: { $0.fulfill(items) }) }

    public func loadMore() -> Promise<[AnyListViewCellModel]> { .init(resolver: { $0.fulfill(items) }) }
}
