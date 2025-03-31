//
//  DummyView.swift
//  EssentialApp
//
//  Created by Pavel Bartashov on 31/3/2025.
//


import EssentialFeed
import EssentialFeedAPI

extension FeedUIIntegrationTests {
    private class DummyView: ResourceView {
        func display(_ viewModel: Any) {}
    }

    var loadError: String {
        LoadResourcePresenter<Any, DummyView>.loadError
    }

    var feedTitle: String {
        FeedPresenter.title
    }
}
