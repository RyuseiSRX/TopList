//
//  MangaViewController.swift
//  TopList
//
//  Created by Derek Tseng on 2020/10/15.
//  Copyright © 2020 Derek Tseng. All rights reserved.
//

import UIKit

class MangaViewController: UIViewController {

    lazy var filterSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["All", "Favorite"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(filterSegmentedControlValueChanged(_:)), for: .valueChanged)
        return segmentedControl
    }()

    lazy var topTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    lazy var favoriteTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        return tableView
    }()

    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshControlValueChanged(_:)), for: .valueChanged)
        return refreshControl
    }()

    let viewModel: MangaViewModel

    init(viewModel: MangaViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white

        navigationItem.titleView = filterSegmentedControl
        topTableView.refreshControl = refreshControl

        view.addSubview(topTableView)
        view.addSubview(favoriteTableView)

        NSLayoutConstraint.activate([
            topTableView.topAnchor.constraint(equalTo: view.topAnchor),
            topTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            favoriteTableView.topAnchor.constraint(equalTo: view.topAnchor),
            favoriteTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            favoriteTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            favoriteTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // TODO: Fetch initial data
    }

    @objc func filterSegmentedControlValueChanged(_ control: UISegmentedControl) {
        if control.selectedSegmentIndex == 0 {
            viewModel.mode = .top
        } else {
            viewModel.mode = .favorite
        }
        topTableView.isHidden = viewModel.mode == .favorite
        favoriteTableView.isHidden = viewModel.mode == .top

        // TODO: Reload data
    }

    @objc func refreshControlValueChanged(_ control: UIRefreshControl) {
        control.beginRefreshing()
        // TODO: Refresh data
    }

}

extension MangaViewController: MangaViewModelDelegate {

    func viewModelLoadItemFailed(_ viewModel: MangaViewModel) {
        // TODO: display error message
    }

    func shouldReloadTableView(_ viewModel: MangaViewModel) {
        // TODO: reload data
    }

}

extension MangaViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: Handle favorite actions
    }

}
