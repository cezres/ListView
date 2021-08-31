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
        
        scrollView.data = [
            ScrollViewModelA(color: .black),
            ScrollViewModelA(color: .orange),
            ScrollViewModelB(text: "AA"),
            ScrollViewModelB(text: "BB"),
            ScrollViewModelA(color: .cyan),
            ScrollViewModelA(color: .green),
        ]
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.scrollView.data = [
                ScrollViewModelA(color: .orange),
                ScrollViewModelA(color: .black),
                ScrollViewModelA(color: .red),
                ScrollViewModelB(text: "CC"),
                ScrollViewModelB(text: "DD"),
            ]
        }
    }

}


fileprivate struct ScrollViewModelA: ListViewCellModel, ListViewCellModelDifferentiable {
    typealias View = ScrollViewCellA
    
    let color: UIColor
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(color)
    }
}

fileprivate class ScrollViewCellA: ListScrollViewCell<ScrollViewModelA> {
    override class func contentHeight(for model: ScrollViewModelA) -> CGFloat {
        100
    }
    
    override func setup(_ model: ScrollViewModelA) {
        backgroundColor = model.color
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print(#function)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate struct ScrollViewModelB: ListViewCellModel, ListViewCellModelDifferentiable {
    
    typealias View = ScrollViewCellB
    
    let text: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(text)
    }
}

fileprivate class ScrollViewCellB: ListScrollViewCell<ScrollViewModelB> {
    
    override class func contentHeight(for model: ScrollViewModelB) -> CGFloat {
        44
    }
    
    override func setup(_ model: ScrollViewModelB) {
        textLabel.text = model.text
    }
    
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
