//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Pavel Bartashov on 30/1/2025.
//

import XCTest
import EssentialFeed

struct FeedImageViewModel {
    let description: String?
    let location: String?
    let image: Any?
    let isLoading: Bool
    let shouldRetry: Bool

    var hasLocation: Bool {
        location != nil
    }
}

protocol FeedImageView {
    associatedtype Image

    func display(_ viewModel: FeedImageViewModel)
}

final class FeedImagePresenter<View: FeedImageView> {
    private let view: View

    init(view: View) {
        self.view = view
    }

    func didStartLoadingImageData(for model: FeedImage) {
        view.display(FeedImageViewModel(
            description: model.description,
            location: model.location,
            image: nil,
            isLoading: true,
            shouldRetry: false
        ))
    }
}


final class FeedImagePresenterTests: XCTestCase {

    func test_init_doesNotSendMessagesToViews() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }

    func test_didStartLoadingImageData_displaysLoadingImage() {
        let (sut, view) = makeSUT()
        let image = uniqueImage()

        sut.didStartLoadingImageData(for: image)

        let message = view.messages.first
        XCTAssertEqual(view.messages.count, 1)
        XCTAssertEqual(message?.description, image.description)
        XCTAssertEqual(message?.location, image.location)
        XCTAssertEqual(message?.isLoading, true)
        XCTAssertEqual(message?.shouldRetry, false)
        XCTAssertNil(message?.image)
    }

    // MARK: - Helpers

    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: FeedImagePresenter<ViewSpy>, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedImagePresenter(view: view)

        trackForMemoryLeaks(view, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, view)
    }

    private final class ViewSpy: FeedImageView {
        typealias Image = UIImage

        private(set) var messages = [ FeedImageViewModel]()

        func display(_ viewModel: FeedImageViewModel) {
            messages.append(viewModel)
        }
    }
}
