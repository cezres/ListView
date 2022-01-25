//
//  CollectionViewExampleViewController.swift
//  ListViewExamples
//
//  Created by azusa on 2021/9/9.
//

import UIKit
import ListView
import PromiseKit

class CollectionViewExampleViewController: UIViewController {

    let listView = ListView.collectionView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.addSubview(listView)
        listView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

//        listView.dataSource = UUIDListDataFetcher()

        listView.dataSource = [
            UUIDCellModel(hash: "111"),
            UUIDCellModel(hash: "222"),
            UUIDCellModel(hash: "333")
        ]

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.listView.dataSource = [
                UUIDCellModel(hash: "444"),
                UUIDCellModel(hash: "555"),
                UUIDCellModel(hash: "666")
            ]
        }
    }
}

class UUIDListDataFetcher: ListViewDataFetcher {
    override func fetch(start: Int, limit: Int) -> Promise<[AnyListViewCellModel]> {
        .init { resolver in
            resolver.fulfill((0..<limit).map { _ in UUIDCellModel(hash: UUID().uuidString) })
        }
    }
}

struct UUIDCellModel: ListViewCellModel, ListViewCellModelDifferentiable {
    typealias View = UUIDCollectionViewCell

    func contentHeight(for contentView: UIView) -> CGFloat {
        88
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(hash)
    }

    func setupView(_ view: UUIDCollectionViewCell) {
        view.textLabel.text = hash
    }

    let hash: String
}

class UUIDCollectionViewCell: UICollectionViewCell {
    let textLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints {
            $0.left.equalTo(16)
            $0.right.equalTo(-16)
            $0.top.bottom.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
