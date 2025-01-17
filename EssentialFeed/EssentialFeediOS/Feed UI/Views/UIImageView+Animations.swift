//
//  UIImageView+Animations.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 17/1/2025.
//

import UIKit

extension UIImageView {
    func setImageAnimated(_ newImage: UIImage?) {
        image = newImage
        guard newImage != nil else { return }

        alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
}
