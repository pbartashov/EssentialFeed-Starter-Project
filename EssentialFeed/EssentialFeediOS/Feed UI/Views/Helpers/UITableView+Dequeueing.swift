//
//  UITableView+Dequeueing.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 17/1/2025.
//

import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
