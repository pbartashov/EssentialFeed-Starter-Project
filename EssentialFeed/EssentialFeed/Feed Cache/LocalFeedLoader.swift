//
//  LocalFeedLoader.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 28/11/2024.
//

import Foundation

public final class LocalFeedLoader {
    private let store: FeedStore
    private let currentDate: () -> Date
    private let calendar = Calendar(identifier: .gregorian)

    public typealias SaveResult = Error?
    public typealias LoadResult = LoadFeedResult

    public init(store: FeedStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }

    public func save(_ feed: [FeedImage], _ completion: @escaping (SaveResult?) -> Void) {
        store.deleteCachedFeed { [weak self] error in
            guard let self = self else { return }
            if let deletionError = error {
                completion(deletionError)
            } else {
                cache(feed, with: completion)
            }
        }
    }

    public func load(completion: @escaping (LoadResult) -> Void) {
        store.retrieve { [weak self] result in
            guard let self = self else { return }
            switch result {
                case let .failure(error):
                    completion(.failure(error))

                case let .found(feed, timeStamp) where self.validate(timeStamp):
                    completion(.success(feed.toModels()))

                case .found:
                    completion(.success([]))

                case .empty:
                    completion(.success([]))
            }
        }
    }

    public func validateCache() {
        store.retrieve { [weak self] error in
            guard let self = self else { return }
            switch error {
                case .failure:
                    self.store.deleteCachedFeed { _ in }

                case let .found(_, timeStamp) where !self.validate(timeStamp):
                    self.store.deleteCachedFeed { _ in }

                case .empty, .found:
                    break
            }
        }
    }

    private func cache(_ items: [FeedImage], with completion: @escaping (SaveResult?) -> Void) {
        store.insert(items.toLocal(), timesStamp: currentDate()) { [weak self] error in
            guard self != nil else { return }
            completion(error)
        }
    }

    private var maxCacheAgeInDays: Int {
        7
    }

    private func validate(_ timeStamp: Date) -> Bool {
         guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timeStamp) else {
            return false
        }

        return currentDate() < maxCacheAge
    }
}

private extension Array where Element == FeedImage {
    func toLocal() -> [LocalFeedImage] {
        self.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    }
}

private extension Array where Element == LocalFeedImage {
    func toModels() -> [FeedImage] {
        self.map { FeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    }
}
