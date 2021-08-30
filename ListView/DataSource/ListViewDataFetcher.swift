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
    
    open private(set) var items = [AnyListViewCellModel]()
    
    public private(set) var hasMoreData = false
    
    public private(set) var loading = false
    
    public private(set) var start = 0
    
    public var limit = 10

    @discardableResult
    open func refresh() -> Promise<[AnyListViewCellModel]> {
        guard !loading else {
            return .init(error: Error.loading)
        }
        
        loading = true
        return .init { (resolver) in
            fetch(start: 0, limit: limit).done { result in
                self.hasMoreData = result.count >= self.limit
                self.start = result.count
                self.items = result
                resolver.fulfill(result)
            }.catch { error in
                resolver.reject(error)
            }.finally {
                self.loading = false
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
                self.hasMoreData = result.count > 0
                self.start += result.count
                self.items += result
                resolver.fulfill(result)
            }.catch { error in
                resolver.reject(error)
            }.finally {
                self.loading = false
            }
        }
    }

    open func fetch(start: Int, limit: Int) -> Promise<[AnyListViewCellModel]> {
        fatalError()
    }
    
}
