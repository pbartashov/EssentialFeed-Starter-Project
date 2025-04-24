//
//  ListViewController+TestHelpers.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 21/1/2025.
//

import UIKit
import EssentialFeediOS

extension ListViewController {
    public override func loadViewIfNeeded() {
        super.loadViewIfNeeded()

        tableView.frame = CGRect(x: 0, y: 0, width: 1, height: 1)
    }

    var isShowingLoadingIndicator: Bool {
        refreshControl?.isRefreshing == true
    }

    var numberOfRenderedImageViews: Int {
        tableView.numberOfSections == 0 ? 0 : tableView.numberOfRows(inSection: feedImagesSection)
    }

    private var feedImagesSection: Int { 0 }

    func feedImageView(at row: Int) -> UITableViewCell? {
        guard row < numberOfRenderedImageViews else {
            return nil
        }

        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: feedImagesSection)

        return ds?.tableView(tableView, cellForRowAt: index)
    }

    func simulateAppearance() {
        if !isViewLoaded {
            loadViewIfNeeded() //viewDidLoad
            replaceRefreshControlWithFakeForiOS17Support()
        }

        beginAppearanceTransition(true, animated: false) // willAppear
        endAppearanceTransition() // viewIsAppearing + viewDidAppear
    }

    func simulateUserInitiatedFeedReload() {
        refreshControl?.simulatePullToRefresh()
    }

    @discardableResult
    func simulateFeedImageViewVisible(at row: Int) -> FeedImageCell? {
        return feedImageView(at: row) as? FeedImageCell
    }

    @discardableResult
    func simulateFeedImageViewNotVisible(at row: Int) -> FeedImageCell? {
        let view = simulateFeedImageViewVisible(at: row)

        let delegate = tableView.delegate
        let indexPath = IndexPath(row: row, section: feedImagesSection)

        delegate?.tableView?(tableView, didEndDisplaying: view!, forRowAt: indexPath)

        return view
    }

    func simulateImageViewNearVisible(at row: Int) {
        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImagesSection)

        ds?.tableView(tableView, prefetchRowsAt: [index])
    }

    func simulateImageViewNearNotVisible(at row: Int) {
        simulateImageViewNearVisible(at: row)

        let ds = tableView.prefetchDataSource
        let index = IndexPath(row: row, section: feedImagesSection)

        ds?.tableView?(tableView, cancelPrefetchingForRowsAt: [index])
    }

    func simulateTapOnErrorMessage() {
        errorView.simulateTap()
    }

    func renderedFeedImageData(at index: Int) -> Data? {
        return simulateFeedImageViewVisible(at: index)?.renderedImageData
    }

    var errorMessage: String? {
        errorView.message
    }

    func replaceRefreshControlWithFakeForiOS17Support() {
        let fake = FakeRefreshControl()

        refreshControl?.allTargets.forEach { target in
            refreshControl?.actions(forTarget: target, forControlEvent: .valueChanged)?.forEach { action in
                fake.addTarget(target, action: Selector(action), for: .valueChanged)
            }
        }

        refreshControl = fake
    }
}
