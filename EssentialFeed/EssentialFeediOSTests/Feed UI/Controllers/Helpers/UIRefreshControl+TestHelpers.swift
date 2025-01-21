//
//  UIRefreshControl+TestHelpers.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 21/1/2025.
//

import UIKit

extension UIRefreshControl {
    func simulatePullToRefresh() {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: .valueChanged)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}
