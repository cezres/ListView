//
//  Array+ListViewDataSource.swift
//  ListView
//
//  Created by azusa on 2021/8/25.
//

import Foundation

extension Array: ListViewDataSource where Element: AnyListViewCellModel {
    public var items: [AnyListViewCellModel] {
        self
    }
}
