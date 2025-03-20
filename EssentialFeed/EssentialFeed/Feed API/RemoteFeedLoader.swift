//
//  RemoteFeedLoader.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 4/11/2024.
//

import Foundation
import EssentialFeed


public typealias RemoteFeedLoader = RemoteLoader<[FeedImage]>

public extension RemoteFeedLoader {
    convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: FeedItemsMapper.map)
    }
}
