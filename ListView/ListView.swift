//
//  ListView.swift
//  ListView
//
//  Created by azusa on 2021/7/19.
//

import UIKit

protocol ListView {
    var items: [[AnyListViewCellModel]] { get set }

    var dataSource: ListViewDataSource { get set }
}

extension ListView where Self: UICollectionView {
    func reloadData(_ items: [[AnyListViewCellModel]]) {
    }
}
