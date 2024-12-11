//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 11/12/2024.
//

import Foundation
import CoreData

public final class CoreDataFeedStore: FeedStore {

    public init() {

    }

    public func deleteCachedFeed(_ completion: @escaping DeletionCompletion) {

    }

    public func insert(_ feed: [EssentialFeed.LocalFeedImage], timesStamp: Date, completion: @escaping InsertionCompletion) {

    }

    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }
}

private class ManagedCache: NSManagedObject {
    @NSManaged var timeStamp: Date
    @NSManaged var feed: NSOrderedSet
}

private class ManagedFeedImage: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var imageDescription: String?
    @NSManaged var location: String?
    @NSManaged var url: URL
    @NSManaged var cache: ManagedCache
}
