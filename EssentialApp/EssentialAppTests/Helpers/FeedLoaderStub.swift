//
//  FeedLoaderStub.swift
//  EssentialApp
//
//  Created by Pavel Bartashov on 20/2/2025.
//

import EssentialFeed

class FeedLoaderStub: FeedLoader {
    private let result: FeedLoader.Result

    init(result: FeedLoader.Result) {
        self.result = result
    }

    func load(completion: @escaping (FeedLoader.Result) -> Void) {
        completion(result)
    }
}
