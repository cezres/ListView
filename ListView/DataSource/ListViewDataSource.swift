//
//  ListViewDataSource.swift
//  ListView
//
//  Created by azusa on 2021/8/25.
//

import class PromiseKit.Promise
import Combine
import Foundation

public protocol ListViewDataSource {
    
    var items: [AnyListViewCellModel] { get }

    var hasMoreData: Bool { get }

    func refresh() -> Promise<[AnyListViewCellModel]>

    func loadMore() -> Promise<[AnyListViewCellModel]>
}


protocol __ListViewDataSource {
    
//    var items: CurrentValueSubject<[AnyListViewCellModel], Never> { get }
    
//    var items: Publisher.Seq<[AnyListViewCellModel], Never> { get }
    
    var hasMoreData: Bool { get }
    
    func refresh()
    
    func loadMore()
}

extension Array: __ListViewDataSource where Element == AnyListViewCellModel {
//    var items: CurrentValueSubject<Int, Never> {
//        let xxx = self.publisher
//    }
    
    func refresh() {
        
        
        
    }
    
    func loadMore() {
        
    }
}

class Example1 {
    
    
    var refresh: PassthroughSubject<Void, Never> = .init()
    
    var loadMore: PassthroughSubject<Void, Never> = .init()
    
    @Published var items: Int = 0
    
}


var cancellable: AnyCancellable?

func xxx(_ dataSource: __ListViewDataSource) {
    let ex1 = Example1()
    ex1.items = 10
    
    ex1.refresh
        .flatMap { _ in
            [1].publisher
        }
        .eraseToAnyPublisher()
        .map { value in
            return value
        }
        .sink { value in
            ex1.items = value
        }
//        .receive(subscriber: <#T##Subscriber#>)
    
    
//    cancellable = dataSource.items
//        .receive(on: RunLoop.main)
//        .sink { xxx in
//            switch xxx {
//            case .finished:
//                break
//            case .failure:
//                break
//            }
//        } receiveValue: { value in
//
//        }
    
    let pub = [1, 2, 3]
        .publisher
    
    pub
    
//    let pub2 = 1.words.publisher
//    pub
    
//    dataSource.items.send([])
//    dataSource.items.send(completion: .finished)
//    dataSource.items.send(completion: .finished)
    
    cancellable?.cancel()
}
