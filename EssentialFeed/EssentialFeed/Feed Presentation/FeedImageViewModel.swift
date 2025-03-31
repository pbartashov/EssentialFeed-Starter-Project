//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 3/2/2025.
//

public struct FeedImageViewModel {
    public let description: String?
    public let location: String?

    public var hasLocation: Bool {
        location != nil
    }
}
