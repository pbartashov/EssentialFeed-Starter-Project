//
//  ResourceErrorViewModel.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 30/1/2025.
//

public struct ResourceErrorViewModel {
    public let message: String?

    static var noError: ResourceErrorViewModel {
        return ResourceErrorViewModel(message: nil)
    }

    static func error(message: String) -> ResourceErrorViewModel {
        return ResourceErrorViewModel(message: message)
    }
}
