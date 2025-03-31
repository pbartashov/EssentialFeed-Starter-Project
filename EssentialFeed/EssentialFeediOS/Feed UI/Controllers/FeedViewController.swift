//
//  FeedViewController.swift
//  EssentialFeediOS
//
//  Created by Pavel Bartashov on 30/12/2024.
//

import UIKit
import EssentialFeed

public protocol FeedViewControllerDelegate {
    func didRequestFeedRefresh()
}

public final class FeedViewController: UITableViewController, UITableViewDataSourcePrefetching {
    @IBOutlet private(set) public var errorView: ErrorView?
    private var loadingControllers = [IndexPath: FeedImageCellController]()
    private var onViewIsAppearing: ((FeedViewController) -> Void)?

    public var delegate: FeedViewControllerDelegate?

    private var tableModel = [FeedImageCellController]() {
        didSet { self.tableView.reloadData() }
    }

    private var cellControllers = [IndexPath: FeedImageCellController]()

    @available(iOS 13, *)
    public convenience init?(coder: NSCoder, delegate: FeedViewControllerDelegate) {
        self.init(coder: coder)
        self.delegate = delegate
    }

    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        tableView.sizeTableHeaderToFit()
    }

    @IBAction private func refresh() {
        delegate?.didRequestFeedRefresh()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        onViewIsAppearing = { vc in
            vc.refresh()
            vc.onViewIsAppearing = nil
        }
    }

    public func display(_ cellControllers: [FeedImageCellController]) {
        loadingControllers = [:]
        tableModel = cellControllers
    }

    public override func viewIsAppearing(_ animated: Bool) {
        super.viewIsAppearing(animated)

        onViewIsAppearing?(self)
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellController(forRowAt: indexPath).view(in: tableView)
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableModel.count
    }

    public override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cancelCellControlerLoad(forRowAt: indexPath)
    }

    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellControllers[indexPath]?.loadImage(for: cell)
    }

    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }

    public func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControlerLoad)
    }

    private func cellController(forRowAt indexPath: IndexPath) -> FeedImageCellController {
        let controller = tableModel[indexPath.row]
        loadingControllers[indexPath] = controller

        return controller
    }

    private func cancelCellControlerLoad(forRowAt indexPath: IndexPath) {
        loadingControllers[indexPath]?.cancelLoad()
        loadingControllers[indexPath] = nil
    }
}

extension FeedViewController: ResourceLoadingView {
    public func display(_ viewModel: ResourceLoadingViewModel) {
        if viewModel.isLoading {
            refreshControl?.beginRefreshing()
        } else {
            refreshControl?.endRefreshing()
        }
    }
}

extension FeedViewController: FeedErrorView {
    public func display(_ viewModel: FeedErrorViewModel) {
        if let message = viewModel.message {
            errorView?.show(message: message)
        } else {
            errorView?.hideMessage()
        }
    }
}
