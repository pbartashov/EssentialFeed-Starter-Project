//
//  XCTestcase+FailableDeleteFeedStoreSpecs.swift
//  EssentialFeedTests
//
//  Created by Pavel Bartashov on 10/12/2024.
//

import XCTest
import EssentialFeed

extension FeedStoreSpecs where Self: XCTestCase {
    func assertThatDeleteDeliversErrorOnDeletionError(
        on sut: FeedStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let deletionError = deleteCache(from: sut)

        XCTAssertNotNil(deletionError, "Expected cache deletion to fail")
    }

    func assertThatDeleteHasNoSideEffectsOnDeletionError(
        on sut: FeedStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        deleteCache(from: sut)

        expect(sut, toRetrive: .success(.none))
    }
}

