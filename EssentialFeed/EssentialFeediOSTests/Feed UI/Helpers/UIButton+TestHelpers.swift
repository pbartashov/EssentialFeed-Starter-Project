//
//  UIButton+TestHelpers.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 21/1/2025.
//

import UIKit

extension UIButton {
    func simulateTap() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .touchUpInside)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
