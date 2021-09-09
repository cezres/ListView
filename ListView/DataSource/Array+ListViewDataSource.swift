//
//  Array+ListViewDataSource.swift
//  ListView
//
//  Created by azusa on 2021/8/25.
//

import Foundation
import PromiseKit

extension Array: ListViewDataSource where Element: AnyListViewCellModel {
    public var items: [AnyListViewCellModel] { self }

    public var hasMoreData: Bool { false }

    public func refresh() -> Promise<[AnyListViewCellModel]> { .init(resolver: { $0.fulfill(items) }) }

    public func loadMore() -> Promise<[AnyListViewCellModel]> { .init(resolver: { $0.fulfill(items) }) }
}
