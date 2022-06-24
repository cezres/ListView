//
//  ScrollViewExanpleViewController.swift
//  ListViewExamples
//
//  Created by azusa on 2021/8/30.
//

import UIKit
import ListView

class ScrollViewExanpleViewController: UIViewController {
    let listView = ListView.scrollView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.addSubview(listView)
        listView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        listView.dataSource = [
            ColorListViewCellModel(color: .black),
            ColorListViewCellModel(color: .orange),
            TextListViewCellModel(text: "AA"),
            TextListViewCellModel(text: "BB"),
            ColorListViewCellModel(color: .cyan),
            ColorListViewCellModel(color: .green)
        ]

        listView.dataSource = [
            ColorListViewCellModel(color: .black),
            ColorListViewCellModel(color: .orange),
            TextListViewCellModel(text: "AA"),
            TextListViewCellModel(text: "CC"),
            ColorListViewCellModel(color: .cyan),
            ColorListViewCellModel(color: .green),
            View123(color: .blue),
        ]

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.listView.dataSource = [
                ColorListViewCellModel(color: .orange),
                ColorListViewCellModel(color: .black),
                ColorListViewCellModel(color: .red),
                TextListViewCellModel(text: "CC"),
                TextListViewCellModel(text: "DD"),
                View123(color: .blue),
            ]
        }
    }
}

extension ListViewCellModel where Self: UIView {
    typealias View = Self

    public func setupView(_ view: Self) {
    }
}

extension ListViewCellModel {
    func invalidateIntrinsicContentHeight() {
        
    }
}

private class View123: UIView, ListViewCellModel, ListViewCellModelDifferentiable {
//    typealias View = View123

    func contentHeight(for contentView: UIView) -> CGFloat {
        44
    }
    
    init(color: UIColor) {
        super.init(frame: .init(x: 0, y: 0, width: 0, height: 0))
        backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var hash: Int {
        var hasher = Hasher()
        hasher.combine(type(of: self).description())
        hasher.combine(backgroundColor)
        return hasher.finalize()
    }
}

private struct ColorListViewCellModel: ListViewCellModel, ListViewCellModelDifferentiable {
    typealias View = UIView

    let color: UIColor

    func hash(into hasher: inout Hasher) {
        hasher.combine(color)
    }

    func contentHeight(for contentView: UIView) -> CGFloat {
        100
    }

    func setupView(_ view: UIView) {
        view.backgroundColor = color
    }

    func didSelectItem() {
        print("\(reuseIdentifier)  \(self)")
    }
}

private struct TextListViewCellModel: ListViewCellModel, ListViewCellModelDifferentiable {
    typealias View = TextView

    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
    }

    func contentHeight(for contentView: UIView) -> CGFloat {
        44
    }

    func setupView(_ view: TextView) {
        view.textLabel.text = text
    }

    func didSelectItem() {
        print("\(reuseIdentifier)  \(self)")
    }

    let text: String
}

private class TextView: UIView {
    let textLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(textLabel)
        textLabel.snp.makeConstraints {
            $0.left.equalTo(16)
            $0.top.bottom.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
