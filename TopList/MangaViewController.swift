//
//  MangaViewController.swift
//  TopList
//
//  Created by Derek Tseng on 2020/10/15.
//  Copyright © 2020 Derek Tseng. All rights reserved.
//

import UIKit
import SafariServices

class MangaViewController: UIViewController {

    lazy var filterSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["All", "Favorite"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(filterSegmentedControlValueChanged(_:)), for: .valueChanged)
        return segmentedControl
    }()

    lazy var topTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MangaTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    lazy var favoriteTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(MangaTableViewCell.self, forCellReuseIdentifier: "Cell")
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

        viewModel.fetchTopMangas()
    }

    func reloadData() {
        if viewModel.mode == .top {
            topTableView.reloadData()
        } else {
            favoriteTableView.reloadData()
        }
    }

    @objc func filterSegmentedControlValueChanged(_ control: UISegmentedControl) {
        if control.selectedSegmentIndex == 0 {
            viewModel.mode = .top
        } else {
            viewModel.mode = .favorite
        }
        topTableView.isHidden = viewModel.mode == .favorite
        favoriteTableView.isHidden = viewModel.mode == .top

        reloadData()
    }

    @objc func refreshControlValueChanged(_ control: UIRefreshControl) {
        control.beginRefreshing()
        viewModel.fetchTopMangas()
    }

}

extension MangaViewController: MangaViewModelDelegate {

    func viewModelLoadItemFailed(_ viewModel: MangaViewModel) {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }

        let ok = UIAlertAction.init(title: "OK", style: .default, handler: nil)
        let alert = UIAlertController(title: "Error", message: "Failed to load manga list due to network issue. Pull down to refresh", preferredStyle: .alert)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }

    func shouldReloadTableView(_ viewModel: MangaViewModel) {
        if refreshControl.isRefreshing {
            refreshControl.endRefreshing()
        }

        reloadData()
    }

}

extension MangaViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.mode == .top {
            return viewModel.allMangas.count
        } else {
            return viewModel.favoriteMangas.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MangaTableViewCell

        cell.delegate = self

        if viewModel.mode == .top {
            cell.setup(manga: viewModel.allMangas[indexPath.row])
            if indexPath.row == viewModel.allMangas.count-1 && viewModel.hasMoreToFetch {
                viewModel.fetchNextTopMangas()
            }
        } else {
            cell.setup(manga: viewModel.favoriteMangas[indexPath.row])
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let urlString: String
        if viewModel.mode == .top {
            urlString = viewModel.allMangas[indexPath.row].url
        } else {
            urlString = viewModel.favoriteMangas[indexPath.row].url
        }

        guard let url = URL(string: urlString) else { return }

        let viewController = SFSafariViewController(url: url)
        present(viewController, animated: true, completion: nil)
    }

}

extension MangaViewController: MangaTableViewCellDelegate {

    func mangaTableViewCellDidAddFavorite(_ cell: MangaTableViewCell) {
    }

    func mangaTableViewCellDidRemoveFavorite(_ cell: MangaTableViewCell) {
    }

}
