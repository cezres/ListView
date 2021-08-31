//
//  ListCollectionView.swift
//  ListView
//
//  Created by azusa on 2021/7/19.
//

import UIKit
import DifferenceKit

public class ListCollectionView: UIView {
    public var dataSource: ListViewDataSource? {
        didSet {
            dataSource?.refresh().done(on: .main) { [weak self] result in
                self?.reloadData(data: result)
            }.catch { _ in
            }
        }
    }

    private var data: [AnyListViewCellModel] = []

    public init() {
        super.init(frame: .init(x: 0, y: 0, width: 0, height: 0))
        addSubview(collectionView)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = bounds
    }

    public override var backgroundColor: UIColor? {
        didSet {
            super.backgroundColor = backgroundColor
            collectionView.backgroundColor = backgroundColor
        }
    }

    public lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        return collectionView
    }()
}

extension ListCollectionView {
    func reloadData(data: [AnyListViewCellModel]) {
        guard let newData = data as? [ListViewCellModelDifferentiable & AnyListViewCellModel],
              let oldData = data as? [AnyDifferenceListViewCellModel] else {
            self.data = data
            collectionView.reloadData()
            return
        }

        let changeset = StagedChangeset(
            source: oldData,
            target: newData.map {
                AnyDifferenceListViewCellModel(model: $0)
            }
        )

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        collectionView.reload(using: changeset) { result in
            self.data = result
        }
        CATransaction.commit()
    }
}

extension ListCollectionView: UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withModel: data[indexPath.row], for: indexPath)
    }
}

extension ListCollectionView: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.frame.width, height: data[indexPath.row].contentHeight(for: collectionView))
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (dataSource?.hasMoreData ?? false) && indexPath.row > data.count - 4 {
            dataSource?.loadMore().done { [weak self] result in
                self?.reloadData(data: result)
            }.catch { _ in
            }
        }
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        data[indexPath.row].didSelectItem()
    }
}
