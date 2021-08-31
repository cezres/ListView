//
//  Extensions.swift
//  ListViewExamples
//
//  Created by azusa on 2021/8/30.
//

import UIKit

extension UIColor {
    var random: UIColor {
        .init(
            red: CGFloat(arc4random_uniform(255)) / 255,
            green: CGFloat(arc4random_uniform(255)) / 255,
            blue: CGFloat(arc4random_uniform(255)) / 255,
            alpha: 1.0
        )
    }
}
