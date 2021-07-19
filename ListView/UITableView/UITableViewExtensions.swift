//
//  UITableViewExtensions.swift
//  ListView
//
//  Created by azusa on 2021/7/19.
//

import UIKit

extension UITableView {
    public func register(_ model: AnyListViewCellModel.Type) {
        register(model.cellClass, forCellReuseIdentifier: model.reuseIdentifier)
    }

    public func dequeueReusableCell(withModel model: AnyListViewCellModel, for indexPath: IndexPath) -> AnyListTableViewCell {
        register(model.cellClass, forCellReuseIdentifier: model.reuseIdentifier)
        let cell = dequeueReusableCell(withIdentifier: model.reuseIdentifier, for: indexPath) as! AnyListTableViewCell
        cell.setup(model)
        return cell
    }

    public func reloadVisibleCells() {
        visibleCells.map {
            ($0, self.indexPath(for: $0)!)
        }.forEach {
            let (cell, indexPath) = $0
            self.delegate?.tableView?(self, willDisplay: cell, forRowAt: indexPath)
        }
    }
}
