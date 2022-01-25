//
//  ListView.swift
//  ListView
//
//  Created by azusa on 2021/7/19.
//

import UIKit
import DifferenceKit

public class ListView<View: UIView>: UIView, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public var dataSource: ListViewDataSource? {
        didSet {
            if Thread.isMainThread {
                refreshData()
            } else {
                DispatchQueue.main.async {
                    self.refreshData()
                }
            }
        }
    }

    public let view: View

    public var emptyCellModel: AnyListViewCellModel?

    private var data = [AnyListViewCellModel]()

    // MARK: Init

    public static func tableView() -> ListView<UITableView> {
        let tableView = UITableView(frame: .zero, style: .plain)
        let listView = ListView<UITableView>(view: tableView)
        tableView.backgroundColor = .white
        tableView.delegate = listView
        tableView.dataSource = listView
        tableView.tableFooterView = UIView()
        return listView
    }

    public static func collectionView() -> ListView<UICollectionView> {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        let listView = ListView<UICollectionView>(view: collectionView)
        collectionView.dataSource = listView
        collectionView.delegate = listView
        collectionView.backgroundColor = .white
        return listView
    }

    public static func scrollView() -> ListView<UIScrollView> {
        let scrollView = ListScrollView()
        let listView = ListView<UIScrollView>(view: scrollView)
        return listView
    }

    private init(view: View) {
        self.view = view
        super.init(frame: .zero)
        addSubview(view)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UITableView

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withModel: data[indexPath.row], for: indexPath)
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        data[indexPath.row].contentHeight(for: tableView)
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tryLoadMoreData(indexPath: indexPath)
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.row].didSelectItem()
    }

    // MARK: - UICollectionView

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.dequeueReusableCell(withModel: data[indexPath.row], for: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: collectionView.bounds.size.width, height: data[indexPath.row].contentHeight(for: collectionView))
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        tryLoadMoreData(indexPath: indexPath)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        data[indexPath.row].didSelectItem()
    }

    // MARK: - Override

    public override var backgroundColor: UIColor? {
        didSet {
            super.backgroundColor = backgroundColor
            view.backgroundColor = backgroundColor
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        view.frame = bounds
    }
}

// MARK: - Reload Data

extension ListView {
    private var tableView: UITableView? { view as? UITableView }
    private var collectionView: UICollectionView? { view as? UICollectionView }
    private var scrollView: ListScrollView? { view as? ListScrollView }

    public func refreshData() {
        if let data = dataSource as? [AnyListViewCellModel] {
            if data.isEmpty, let emptyCellModel = emptyCellModel {
                reloadData(data: [emptyCellModel])
            } else {
                reloadData(data: data)
            }
        } else {
            dataSource?.refresh().done { [weak self] result in
                if result.isEmpty, let emptyCellModel = self?.emptyCellModel {
                    self?.reloadData(data: [emptyCellModel])
                } else {
                    self?.reloadData(data: result)
                }
            }.catch { _ in

            }.finally { [weak self] in
                if let scrollView = self?.view as? UIScrollView {
                    scrollView.refreshControl?.endRefreshing()
                }
            }
        }
    }

    func tryLoadMoreData(indexPath: IndexPath) {
        guard indexPath.row + 6 > data.count && dataSource?.hasMoreData ?? false else {
            return
        }
        dataSource?.loadMore().done { [weak self] result in
            self?.reloadData(data: result)
        }.catch { _ in
        }
    }

    func reloadData(data: [AnyListViewCellModel]) {
        if let scrollView = scrollView {
            scrollView.dataSource = data
            return
        }

        guard let newData = data as? [ListViewCellModelDifferentiable & AnyListViewCellModel],
              let oldData = self.data as? [AnyDifferenceListViewCellModel] else {
            self.data = data
            tableView?.reloadData()
            collectionView?.reloadData()
            return
        }

        let changeset = StagedChangeset(
            source: oldData,
            target: newData.map {
                AnyDifferenceListViewCellModel(model: $0)
            }
        )

//        print("stagedChangeset:")
//        for item in changeset {
//            print("""
//                changeset:
//                    elementDeleted: \(item.elementDeleted.count)
//                    elementInserted: \(item.elementInserted.count)
//                    elementMoved: \(item.elementMoved.count)
//                    elementUpdated: \(item.elementUpdated.count)
//            """)
//        }

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        tableView?.reload(using: changeset, with: .none) { result in
            self.data = result
        }
        collectionView?.reload(using: changeset) { result in
            self.data = result
        }
        CATransaction.commit()
    }
}
