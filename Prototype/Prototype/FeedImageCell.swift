//
//  FeedImageCell.swift
//  Prototype
//
//  Created by Pavel Bartashov on 25/12/2024.
//

import UIKit

final class FeedImageCell: UITableViewCell {
    @IBOutlet private(set) var locationContainer: UIView!
    @IBOutlet private(set) var locationLabel: UILabel!
    @IBOutlet private(set) var feedImageView: UIImageView!
    @IBOutlet private(set) var desctriptionLabel: UILabel!

    override func awakeFromNib() {
        super .awakeFromNib()

        feedImageView.alpha = 0
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        feedImageView.alpha = 0
    }

    func fadeIn(_ image: UIImage?) {
        feedImageView.image = image

        UIView.animate(
            withDuration: 0.3,
            delay: 0.3,
            options: []
        ) {
            self.feedImageView.alpha = 1
        }
    }
}
