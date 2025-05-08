//
//  FeedEndpoint.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 8/5/2025.
//


import Foundation

public enum FeedEndpoint {
    case get

    public func url(baseURL: URL) -> URL {
        switch self {
            case .get:
                return baseURL.appendingPathComponent("/v1/feed")
        }
    }
}
