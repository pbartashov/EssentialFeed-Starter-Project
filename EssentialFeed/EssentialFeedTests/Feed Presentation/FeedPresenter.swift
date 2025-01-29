//
//  FeedPresenter.swift
//  EssentialFeedTests
//
//  Created by Pavel Bartashov on 29/1/2025.
//

import XCTest

final class FeedPresenter {
    private let view: Any
    init(view: Any) {
        self.view = view
    }
}


final class EssentialFeedTests: XCTestCase {

    func test_init_doesNotSendMessagesToViews() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }

    // MARK: - Helpers

    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: FeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedPresenter(view: view)

        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, view)
    }

    private final class ViewSpy {
        var messages: [Any] = []
    }
}
