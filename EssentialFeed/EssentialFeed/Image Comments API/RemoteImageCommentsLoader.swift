//
//  RemoteImageCommentsLoader.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 20/3/2025.
//

import Foundation
import EssentialFeed


public typealias RemoteImageCommentsLoader = RemoteLoader<[ImageComment]>

public extension RemoteImageCommentsLoader {
    convenience init(url: URL, client: HTTPClient) {
        self.init(url: url, client: client, mapper: ImageCommentsMapper.map)
    }
}
