//
//  FeedCachePolicy.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 4/12/2024.
//

import Foundation

internal final class FeedCachePolicy {
    private init() {}

    private static let calendar = Calendar(identifier: .gregorian)

    private static var maxCacheAgeInDays: Int {
        7
    }

    internal static func validate(_ timeStamp: Date, against date: Date) -> Bool {
        guard let maxCacheAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timeStamp) else {
            return false
        }

        return date < maxCacheAge
    }
}
