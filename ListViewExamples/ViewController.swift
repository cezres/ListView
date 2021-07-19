//
//  ViewController.swift
//  ListViewExamples
//
//  Created by azusa on 2021/7/19.
//

import UIKit
import ListView

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.addSubview(listView)
        
        let items: [CustomListViewCellModel] = [
            .init(color: .brown),
            .init(color: .black),
            .init(color: .gray),
            .init(color: .cyan),
            .init(color: .orange),
        ]
        listView.data = items
    }

//    lazy var listView = ListCollectionView(frame: view.bounds)
    lazy var listView = ListTableView(frame: view.bounds)
}

struct CustomListViewCellModel: ListViewCellModel {
//    typealias View = CustomListCollectionViewCell
    typealias View = CustomListTableViewCell
    
    let color: UIColor
}

class CustomListCollectionViewCell: ListCollectionViewCell<CustomListViewCellModel> {
    override class func contentHeight(for model: CustomListViewCellModel) -> CGFloat {
        44 + CGFloat(arc4random_uniform(60))
    }
    
    override func setup(_ model: CustomListViewCellModel) {
        contentView.backgroundColor = model.color
    }
}

class CustomListTableViewCell: ListTableViewCell<CustomListViewCellModel> {
    override class func contentHeight(for model: CustomListViewCellModel) -> CGFloat {
        44 + CGFloat(arc4random_uniform(60))
    }
    
    override func setup(_ model: CustomListViewCellModel) {
        contentView.backgroundColor = model.color
    }
}
