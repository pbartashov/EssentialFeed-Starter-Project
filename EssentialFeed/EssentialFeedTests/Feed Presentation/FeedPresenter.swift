//
//  FeedPresenter.swift
//  EssentialFeedTests
//
//  Created by Pavel Bartashov on 29/1/2025.
//

import XCTest

protocol FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}

struct FeedErrorViewModel {
    let message: String?

    static var noError: Self {
        return FeedErrorViewModel(message: nil)
    }
}

final class FeedPresenter {
    private let feedErrorView: FeedErrorView
    init(feedErrorView: FeedErrorView) {
        self.feedErrorView = feedErrorView
    }

    func didStartLoadingFeed() {
        feedErrorView.display(.noError)
    }
}


final class EssentialFeedTests: XCTestCase {

    func test_init_doesNotSendMessagesToViews() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }

    func test_didStartLoadingFeed_displaysNoErrorMessage() {
        let (sut, view) = makeSUT()
        
        sut.didStartLoadingFeed()

        XCTAssertEqual(view.messages, [.display(errorMessage: .none)])
    }

    // MARK: - Helpers

    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: FeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedPresenter(feedErrorView: view)

        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, view)
    }

    private final class ViewSpy: FeedErrorView {
        enum Message: Equatable {
            case display(errorMessage: String?)
        }

        private(set) var messages: [Message] = []

        func display(_ viewModel: FeedErrorViewModel) {
            messages.append(.display(errorMessage: viewModel.message))
        }
    }
}
