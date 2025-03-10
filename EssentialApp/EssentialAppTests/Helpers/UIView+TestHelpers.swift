//
//  UIView+TestHelpers.swift
//  EssentialAppTests
//
//  Created by Pavel Bartashov on 10/3/2025.
//

import UIKit

extension UIView {
    func enforceLayoutCycle() {
        layoutIfNeeded()
        RunLoop.current.run(until: Date())
    }
}
