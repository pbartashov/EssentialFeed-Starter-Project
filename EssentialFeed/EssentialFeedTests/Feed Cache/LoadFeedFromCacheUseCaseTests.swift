//
//  LoadFeedFromCacheUseCaseTests.swift
//  EssentialFeedTests
//
//  Created by Pavel Bartashov on 29/11/2024.
//

import XCTest
import EssentialFeed

final class LoadFeedFromCacheUseCaseTests: XCTestCase {

    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()

        XCTAssertEqual(store.receivedMessages, [])
    }

    private func makeSUT(
        currentDate: @escaping () -> Date = Date.init,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: LocalFeedLoader, store: FeedStoreSpy) {
        let store = FeedStoreSpy()
        let sut = LocalFeedLoader(store: store, currentDate: currentDate)

        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, store)
    }

    private func expect(
        _ sut: LocalFeedLoader,
        toCompleteWithError expectedError: NSError?,
        when action: () -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Wait for completion")

        var receivedError: LocalFeedLoader.SaveResult?
        sut.save([uniqueImage()]) { error in
            receivedError = error
            exp.fulfill()
        }

        action()

        wait(for: [exp], timeout: 1)

        XCTAssertEqual(receivedError as? NSError, expectedError, file: file, line: line)
    }

    private func uniqueImage() -> FeedImage {
        FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())
    }

    private func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
        let items = [uniqueImage(), uniqueImage()]
        let localItems = items.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }

        return (items, localItems)
    }

    private func anyURL() -> URL {
        URL(string: "http://any-url.com")!
    }

    private func anyNSError() -> NSError {
        NSError(domain: "any error", code: 0)
    }

    private class FeedStoreSpy: FeedStore {
        enum ReceivedMessage: Equatable {
            case deleteCacheFeed
            case insert([LocalFeedImage], Date)
        }

        private(set) var receivedMessages = [ReceivedMessage]()

        private var deletionCompletions = [DeletionCompletion]()
        private var insertionCompletions = [InsertionCompletion]()

        func deleteCachedFeed(_ completion: @escaping DeletionCompletion) {
            deletionCompletions.append(completion)
            receivedMessages.append(.deleteCacheFeed)
        }

        func completeDeletion(with error: Error, at index: Int = 0) {
            deletionCompletions[index](error)
        }

        func completeDeletionSuccessfully(at index: Int = 0) {
            deletionCompletions[index](nil)
        }

        func insert(_ items: [LocalFeedImage], timesStamp: Date, completion: @escaping InsertionCompletion) {
            insertionCompletions.append(completion)
            receivedMessages.append(.insert(items, timesStamp))
        }

        func completeInsertion(with error: Error, at index: Int = 0) {
            insertionCompletions[index](error)
        }

        func completeInsertionSuccessfully(at index: Int = 0) {
            insertionCompletions[index](nil)
        }
    }
}
