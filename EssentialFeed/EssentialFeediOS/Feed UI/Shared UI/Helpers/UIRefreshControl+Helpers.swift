//
//  UIRefreshControl+Helpers.swift
//  EssentialFeediOS
//
//  Created by Pavel Bartashov on 23/4/2025.
//

import UIKit

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
