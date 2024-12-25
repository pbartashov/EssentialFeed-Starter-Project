//
//  FeedViewController.swift
//  Prototype
//
//  Created by Pavel Bartashov on 25/12/2024.
//

import UIKit

struct FeedImageViewModel {
    let description: String?
    let location: String?
    let imageName: String
}

final class FeedViewController: UITableViewController {

    private let feed = FeedImageViewModel.prototypeFeed

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        feed.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FeedImageCell") as! FeedImageCell
        let model = feed[indexPath.row]
        cell.configure(with: model)

        return cell
    }
}

extension FeedImageCell {
    func configure(with model: FeedImageViewModel) {
        locationLabel.text = model.location
        locationContainer.isHidden = model.location == nil

        desctriptionLabel.text = model.description
        desctriptionLabel.isHidden = model.description == nil

        fadeIn(UIImage(named: model.imageName))
    }
}
