//
//  XCTestcase+FailableInsertFeedStoreSpecs.swift.swift
//  EssentialFeedTests
//
//  Created by Pavel Bartashov on 10/12/2024.
//

import XCTest
import EssentialFeed

extension FeedStoreSpecs where Self: XCTestCase {
    func assertThatInsertDeliversErrorOnInsertionError(
        on sut: FeedStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let feed = uniqueImageFeed().local
        let timestamp = Date()

        let insertionError = insert((feed, timestamp), to: sut)

        XCTAssertNotNil(insertionError, "Expected cache insertion to fail with an error")
    }

    func assertThatInsertHasNoSideEffectsOnInsertionError(
        on sut: FeedStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let feed = uniqueImageFeed().local
        let timestamp = Date()

        insert((feed, timestamp), to: sut)

        expect(sut, toRetrive: .empty)
    }
}
