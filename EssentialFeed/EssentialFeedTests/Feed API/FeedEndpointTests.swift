//
//  FeedEndpointTests.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 8/5/2025.
//

import XCTest
import EssentialFeed
import EssentialFeedAPI

class FeedEndpointTests: XCTestCase {

    func test_feed_endpointURL() {
        let baseURL = URL(string: "http://base-url.com")!

        let received = FeedEndpoint.get.url(baseURL: baseURL)
        let expected = URL(string: "http://base-url.com/v1/feed")!

        XCTAssertEqual(received, expected)
    }

}
