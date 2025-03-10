//
//  HTTPClientStub.swift
//  EssentialApp
//
//  Created by Pavel Bartashov on 4/3/2025.
//

import Foundation
import EssentialFeed
import EssentialFeedAPI

class HTTPClientStub: HTTPClient {
    private class Task: HTTPClientTask {
        func cancel() {}
    }

    private let stub: (URL) -> HTTPClient.Result

    init(stub: @escaping (URL) -> HTTPClient.Result) {
        self.stub = stub
    }

    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) -> HTTPClientTask {
        completion(stub(url))
        return Task()
    }

    static var offline: HTTPClientStub {
        HTTPClientStub(stub: { _ in .failure(NSError(domain: "offline", code: 0)) })
    }

    static func online(_ stub: @escaping (URL) -> (Data, HTTPURLResponse)) -> HTTPClientStub {
        HTTPClientStub { url in .success(stub(url)) }
    }
}
