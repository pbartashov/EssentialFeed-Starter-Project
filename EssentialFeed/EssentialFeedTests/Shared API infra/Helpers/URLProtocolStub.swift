//
//  URLProtocolStub.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 5/2/2025.
//

import Foundation

class URLProtocolStub: URLProtocol {
    private static var _stub: Stub?
    private static var stub: Stub? {
        get { return queue.sync { _stub } }
        set { queue.sync { _stub = newValue } }
    }

    private static let queue = DispatchQueue(label: "URLProtocolStub.queue")

    private struct Stub {
        let onStartLoading: (URLProtocolStub) -> Void
    }

    static func onStartLoading(observer: @escaping () -> Void) {
        stub = Stub(onStartLoading: { _ in observer() })
    }
    
    static func removeStub() {
        stub = nil
    }

    static func stub(data: Data?, response: URLResponse?, error: Error? = nil) {
        stub = Stub(onStartLoading: { urlProtocol in
            guard let client = urlProtocol.client else { return }

            if let data {
                client.urlProtocol(urlProtocol, didLoad: data)
            }

            if let response {
                client.urlProtocol(urlProtocol, didReceive: response, cacheStoragePolicy: .notAllowed)
            }

            if let error {
                client.urlProtocol(urlProtocol, didFailWithError: error)
            } else {
                client.urlProtocolDidFinishLoading(urlProtocol)
            }
        })
    }

    static func observeRequest(observer: @escaping (URLRequest)-> Void) {
        stub = Stub(onStartLoading: { urlProtocol in
            urlProtocol.client?.urlProtocolDidFinishLoading(urlProtocol)
            observer(urlProtocol.request)
        })
    }

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }

    override func startLoading() {
        URLProtocolStub.stub?.onStartLoading(self)
    }

    override func stopLoading() { }
}
