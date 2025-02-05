//
//  HTTPURLResponse+StatusCode.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 5/2/2025.
//

import Foundation

extension HTTPURLResponse {
    private static var OK_200: Int { return 200 }

    var isOK: Bool {
        return statusCode == HTTPURLResponse.OK_200
    }
}

