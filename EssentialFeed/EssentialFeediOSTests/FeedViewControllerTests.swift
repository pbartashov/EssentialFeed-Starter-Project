//
//  FeedViewControllerTests.swift
//  EssentialFeediOSTests
//
//  Created by Pavel Bartashov on 29/12/2024.
//

import XCTest


final class FeedViewController {
    init(loader: FeedViewControllerTests.LoaderSpy) {

    }
}


final class FeedViewControllerTests: XCTestCase {

    func test_init_doesnotLoadFeed() {
        let loader = LoaderSpy()
        let _ = FeedViewController(loader: loader)

        XCTAssertEqual(loader.loadCallCount, 0)
    }

    // MARK: - Helpers

    class LoaderSpy {
        private(set) var loadCallCount = 0
    }
}
