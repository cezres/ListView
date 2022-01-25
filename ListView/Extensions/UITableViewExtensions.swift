//
//  UITableViewExtensions.swift
//  ListView
//
//  Created by azusa on 2021/7/19.
//

import UIKit

extension UITableView {
    public func dequeueReusableCell(withModel model: AnyListViewCellModel, for indexPath: IndexPath) -> UITableViewCell {
        register(model.cellClass, forCellReuseIdentifier: model.reuseIdentifier)
        let cell = dequeueReusableCell(withIdentifier: model.reuseIdentifier, for: indexPath)
        model.setupView(cell)
        return cell
    }
}
