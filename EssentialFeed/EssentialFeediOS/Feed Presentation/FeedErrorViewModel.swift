//
//  FeedErrorViewModel.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 29/1/2025.
//

struct FeedErrorViewModel {
    let message: String?

    static func error(_ message: String) -> Self {
        return FeedErrorViewModel(message: message)
    }

    static func none() -> Self {
        return FeedErrorViewModel(message: nil)
    }
}
