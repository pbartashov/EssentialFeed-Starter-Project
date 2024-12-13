//
//  XCTestcase+FeedStoreSpecs.swift
//  EssentialFeedTests
//
//  Created by Pavel Bartashov on 10/12/2024.
//

import XCTest
import EssentialFeed

extension FeedStoreSpecs where Self: XCTestCase {

    func assertThatRetrieveDeliversEmptyOnEmptyCache(
        on sut: FeedStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        expect(sut, toRetrive: .empty, file: file, line: line)

    }

    func assertThatRetrieveHasNoSideEffectsOnEmptyCache(
        on sut: FeedStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        expect(sut, toRetriveTwice: .empty, file: file, line: line)
    }

    func assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(
        on sut: FeedStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let feed = uniqueImageFeed().local
        let timestamp = Date()

        insert((feed, timestamp), to: sut)

        expect(sut, toRetrive: .found(feed: feed, timestamp: timestamp), file: file, line: line)
    }

    func assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(
        on sut: FeedStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let feed = uniqueImageFeed().local
        let timestamp = Date()

        insert((feed, timestamp), to: sut)

        expect(sut, toRetriveTwice: .found(feed: feed, timestamp: timestamp), file: file, line: line)
    }

    func assertThatInsertDeliversNoErrorOnEmptyCache(
        on sut: FeedStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let insertionError = insert((uniqueImageFeed().local, Date()), to: sut)

        XCTAssertNil(insertionError, "Expected feed to be inserted successfully", file: file, line: line)
    }

    func assertThatInsertDeliversNoErrorOnNonEmptyCache(
        on sut: FeedStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        insert((uniqueImageFeed().local, Date()), to: sut)

        let insertionError = insert((uniqueImageFeed().local, Date()), to: sut)
        XCTAssertNil(insertionError, "Expected feed to override cache successfully", file: file, line: line)
    }

    func assertThatInsertOverridesPreviouslyInsertedCacheValues(
        on sut: FeedStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        insert((uniqueImageFeed().local, Date()), to: sut)

        let latestFeed = uniqueImageFeed().local
        let latestTimestamp = Date()
        insert((latestFeed, latestTimestamp), to: sut)

        expect(sut, toRetrive: .found(feed: latestFeed, timestamp: latestTimestamp), file: file, line: line)
    }

    func assertThatDeleteDeliversNoErrorOnEmptyCache(
        on sut: FeedStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let deletionError = deleteCache(from: sut)

        XCTAssertNil(deletionError, "Expected empty cache deletion to succeed", file: file, line: line)
    }

    func test_delete_hasNoSideEffectsOnEmptyCache(
        on sut: FeedStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        deleteCache(from: sut)

        expect(sut, toRetrive: .empty, file: file, line: line)
    }

    func assertThatDeleteDeliversNoErrorOnNonEmptyCache(
        on sut: FeedStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        insert((uniqueImageFeed().local, Date()), to: sut)

        let deletionError = deleteCache(from: sut)

        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed", file: file, line: line)
    }

    func assertThatDeleteEmptiesPreviouslyInsertedCache(
        on sut: FeedStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        insert((uniqueImageFeed().local, Date()), to: sut)

        deleteCache(from: sut)

        expect(sut, toRetrive: .empty, file: file, line: line)
    }

    func assertThatSideEffectsRunSerially(
        on sut: FeedStore,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        var completedOperationsInOrder = [XCTestExpectation]()

        let op1 = expectation(description: "Operation 1")
        sut.insert(uniqueImageFeed().local, timesStamp: Date()) { _ in
            completedOperationsInOrder.append(op1)
            op1.fulfill()
        }

        let op2 = expectation(description: "Operation 2")
        sut.deleteCachedFeed { _ in
            completedOperationsInOrder.append(op2)
            op2.fulfill()
        }

        let op3 = expectation(description: "Operation 3")
        sut.retrieve { _ in
            completedOperationsInOrder.append(op3)
            op3.fulfill()
        }

        waitForExpectations(timeout: 1)

        XCTAssertEqual(completedOperationsInOrder, [op1, op2, op3], "Expected side-effects to run in order but operations finished in the wrong order", file: file, line: line)
    }

    @discardableResult
    func insert(
        _ cache: (feed: [LocalFeedImage], timestamp: Date),
        to sut: FeedStore
    ) -> Error? {
        let exp = expectation(description: "Wait for cache insertion")
        var insertionError: Error?
        sut.insert(cache.feed, timesStamp: cache.timestamp) { receivedInsertionError in
            insertionError = receivedInsertionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)

        return insertionError
    }

    @discardableResult
    func deleteCache(
        from sut: FeedStore
    ) -> Error? {
        let exp = expectation(description: "Wait for cache deletion")
        var deletionError: Error?
        sut.deleteCachedFeed { receivedDeletionError in
            deletionError = receivedDeletionError
            exp.fulfill()
        }
        wait(for: [exp], timeout: 1)

        return deletionError
    }

    func expect(
        _ sut: FeedStore,
        toRetrive expectedResult: RetriedCachedFeedResult,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for cache retrieval")

        sut.retrieve { retrievedResult in
            switch (retrievedResult, expectedResult) {
                case (.empty, .empty),
                    (.failure, .failure):
                    break

                case let (.found(expected), .found(retrieved)):
                    XCTAssertEqual(expected.feed, retrieved.feed, file: file, line: line)
                    XCTAssertEqual(expected.timestamp, retrieved.timestamp, file: file, line: line)

                default:
                    XCTFail("Expected to \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1)
    }

    func expect(
        _ sut: FeedStore,
        toRetriveTwice expectedResult: RetriedCachedFeedResult,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        expect(sut, toRetrive: expectedResult, file: file, line: line)
        expect(sut, toRetrive: expectedResult, file: file, line: line)
    }
}
