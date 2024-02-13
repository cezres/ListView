# ListView

# Examples

* [定义 Model 和与之对应的 View](#定义-model-和与之对应的-view)
* [使用 Model 构建列表视图](#使用-model-构建列表视图)
* [使用不同类型的 Model 构建列表视图](#使用不同类型的-model-构建列表视图)
* [支持 UITableView、UICollectionView、UIScrollView](#支持-uitableviewuicollectionviewuiscrollview)
* [使用 DataFetcher 简化数据分页列表的数据加载](#使用-datafetcher-简化数据分页列表的数据加载)

### 定义 Model 和与之对应的 View

```swift
struct UUIDCellModel: ListViewCellModel, ListViewCellModelDifferentiable {
    typealias View = UUIDCollectionViewCell

    func contentHeight(for contentView: UIView) -> CGFloat {
        88
    }

    func didSelectItem() {
        /// 处理选中事件
    }

    /// 可选实现 ListViewCellModelDifferentiable 协议以支持数据源差异计算。
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }

    /// 使用当前 Model 更新视图数据
    func setupView(_ view: UUIDCollectionViewCell) {
        view.textLabel.text = uuid
    }

    let uuid: String
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
```

### 使用 Model 构建列表视图

```swift
let listView = ListView.collectionView()

listView.dataSource = [
    UUIDCellModel(hash: "111"),
    UUIDCellModel(hash: "222"),
    UUIDCellModel(hash: "333")
]

// 更新数据源时将会使用 DifferenceKit 计算差异增量更新
DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    self.listView.dataSource = [
        UUIDCellModel(hash: "111"),
        UUIDCellModel(hash: "222"),
        UUIDCellModel(hash: "444")
    ]
}
```


### 使用不同类型的 Model 构建列表视图

```swift
let listView = ListView.scrollView()

listView.dataSource = [
    ColorListViewCellModel(color: .black),
    ColorListViewCellModel(color: .orange),
    TextListViewCellModel(text: "AA"),
    TextListViewCellModel(text: "BB"),
    ColorListViewCellModel(color: .cyan),
    ColorListViewCellModel(color: .green)
]
```

### 支持 UITableView、UICollectionView、UIScrollView

```swift
let listView = ListView.scrollView()
let listView = ListView.collectionView()
let listView = ListView.tableView()
```

### 使用 DataFetcher 简化数据分页列表的数据加载

```swift
class UUIDListDataFetcher: ListViewDataFetcher {
    override func fetch(start: Int, limit: Int) -> Promise<[AnyListViewCellModel]> {
        .init { resolver in
            resolver.fulfill((0..<limit).map { _ in UUIDCellModel(hash: UUID().uuidString) })
        }
    }
}

...

let listView = ListView.collectionView()
listView.dataSource = UUIDListDataFetcher()
```