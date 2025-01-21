//
//  File 2.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 21/1/2025.
//

import UIKit
import EssentialFeed
import EssentialFeediOS

extension FeedUIIntegrationTests {
    func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> (sut: FeedViewController, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedUIComposer.feedComposedWith(feedLoader: loader, imageLoader: loader)

        trackForMemoryLeaks(loader, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)

        return (sut, loader)
    }

    func makeImage(
        description: String? = nil,
        location: String? = nil,
        url: URL = URL(string: "http://any-url.com")!
    ) -> FeedImage {
        FeedImage(id: UUID(), description: description, location: location, url: url)
    }

    func anyImageData() -> Data {
        return UIImage.make(withColor: .red).pngData()!
    }
}
