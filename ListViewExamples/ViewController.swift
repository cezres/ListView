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
            ExampleCellModel(text: "UIScrollView", action: { [weak self] in
                self?.navigationController?.pushViewController(ScrollViewExanpleViewController(), animated: true)
            }),
            ExampleCellModel(text: "UICollectionView", action: { [weak self] in
                self?.navigationController?.pushViewController(CollectionViewExampleViewController(), animated: true)
            })
        ]
    }
}

struct ExampleCellModel: ListViewCellModel {
    typealias View = UITableViewCell

    func contentHeight(for contentView: UIView) -> CGFloat {
        64
    }

    func setup(in view: UITableViewCell) {
        view.textLabel?.text = text
    }

    func didSelectItem() {
        action()
    }

    let text: String

    let action: () -> Void

    init(text: String, action: @escaping () -> Void) {
        self.text = text
        self.action = action
    }
}
