//
//  ListViewData.swift
//  ListView
//
//  Created by azusa on 2021/7/19.
//

import Foundation

public protocol ListViewData {
    var items: [AnyListViewCellModel] { get }
    
    func refresh() -> [AnyListViewCellModel]
    func hasMoreData() -> Bool
    func loadMore() -> [AnyListViewCellModel]
    func fetch(start: Int, limit: Int) throws -> [AnyListViewCellModel]
}

extension Array: ListViewData where Element: AnyListViewCellModel {
    public var items: [AnyListViewCellModel] { self }
    
    public func refresh() -> [AnyListViewCellModel] { self }
    public func hasMoreData() -> Bool { false }
    public func loadMore() -> [AnyListViewCellModel] { self }
    public func fetch(start: Int, limit: Int) throws -> [AnyListViewCellModel] { self }
}

enum ListViewDataFetcherError: Swift.Error {
    case loading
    case noMoreData
}

open class ListViewDataFetcher: ListViewData {
    open private(set) var items = [AnyListViewCellModel]()
    
    public private(set) var loading = false

    @discardableResult
    open func refresh() -> [AnyListViewCellModel] {
        return []
    }

    @discardableResult
    open func loadMore() -> [AnyListViewCellModel] {
        return []
    }

    open func hasMoreData() -> Bool {
        return false
    }

    open func fetch(start: Int, limit: Int) throws -> [AnyListViewCellModel] {
        fatalError()
    }
}
