//
//  CoreDataFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Pavel Bartashov on 11/12/2024.
//

import XCTest
import EssentialFeed

final class CoreDataFeedStoreTests: XCTestCase, FeedStoreSpecs {
    func test_retrieve_deliversEmptyOnEmptyCache() throws {
        let sut = try makeSUT()

        assertThatRetrieveDeliversEmptyOnEmptyCache(on: sut)
    }
    
    func test_retrieve_hasNoEffectsOnEmptyCache() throws {
        let sut = try makeSUT()

        assertThatRetrieveHasNoSideEffectsOnEmptyCache(on: sut)
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() throws {
        let sut = try makeSUT()

        assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on: sut)
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() throws {
        let sut = try makeSUT()

        assertThatRetrieveHasNoSideEffectsOnNonEmptyCache(on: sut)
    }
    func test_insert_deliversNoErrorsOnEmptyCache() throws {
        let sut = try makeSUT()

        assertThatInsertDeliversNoErrorOnEmptyCache(on: sut)
    }
    
    func test_insert_deliversNoErrorsOnNonEmptyCache() throws {
        let sut = try makeSUT()

        assertThatInsertDeliversNoErrorOnNonEmptyCache(on: sut)
    }
    
    func test_insert_overridesPreviouslyInsertedCacheValues() throws {
        let sut = try makeSUT()

        assertThatInsertOverridesPreviouslyInsertedCacheValues(on: sut)
    }
    
    func test_delete_deliversNoErrorOnEmptyCache() throws {
        let sut = try makeSUT()

        assertThatDeleteDeliversNoErrorOnEmptyCache(on: sut)
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() throws {
        let sut = try makeSUT()

        assertThatDeleteHasNoSideEffectsOnEmptyCache(on: sut)
    }
    
    func test_delete_deliversNoErrorOnNonEmptyCache() throws {
        let sut = try makeSUT()

        assertThatDeleteDeliversNoErrorOnNonEmptyCache(on: sut)
    }
    
    func test_delete_emptiesPreviouslyInsertedCache() throws {
        let sut = try makeSUT()

        assertThatDeleteEmptiesPreviouslyInsertedCache(on: sut)
    }
    
    func test_storeSideEffects_runSerially() throws {
        let sut = try makeSUT()

        assertThatSideEffectsRunSerially(on: sut)
    }

    // MARK: - Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) throws -> FeedStore {
        let storeURL = URL(fileURLWithPath: "/dev/null")
        let storeBundle = Bundle(for: CoreDataFeedStore.self)
        let sut = try CoreDataFeedStore(storeURL:storeURL, bundle: storeBundle)
        trackForMemoryLeaks(sut, file: file, line: line)

        return sut
    }
}
