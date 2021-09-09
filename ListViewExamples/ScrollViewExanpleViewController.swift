//
//  ScrollViewExanpleViewController.swift
//  ListViewExamples
//
//  Created by azusa on 2021/8/30.
//

import UIKit
import ListView

class ScrollViewExanpleViewController: UIViewController {
    let scrollView = ListScrollView()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints {
            $0.left.right.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }

        scrollView.dataSource = [
            ColorCellModel(color: .black),
            ColorCellModel(color: .orange),
            TextCellModel(text: "AA"),
            TextCellModel(text: "BB"),
            ColorCellModel(color: .cyan),
            ColorCellModel(color: .green)
        ]

        self.scrollView.dataSource = [
            ColorCellModel(color: .black),
            ColorCellModel(color: .orange),
            TextCellModel(text: "AA"),
            TextCellModel(text: "CC"),
            ColorCellModel(color: .cyan),
            ColorCellModel(color: .green)
        ]

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.scrollView.dataSource = [
                ColorCellModel(color: .orange),
                ColorCellModel(color: .black),
                ColorCellModel(color: .red),
                TextCellModel(text: "CC"),
                TextCellModel(text: "DD")
            ]
        }
    }
}

private struct ColorCellModel: ListViewCellModel, ListViewCellModelDifferentiable {
    typealias View = UIView

    let color: UIColor

    func hash(into hasher: inout Hasher) {
        hasher.combine(color)
    }

    func contentHeight(for contentView: UIView) -> CGFloat {
        100
    }

    func setup(in view: UIView) {
        view.backgroundColor = color
    }
}

private struct TextCellModel: ListViewCellModel, ListViewCellModelDifferentiable {
    typealias View = TextView

    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
    }

    func contentHeight(for contentView: UIView) -> CGFloat {
        44
    }

    func setup(in view: TextView) {
        view.textLabel.text = text
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
