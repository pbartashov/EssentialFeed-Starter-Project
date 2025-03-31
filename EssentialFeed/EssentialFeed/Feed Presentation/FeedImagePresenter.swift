//
//  FeedImagePresenter.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 3/2/2025.
//

import Foundation

public final class FeedImagePresenter {
    public static func map(_ image: FeedImage) -> FeedImageViewModel {
        FeedImageViewModel(
            description: image.description,
            location: image.location
        )
    }
}
