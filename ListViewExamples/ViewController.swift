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
    
    lazy var listView = ListCollectionView(frame: view.bounds)
    
    lazy var items: [CustomListViewCellModel] = [] {
        didSet {
            listView.data = items
        }
    }
    
    deinit {
        print(#function)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.addSubview(listView)
        listView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        let weakDidSelectItem: (CustomListViewCellModel) -> Void = { [weak self](_ model: CustomListViewCellModel) in
            self?.didSelectItem(model)
        }

        items = [
            .init(color: .brown, action: weakDidSelectItem),
            .init(color: .black, action: weakDidSelectItem),
            .init(color: .gray, action: weakDidSelectItem),
            .init(color: .cyan, action: weakDidSelectItem),
            .init(color: .orange, action: weakDidSelectItem),
        ]
    }

    func didSelectItem(_ model: CustomListViewCellModel) {
        print(model.color)
    }

}

struct CustomListViewCellModel: ListViewCellModel, ListViewCellModelDifferentiable {
    
    typealias View = CustomListCollectionViewCell
    
    let color: UIColor
    
    var action: (CustomListViewCellModel) -> Void
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(color)
    }
    
    func didSelectItem() {
        action(self)
    }

}

class CustomListCollectionViewCell: ListCollectionViewCell<CustomListViewCellModel> {
    
    override class func contentHeight(for model: CustomListViewCellModel) -> CGFloat {
        44 + CGFloat(arc4random_uniform(60))
    }
    
    override func setup(_ model: CustomListViewCellModel) {
        contentView.backgroundColor = model.color
    }
    
}
