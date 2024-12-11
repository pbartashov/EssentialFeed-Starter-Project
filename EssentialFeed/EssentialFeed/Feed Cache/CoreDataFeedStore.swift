//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 11/12/2024.
//

import Foundation
import CoreData

public final class CoreDataFeedStore: FeedStore {
    private let container: NSPersistentContainer
    private let context:NSManagedObjectContext

    public init(storeURL: URL, bundle: Bundle = .main) throws {
        container = try NSPersistentContainer.load(modelName: "FeedStore", storeURL: storeURL, in: bundle)
        context = container.newBackgroundContext()
    }

    public func deleteCachedFeed(_ completion: @escaping DeletionCompletion) {

    }

    public func insert(_ feed: [EssentialFeed.LocalFeedImage], timesStamp: Date, completion: @escaping InsertionCompletion) {

    }

    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }
}

private extension NSPersistentContainer {
    enum LoadingError: Swift.Error {
        case modelNotFound
        case failedToLoadPersistentStores(Swift.Error)
    }

    static func load(modelName name: String, storeURL: URL, in bundle: Bundle) throws -> NSPersistentContainer {
        guard let model = NSManagedObjectModel.with(name: name, in: bundle) else {
            throw LoadingError.modelNotFound
        }

        let description = NSPersistentStoreDescription(url: storeURL)
        let container = NSPersistentContainer(name: name, managedObjectModel: model)
        container.persistentStoreDescriptions = [description]

        var loadError: Swift.Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw LoadingError.failedToLoadPersistentStores($0) }

        return container
    }
}

private extension NSManagedObjectModel {
    static func with(name: String, in bundle: Bundle) -> NSManagedObjectModel? {
        return bundle
            .url(forResource: name, withExtension: "momd")
            .flatMap { NSManagedObjectModel(contentsOf: $0) }
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
