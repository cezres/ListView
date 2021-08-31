//
//  ListTableView.swift
//  ListView
//
//  Created by azusa on 2021/7/19.
//

import UIKit
import DifferenceKit

public class ListTableView: UIView {
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
        addSubview(tableView)
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
    }

    public init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds
    }

    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: bounds, style: .plain)
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        return tableView
    }()

}

extension ListTableView {
    func reloadData(data: [AnyListViewCellModel]) {
        guard let newData = data as? [ListViewCellModelDifferentiable & AnyListViewCellModel],
              let oldData = data as? [AnyDifferenceListViewCellModel] else {
            self.data = data
            tableView.reloadData()
            return
        }

        let changeset = StagedChangeset(
            source: oldData,
            target: newData.map {
                AnyDifferenceListViewCellModel(model: $0)
            }
        )

        tableView.reload(using: changeset, with: .none) { result in
            self.data = result
        }
    }
}

extension ListTableView: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        data.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withModel: data[indexPath.row], for: indexPath)
    }
}

extension ListTableView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        data[indexPath.row].contentHeight(for: tableView)
    }

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if dataSource?.hasMoreData == true && indexPath.row > data.count - 4 {
            dataSource?.loadMore().done { [weak self] result in
                self?.reloadData(data: result)
            }.catch { _ in
            }
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.row].didSelectItem()
    }
}
