//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Pavel Bartashov on 4/11/2024.
//

import XCTest
import EssentialFeed

final class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()

        XCTAssertTrue(client.requestedURLs.isEmpty)
    }

    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url])
    }

    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }
        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }

    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)

        })
    }

    func test_load_deliversErrorNon200HTTPResponse() throws {
        let (sut, client) = makeSUT()

        let sample = [199, 201, 300, 400, 500]

        try sample.enumerated().forEach { index, code in
            try expect(sut, toCompleteWith: failure(.invalidData), when: {
                let json = try makeItemsJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }

    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: failure(.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }

    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() throws {
        let (sut, client) = makeSUT()

        try expect(sut, toCompleteWith: .success([]), when: {
            let emptyListJSON = try makeItemsJSON([])
            client.complete(withStatusCode: 200, data: emptyListJSON)
        })
    }

    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        let (sut, client) = makeSUT()

        let item1 = makeItem(
            id: UUID(),
            url: URL(string: "http:///a-url.com")!
        )

        let item2 = makeItem(
            id: UUID(),
            description: "a description",
            location: "a location",
            url: URL(string: "http:///another-url.com")!
        )

        let items = [item1.model, item2.model]

        try expect(sut, toCompleteWith: .success(items), when: {
            let json = try makeItemsJSON([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: json)
        })
    }

    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() throws {
        let url = URL(string: "https://any-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteFeedLoader? = RemoteFeedLoader(url: url, client: client)

        var capturedResults = [RemoteFeedLoader.Result]()
        sut?.load { capturedResults.append($0) }

        sut = nil

        client.complete(withStatusCode: 200, data: try makeItemsJSON([]))

        XCTAssertTrue(capturedResults.isEmpty)
    }

    // MARK: - Helpers

    private func makeSUT(
        url: URL = URL(string: "https://a-url.com")!,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (RemoteFeedLoader, HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)

        trackForMemoryLeaks(sut)
        trackForMemoryLeaks(client)

        return (sut, client)
    }

    private func failure(_ error: RemoteFeedLoader.Error) ->RemoteFeedLoader.Result {
        .failure(error)
    }

    private func makeItem(
        id: UUID,
        description: String? = nil,
        location: String? = nil,
        url: URL
    ) -> (model: FeedImage, json: [String: Any]) {
        let item = FeedImage(id: id, description: description, location: location, url: url)

        let json = [
            "id": item.id.uuidString,
            "description": item.description,
            "location": item.location,
            "image": item.url.absoluteString
        ].compactMapValues { $0 }

        return (item, json)
    }

    private func makeItemsJSON(_ items: [[String: Any]]) throws -> Data {
        let items = ["items": items]
        return try JSONSerialization.data(withJSONObject: items)
    }

    private func expect(
        _ sut: RemoteFeedLoader,
        toCompleteWith expectedResult: RemoteFeedLoader.Result,
        when action: () throws -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) rethrows {
        let exp = expectation(description: "Wait for load completion")
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
                case let (.success(receivedItems), .success(expectedItems)):
                    XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
                case let (.failure(receivedError as RemoteFeedLoader.Error), .failure(expectedError as RemoteFeedLoader.Error)):
                    XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                default:
                    XCTFail("Expected result \(expectedResult) but received \(receivedResult)", file: file, line: line)
            }

            exp.fulfill()
        }

        try action()

        wait(for: [exp], timeout: 10)
    }

    private final class HTTPClientSpy: HTTPClient {
        var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        var requestedURLs: [URL] {
            messages.map {
                $0.url
            }
        }
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }

        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }

        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!

            messages[index].completion(.success(data, response))
        }
    }
}
