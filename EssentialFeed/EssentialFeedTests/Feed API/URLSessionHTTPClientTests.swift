//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Pavel Bartashov on 11/11/2024.
//

import XCTest
import EssentialFeed

class URLSessionHTTPClient {
    private let session: URLSession

    init (session: URLSession = .shared) {
        self.session = session
    }

    struct UnexpectedValuesRepresentationError: Error { }

    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        session.dataTask(with: url) { _, _, error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.failure(UnexpectedValuesRepresentationError()))
            }
        }
        .resume()
    }
}

final class URLSessionHTTPClientTests: XCTestCase {

    override func setUp() {
        super.setUp()
        URLProtocolStub.startInterceptingRequests()
    }

    override func tearDown() {
        super.tearDown()
        URLProtocolStub.stopInterceptingRequests()
    }

    func test_getFromURL_performsGETRequestWithURL() {
        let url = anyURL()
        let exp = expectation(description: "Wait for request")

        URLProtocolStub.observeRequest { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }

        makeSUT().get(from: url) { _ in }

        wait(for: [exp], timeout: 1)
    }

    func test_getFromURL_failsOnRequestError() {
        let error = NSError(domain: "any error", code: 1)
        URLProtocolStub.stub(data: nil, response: nil, error: error)

        let exp = expectation(description: "Wait for comletion")

        makeSUT().get(from: anyURL()) { result in
            switch result {
                case let .failure(receivedError as NSError):
                    XCTAssertEqual(error.domain, receivedError.domain)
                    XCTAssertEqual(error.code, receivedError.code)
                default:
                    XCTFail("Expected failure with error \(error), got \(result) instead")
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1)
    }

    func test_getFromURL_failsOnAllNilValues() {
        URLProtocolStub.stub(data: nil, response: nil, error: nil)

        let exp = expectation(description: "Wait for comletion")

        makeSUT().get(from: anyURL()) { result in
            switch result {
                case .failure:
                    break
                default:
                    XCTFail("Expected failure, got \(result) instead")
            }

            exp.fulfill()
        }

        wait(for: [exp], timeout: 1)
    }

    // MARK: - Helpers

    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> URLSessionHTTPClient {
        let sut = URLSessionHTTPClient()
        trackForMemoryLeaks(sut)

        return sut
    }

    private func anyURL() -> URL {
        URL(string: "http://any-url.com")!
    }

    private class URLProtocolStub: URLProtocol {
        private static var stub: Stub?
        private static var requestObserver: ((URLRequest) -> Void)?

        private struct Stub {
            let data: Data?
            let response: URLResponse?
            let error: Error?
        }

        static func startInterceptingRequests() {
            registerClass(URLProtocolStub.self)
        }

        static func stopInterceptingRequests() {
            unregisterClass(URLProtocolStub.self)
            stub = nil
            requestObserver = nil
        }

        static func stub(data: Data?, response: URLResponse?, error: Error? = nil) {
            stub = Stub(data: data, response: response, error: error)
        }

        static func observeRequest(observer: @escaping (URLRequest)-> Void) {
            requestObserver = observer
        }

        override class func canInit(with request: URLRequest) -> Bool {
            requestObserver?(request)
            return true
        }

        override class func canonicalRequest(for request: URLRequest) -> URLRequest {
            return request
        }

        override func startLoading() {
            guard let stub = URLProtocolStub.stub else { return }

            if let data = stub.data {
                client?.urlProtocol(self, didLoad: data)
            }

            if let response = stub.response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }

            if let error = stub.error {
                client?.urlProtocol(self, didFailWithError: error)
            }

            client?.urlProtocolDidFinishLoading(self)
        }

        override func stopLoading() { }
    }
}
