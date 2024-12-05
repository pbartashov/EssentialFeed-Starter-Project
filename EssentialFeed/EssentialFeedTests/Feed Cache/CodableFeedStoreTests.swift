//
//  CodableFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Pavel Bartashov on 4/12/2024.
//

import XCTest
import EssentialFeed

class CodableFeedStore {
    private struct Cache: Codable {
        let feed: [CodableFeedImage]
        let timesStamp: Date

        var localFeed: [LocalFeedImage] {
            feed.map { $0.local }
        }
    }

    private struct CodableFeedImage: Codable {
        private let id: UUID
        private let description: String?
        private let location: String?
        private let url: URL

        var local: LocalFeedImage {
            LocalFeedImage(id: id, description: description, location: location, url: url)
        }

        init(_ image: LocalFeedImage) {
            id = image.id
            description = image.description
            location = image.location
            url = image.url
        }
    }

    private let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appending(path: "image-feed.store")

    func retrieve(completion: @escaping FeedStore.RetrievalCompletion) {
        guard let data = try? Data(contentsOf: storeURL) else {
            return completion(.empty)
        }

        let decoder = JSONDecoder()
        let cache = try! decoder.decode(Cache.self, from: data)
        completion(.found(feed: cache.localFeed, timeStamp: cache.timesStamp))
    }

    func insert(_ feed: [LocalFeedImage], timesStamp: Date, completion: @escaping FeedStore.InsertionCompletion) {
        let encoder = JSONEncoder()
        let cache = Cache(feed: feed.map(CodableFeedImage.init), timesStamp: timesStamp)
        let data = try! encoder.encode(cache)
        try! data.write(to: storeURL)
        completion(nil)
    }
}

final class CodableFeedStoreTests: XCTestCase {

    override func setUp() {
        super.setUp()

        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appending(path: "image-feed.store")
        try? FileManager.default.removeItem(at: storeURL)
    }

    override func tearDown() {
        super.tearDown()

        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.appending(path: "image-feed.store")
        try? FileManager.default.removeItem(at: storeURL)
    }

    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        let exp = expectation(description: "Wait for cache retrieval")
        sut.retrieve { result in
            switch result {
                case .empty:
                    break

                default:
                    XCTFail("Expected empty result, got \(result) instead")
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1)
    }

    func test_retrieve_hasNoEffectsOnEmptyCache() {
        let sut = makeSUT()
        let exp = expectation(description: "Wait for cache retrieval")
        sut.retrieve { firstResult in
            sut.retrieve { secondResult in
                switch (firstResult, secondResult) {
                    case (.empty, .empty):
                        break

                    default:
                        XCTFail("Expected retrieving twice from empty cache to deliver same empty result, got \(firstResult) and \(secondResult) instead")
                }

                exp.fulfill()
            }
        }

        wait(for: [exp], timeout: 1)
    }

    func test_retrieveAfterInsertingToEmptyCache_deliveresInnsertedValues() {
        let sut = makeSUT()
        let exp = expectation(description: "Wait for cache retrieval")
        let feed = uniqueImageFeed().local
        let timestamp = Date()

        sut.insert(feed, timesStamp: timestamp) { insertionError in
            XCTAssertNil(insertionError, "Expected feed to be inserted successfully")
            sut.retrieve { retrieveResult in
                switch retrieveResult {
                    case let .found(retrievedFeed, retrievedTimeStamp):
                        XCTAssertEqual(retrievedFeed, feed)
                        XCTAssertEqual(retrievedTimeStamp, timestamp)

                    default:
                        XCTFail("Expected retrieving cache, got \(retrieveResult) instead")
                }

                exp.fulfill()
            }
        }

        wait(for: [exp], timeout: 1)
    }
    // MARK: - Helpers

    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> CodableFeedStore {
        let sut = CodableFeedStore()
        trackForMemoryLeaks(sut, file: file, line: line)

        return sut
    }
}
