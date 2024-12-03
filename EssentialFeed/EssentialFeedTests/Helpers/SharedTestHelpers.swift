//
//  SharedTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Pavel Bartashov on 3/12/2024.
//

import Foundation

func anyNSError() -> NSError {
    NSError(domain: "any error", code: 0)
}

func anyURL() -> URL {
    URL(string: "http://any-url.com")!
}
