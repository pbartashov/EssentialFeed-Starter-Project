//
//  FeedImageViewModel.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 6/1/2025.
//

import Foundation
import EssentialFeed

final class FeedImageViewModel<Image> {
    typealias Observer<T> = (T) -> Void

    private var task: FeedImageDataLoaderTask?
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader
    private let imageTransformer: (Data) -> Image?

    var onImageLoad: Observer<Image>?
    var onImageLoadingStateChange: Observer<Bool>?
    var onShouldRetryImageLoadingStateChange: Observer<Bool>?

    var hasLocation: Bool {
        model.location == nil
    }

    var location: String? {
        model.location
    }

    var description: String? {
        model.description
    }

    init(model: FeedImage, imageLoader: FeedImageDataLoader, imageTransformer: @escaping (Data) -> Image?) {
        self.model = model
        self.imageLoader = imageLoader
        self.imageTransformer = imageTransformer
    }

    func cancelImageDataLoad() {
        task?.cancel()
    }

    func loadImageData() {
        onImageLoadingStateChange?(true)
        onShouldRetryImageLoadingStateChange?(false)
        task = imageLoader.loadImageData(from: model.url) { [weak self] result in
            self?.handle(result)
        }
    }

    func preloadImageData() {
        task = imageLoader.loadImageData(from: model.url, completion: { _ in })
    }

    private func handle(_ result: FeedImageDataLoader.Result) {
        if let image = (try? result.get()).flatMap(imageTransformer) {
            onImageLoad?(image)
        } else {
            onShouldRetryImageLoadingStateChange?(true)
        }

        onImageLoadingStateChange?(false)
    }
}
