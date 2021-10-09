//
//  Array+ListViewDataSource.swift
//  ListView
//
//  Created by azusa on 2021/8/25.
//

import Foundation
import PromiseKit

extension Array: ListViewDataSource where Element == AnyListViewData {
    public var items: [AnyListViewData] { self }

    public var hasMoreData: Bool { false }

    public func refresh() -> Promise<[AnyListViewData]> { .init(resolver: { $0.fulfill(items) }) }

    public func loadMore() -> Promise<[AnyListViewData]> { .init(resolver: { $0.fulfill(items) }) }
}
