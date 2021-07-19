//
//  ListViewData.swift
//  ListView
//
//  Created by azusa on 2021/7/19.
//

import Foundation

public protocol ListViewData {
    var items: [AnyListViewCellModel] { get }
    
//    func refresh() -> [AnyListViewCellModel]
//    func hasMoreData() -> Bool
//    func loadMore() -> [AnyListViewCellModel]
//    func fetch(start: Int, limit: Int) -> [AnyListViewCellModel]
}

extension Array: ListViewData where Element: AnyListViewCellModel {
    public var items: [AnyListViewCellModel] { self }
    
//    public func refresh() -> [AnyListViewCellModel] { self }
//    public func hasMoreData() -> Bool { false }
//    public func loadMore() -> [AnyListViewCellModel] { self }
//    public func fetch(start: Int, limit: Int) -> [AnyListViewCellModel] { self }
}

//open class ListViewDataFetcher: ListViewData {
//    open private(set) var items = [AnyListViewCellModel]()
//
//    @discardableResult
//    public func refresh() -> [AnyListViewCellModel] {
//        return []
//    }
//
//    @discardableResult
//    public func loadMore() -> [AnyListViewCellModel] {
//        return []
//    }
//
//    public func hasMoreData() -> Bool {
//        return false
//    }
//
//    public func fetch(start: Int, limit: Int) -> [AnyListViewCellModel] {
//        fatalError()
//    }
//}
