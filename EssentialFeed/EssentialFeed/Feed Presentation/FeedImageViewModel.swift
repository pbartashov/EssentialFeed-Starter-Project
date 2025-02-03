//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 3/2/2025.
//

public struct FeedImageViewModel<Image> {
    public let description: String?
    public let location: String?
    public let image: Image?
    public let isLoading: Bool
    public let shouldRetry: Bool

    public var hasLocation: Bool {
        location != nil
    }
}
