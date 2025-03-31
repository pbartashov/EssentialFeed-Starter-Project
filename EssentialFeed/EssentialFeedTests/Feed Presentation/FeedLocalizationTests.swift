//
//  FeedLocalizationTests.swift
//  EssentialFeediOSTests
//
//  Created by Pavel Bartashov on 21/1/2025.
//

import XCTest
@testable import EssentialFeed

final class FeedLocalizationTests: XCTestCase {
    func test_localizedStrings_haveKeysAndValuesForAllSupportedLocalizations() {
        let table = "Feed"
        let bundle = Bundle(for: FeedPresenter.self)

        assertLocalizedKeyAndValuesExist(in: bundle, table)
    }
}
