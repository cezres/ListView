//
//  ViewController.swift
//  ListViewExamples
//
//  Created by azusa on 2021/7/19.
//

import UIKit
import ListView
import DifferenceKit
import SnapKit

class ViewController: UIViewController {
    lazy var tableView = ListTableView(frame: view.bounds)

    deinit {
        print(#function)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Examples"
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        tableView.dataSource = [
            TableViewCellModel(text: "UIScrollView", action: { [weak self] in
                self.unsafelyUnwrapped
                    .navigationController
                    .unsafelyUnwrapped
                    .pushViewController(ScrollViewExanpleViewController(), animated: true)
            })
        ]
    }
}

struct TableViewCellModel: ListViewCellModel {
    typealias View = TableViewCell

    let text: String

    var action: (TableViewCellModel) -> Void

    func didSelectItem() {
        action(self)
    }

    init(text: String, action: @escaping () -> Void) {
        self.init(text: text) { _ in
            action()
        }
    }

    init(text: String, action: @escaping (TableViewCellModel) -> Void) {
        self.text = text
        self.action = action
    }
}

class TableViewCell: ListTableViewCell<TableViewCellModel> {
    override class func contentHeight(for model: TableViewCellModel) -> CGFloat {
        64
    }

    override func setup(_ model: TableViewCellModel) {
        textLabel?.text = model.text
    }
}
