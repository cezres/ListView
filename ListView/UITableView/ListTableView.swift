//
//  ListTableView.swift
//  ListView
//
//  Created by azusa on 2021/7/19.
//

import UIKit

public class ListTableView: UIView {

    public var data: ListViewData? {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var items: [AnyListViewCellModel] {
        data?.items ?? []
    }

    public init() {
        super.init(frame: .init(x: 0, y: 0, width: 0, height: 0))
        addSubview(tableView)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
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

extension ListTableView: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withModel: items[indexPath.row], for: indexPath)
    }

}

extension ListTableView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        items[indexPath.row].contentSize(for: tableView).height
    }
    
}
