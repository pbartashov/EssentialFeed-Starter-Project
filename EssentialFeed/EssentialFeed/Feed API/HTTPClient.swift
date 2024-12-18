//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 9/11/2024.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate thread, if needed.
    func get(from url: URL, completion: @escaping (Result) -> Void)
}
