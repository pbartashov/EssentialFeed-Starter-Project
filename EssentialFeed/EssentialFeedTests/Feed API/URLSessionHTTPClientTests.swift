//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Pavel Bartashov on 11/11/2024.
//

import XCTest

class URLSessionHTTPClient {
    private let session: URLSession

    init (session: URLSession) {
        self.session = session
    }

    func get(from url: URL) {
        session.dataTask(with: url) { _, _, _ in

        }
    }
}


final class URLSessionHTTPClientTests: XCTestCase {

    func test_getFromURL_createsDataTaskWithURL() {
        let url = URL(string: "http://any-url.com")!
        let session = URLSessionSpy()

        let sut = URLSessionHTTPClient(session: session)
        sut.get(from: url)

        XCTAssertEqual(session.receivedURLS, [url])
    }

    // MARK: - Helpers

    private class URLSessionSpy: URLSession {
        var receivedURLS = [URL]()

        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, (any Error)?) -> Void) -> URLSessionDataTask {
            receivedURLS.append(url)

            return URLSessionDataTask()
        }
    }

    private class FakeURLSessionDataTask: URLSessionDataTask {

    }

}
