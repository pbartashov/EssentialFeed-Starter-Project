//
//  FeedUIIntegrationTests+Localization.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 21/1/2025.
//

import XCTest
import EssentialFeediOS

extension FeedUIIntegrationTests {
    func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "Feed"
        let bundle = Bundle(for: FeedViewController.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: table)

        if value == key {
            XCTFail("Missing localized key for key: \(key)")
        }

        return value
    }
}

