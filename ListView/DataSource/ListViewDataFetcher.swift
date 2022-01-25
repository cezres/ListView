//
//  ListViewDataFetcher.swift
//  ListView
//
//  Created by azusa on 2021/8/25.
//

import Foundation
import PromiseKit

open class ListViewDataFetcher: ListViewDataSource {
    enum Error: Swift.Error {
        case loading
        case noMoreData
    }

    public private(set) var items = [AnyListViewCellModel]()

    public var headerItems: [AnyListViewCellModel]? {
        didSet {
            items = customListViewCellModel(items: dataList)
        }
    }

    public var footerItems: [AnyListViewCellModel]? {
        didSet {
            items = customListViewCellModel(items: dataList)
        }
    }

    public var emptyCellModel: AnyListViewCellModel? {
        didSet {
            items = customListViewCellModel(items: dataList)
        }
    }

    private var dataList = [AnyListViewCellModel]() {
        didSet {
            items = customListViewCellModel(items: dataList)
        }
    }

    public private(set) var hasMoreData = true

    public private(set) var loading = false

    public private(set) var start = 0

    public var limit = 10

    public init() {
    }

    @discardableResult
    open func refresh() -> Promise<[AnyListViewCellModel]> {
        guard !loading else {
            return .init(error: Error.loading)
        }

        loading = true
        return .init { (resolver) in
            fetch(start: 0, limit: limit).done { result in
                self.hasMoreData = !result.isEmpty
                self.start = result.count
                self.dataList = result
                self.loading = false
                resolver.fulfill(self.items)
            }.catch { error in
                self.loading = false
                resolver.reject(error)
            }
        }
    }

    @discardableResult
    open func loadMore() -> Promise<[AnyListViewCellModel]> {
        guard hasMoreData else {
            return .init(error: Error.noMoreData)
        }
        guard !loading else {
            return .init(error: Error.loading)
        }

        loading = true
        return .init { (resolver) in
            fetch(start: start, limit: limit).done { result in
                self.hasMoreData = !result.isEmpty
                self.start += result.count
                self.dataList += result
                self.items = self.customListViewCellModel(items: self.dataList)
                self.loading = false
                resolver.fulfill(self.items)
            }.catch { error in
                self.loading = false
                resolver.reject(error)
            }
        }
    }

    open func fetch(start: Int, limit: Int) -> Promise<[AnyListViewCellModel]> {
        fatalError("fetch(start:limit:) has not been implemented")
    }

    open func customListViewCellModel(items: [AnyListViewCellModel]) -> [AnyListViewCellModel] {
        if items.isEmpty, let emptyCellModel = emptyCellModel {
            return buildHeaderListViewCellModels() + [emptyCellModel] + buildFooterListViewCellModels()
        } else {
            return buildHeaderListViewCellModels() + items + buildFooterListViewCellModels()
        }
    }

    open func buildHeaderListViewCellModels() -> [AnyListViewCellModel] {
        return headerItems ?? []
    }

    open func buildFooterListViewCellModels() -> [AnyListViewCellModel] {
        return footerItems ?? []
    }
}
