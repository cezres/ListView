//
//  AsyncListViewDataFetcher.swift
//  ListView
//
//  Created by 翟泉 on 2022/7/15.
//

import Foundation
import PromiseKit

open class AsyncListViewDataFetcher: ListViewDataFetcher {
    
    public override func fetch(start: Int, limit: Int) -> Promise<[AnyListViewCellModel]> {
        .init { resolver in
            Task {
                do {
                    let result = try await self.asyncFetch(start: start, limit: limit)
                    resolver.fulfill(result)
                } catch {
                    resolver.reject(error)
                }
            }
        }.map(on: .main) {
            $0
        }
    }
    
    open func asyncFetch(start: Int, limit: Int) async throws -> [AnyListViewCellModel] {
        fatalError("fetch(start:limit:) has not been implemented")
    }
}
