//
//  TypeSelectionViewController.swift
//  TopList
//
//  Created by Derek Tseng on 2020/10/13.
//  Copyright © 2020 Derek Tseng. All rights reserved.
//

import UIKit

class TypeSelectionViewController: UIViewController {

    lazy var mainTypeTableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MainTypeCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    lazy var subTypeTableView: UITableView = {
        let tableView = UITableView()
        tableView.tableFooterView = UIView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SubTypeCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    lazy var doneBarButtonItem: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTouched(_:)))
        return item
    }()

    let viewModel: TypeSelectionViewModel

    init(viewModel: TypeSelectionViewModel) {
           self.viewModel = viewModel

           super.init(nibName: nil, bundle: nil)
       }

       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .gray
        title = "Select types to view list"

        navigationItem.rightBarButtonItem = doneBarButtonItem

        view.addSubview(mainTypeTableView)
        view.addSubview(subTypeTableView)

        setupConstraints()

        mainTypeTableView.reloadData()
        subTypeTableView.reloadData()
        let indexPath = IndexPath(row: 0, section: 0)
        mainTypeTableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
        subTypeTableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainTypeTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainTypeTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainTypeTableView.trailingAnchor.constraint(equalTo: view.centerXAnchor),
            mainTypeTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            subTypeTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            subTypeTableView.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 1),
            subTypeTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            subTypeTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)

        ])
    }

    @objc func doneButtonTouched(_ sender: UIBarButtonItem) {
        let mangaViewModel = MangaViewModel(mainTypePath: viewModel.selectedMainType.apiPath,
                                            subTypePath: viewModel.selectedSubType?.apiPath ?? "")
        let mangaViewController = MangaViewController(viewModel: mangaViewModel)
        navigationController?.pushViewController(mangaViewController, animated: true)
    }

}

extension TypeSelectionViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 30))
        view.backgroundColor = .darkGray
        let label = UILabel(frame: view.bounds)
        label.textColor = .white
        if tableView == mainTypeTableView {
            label.text = "Main Type"
        } else {
            label.text = "Sub Type"
        }
        view.addSubview(label)
        return view
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == mainTypeTableView {
            return viewModel.mainTypes.count
        } else {
            if viewModel.selectedMainType == .anime {
                return viewModel.animeSubTypes.count
            } else if viewModel.selectedMainType == .manga {
                return viewModel.mangaSubTypes.count
            } else {
                return 0
            }
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == mainTypeTableView {
            cell.isSelected = viewModel.selectedMainType == viewModel.mainTypes[indexPath.row]
        } else {
            if viewModel.selectedMainType == .anime, let selectedSubType = viewModel.selectedSubType as? TypeSelectionViewModel.AnimeSubType {
                cell.isSelected = selectedSubType == viewModel.animeSubTypes[indexPath.row]
            } else if viewModel.selectedMainType == .manga, let selectedSubType = viewModel.selectedSubType as? TypeSelectionViewModel.MangaSubType {
                cell.isSelected = selectedSubType == viewModel.mangaSubTypes[indexPath.row]
            } else {
                cell.isSelected = false
            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == mainTypeTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainTypeCell", for: indexPath)
            cell.textLabel?.text = viewModel.mainTypes[indexPath.row].title
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SubTypeCell", for: indexPath)
            if viewModel.selectedMainType == .anime {
                cell.textLabel?.text = viewModel.animeSubTypes[indexPath.row].title
            } else if viewModel.selectedMainType == .manga {
                cell.textLabel?.text = viewModel.mangaSubTypes[indexPath.row].title
            } else {
                cell.textLabel?.text = nil
            }
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == mainTypeTableView {
            viewModel.selectedMainType = viewModel.mainTypes[indexPath.row]
            if viewModel.selectedMainType == .anime {
                viewModel.selectedSubType = viewModel.animeSubTypes[0]
                subTypeTableView.reloadData()
                let indexPath = IndexPath(row: 0, section: 0)
                subTypeTableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
            } else if viewModel.selectedMainType == .manga {
                viewModel.selectedSubType = viewModel.mangaSubTypes[0]
                subTypeTableView.reloadData()
                let indexPath = IndexPath(row: 0, section: 0)
                subTypeTableView.selectRow(at: indexPath, animated: false, scrollPosition: .top)
            } else {
                viewModel.selectedSubType = nil
                subTypeTableView.reloadData()
            }
        } else {
            if viewModel.selectedMainType == .anime {
                viewModel.selectedSubType = viewModel.animeSubTypes[indexPath.row]
            } else if viewModel.selectedMainType == .manga {
                viewModel.selectedSubType = viewModel.mangaSubTypes[indexPath.row]
            } else {
                viewModel.selectedSubType = nil
            }
        }
    }

}
