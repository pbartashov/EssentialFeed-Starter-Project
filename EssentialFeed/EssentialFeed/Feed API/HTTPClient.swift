//
//  HTTPClient.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 9/11/2024.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}
