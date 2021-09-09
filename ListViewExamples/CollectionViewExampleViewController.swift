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

    let collectionView = ListCollectionView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        collectionView.dataSource = UUIDListDataFetcher()
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
        44
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(hash)
    }

    func setup(in view: UUIDCollectionViewCell) {
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
