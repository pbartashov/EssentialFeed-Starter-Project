//
//  XCTestcase+FailableRetrieveFeedStoreSpecs.swift.swift
//  EssentialFeedTests
//
//  Created by Pavel Bartashov on 10/12/2024.
//

import XCTest
import EssentialFeed

extension FeedStoreSpecs where Self: XCTestCase {
    func assertThatRetrieveDeliversFailureOnRetrievalError(
        on sut: FeedStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        expect(sut, toRetrive: .failure(anyNSError()))
    }

    func assertThatRetrieveHasNoSideEffectsOnFailure(
        on sut: FeedStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        expect(sut, toRetriveTwice: .failure(anyNSError()))
    }
}
