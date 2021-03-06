//
//  ListViewDataSource.swift
//  ListView
//
//  Created by azusa on 2021/8/25.
//

import class PromiseKit.Promise

public protocol ListViewDataSource {
    var items: [AnyListViewCellModel] { get }

    var hasMoreData: Bool { get }

    func refresh() -> Promise<[AnyListViewCellModel]>

    func loadMore() -> Promise<[AnyListViewCellModel]>
}
