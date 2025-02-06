//
//  ManagedFeedImage.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 13/12/2024.
//

import CoreData

@objc(ManagedFeedImage)
class ManagedFeedImage: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var imageDescription: String?
    @NSManaged var location: String?
    @NSManaged var url: URL
    @NSManaged var data: Data?
    @NSManaged var cache: ManagedCache
}

extension ManagedFeedImage {
    static func first(
        with url: URL,
        in context: NSManagedObjectContext
    ) throws -> ManagedFeedImage? {
        let request = NSFetchRequest<ManagedFeedImage>(entityName: entity().name!)
        request.predicate = NSPredicate(format: "%K = %@", argumentArray: [#keyPath(ManagedFeedImage.url), url])
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1

        return try context.fetch(request).first
    }

    var local: LocalFeedImage {
        LocalFeedImage(id: id, description: imageDescription, location: location, url: url)
    }

    static func images(from feed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
        NSOrderedSet(
            array: feed.map { local in
                let managed = ManagedFeedImage(context: context)
                managed.id = local.id
                managed.imageDescription = local.description
                managed.location = local.location
                managed.url = local.url

                return managed
            }
        )
    }
}
