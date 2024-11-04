//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Pavel Bartashov on 4/11/2024.
//

import XCTest

class RemoteFeedLoader {

    let client: HTTPClient
    let url: URL

    init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }

    func load() {
        client.get(from: url)
    }
}

protocol HTTPClient {
    func get(from url: URL)
}

class HTTPClientSpy: HTTPClient {
    var requestedURL: URL?

    func get(from url: URL) {
        requestedURL = url
    }
}

final class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let url = URL(string: "https://a-url.com")!
        let client = HTTPClientSpy()
        _ = RemoteFeedLoader(url: url, client: client)

        XCTAssertNil(client.requestedURL)
    }

    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://a-given-url.com")!
        let client = HTTPClientSpy()
        let loader = RemoteFeedLoader(url: url, client: client)

        loader.load()
        
        XCTAssertEqual(client.requestedURL, url)
    }

}
