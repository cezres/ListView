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
            .init(color: .brown, action: didSelectItem),
            .init(color: .black, action: didSelectItem),
            .init(color: .gray, action: didSelectItem),
            .init(color: .cyan, action: didSelectItem),
            .init(color: .orange, action: didSelectItem),
        ]
        listView.data = items
    }

//    lazy var listView = ListCollectionView(frame: view.bounds)
    lazy var listView = ListTableView(frame: view.bounds)

    func didSelectItem(_ model: CustomListViewCellModel) {
        print(model.color)
    }
}

struct CustomListViewCellModel: ListViewCellModel {
//    typealias View = CustomListCollectionViewCell
    typealias View = CustomListTableViewCell
    
    let color: UIColor
    
    var action: (CustomListViewCellModel) -> Void
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
