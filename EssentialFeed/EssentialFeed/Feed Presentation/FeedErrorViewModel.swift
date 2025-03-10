//
//  FeedErrorViewModel.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 30/1/2025.
//

public struct FeedErrorViewModel {
    public let message: String?

    static var noError: Self {
        return FeedErrorViewModel(message: nil)
    }

    static func error(message: String) -> Self {
        return FeedErrorViewModel(message: message)
    }
}
