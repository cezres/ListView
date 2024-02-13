# ListView

# Examples

* [定义Model和与之对应的View](#定义model和与之对应的view)
* [使用Model构建列表视图](#使用model构建列表视图)
* [使用不同类型的Model构建列表视图](#使用不同类型的model构建列表视图)
* [支持 UITableView、UICollectionView、UIScrollView](#支持-uitableviewuicollectionviewuiscrollview)

### 定义Model和与之对应的View

```swift
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
```

### 使用Model构建列表视图

```swift
let listView = ListView.collectionView()

listView.dataSource = [
    UUIDCellModel(hash: "111"),
    UUIDCellModel(hash: "222"),
    UUIDCellModel(hash: "333")
]

// 更新数据源时将会使用`DifferenceKit`计算差异增量更新
DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
    self.listView.dataSource = [
        UUIDCellModel(hash: "111"),
        UUIDCellModel(hash: "222"),
        UUIDCellModel(hash: "444")
    ]
}
```


### 使用不同类型的Model构建列表视图

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
