//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 28/11/2024.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    internal let id: UUID
    internal let description: String?
    internal let location: String?
    internal let image: URL
}
