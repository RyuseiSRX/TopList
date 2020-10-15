//
//  MangaViewModel.swift
//  TopList
//
//  Created by Derek Tseng on 2020/10/15.
//  Copyright © 2020 Derek Tseng. All rights reserved.
//

import Foundation
import Alamofire

protocol MangaViewModelDelegate: class {
    func viewModelLoadItemFailed(_ viewModel: MangaViewModel)
    func shouldReloadTableView(_ viewModel: MangaViewModel)
}

enum Mode {
    case top
    case favorite
}

class MangaViewModel {

    private(set) var allMangas = [Manga]()
    private(set) var favoriteMangas = [Manga]()
    private(set) var hasMoreToFetch = true
    private var currentPage = 1
    private var isFetching = false
    private let mainTypePath: String
    private let subTypePath: String
    var mode = Mode.top
    weak var delegate: MangaViewModelDelegate?

    init(mainTypePath: String, subTypePath: String) {
        self.mainTypePath = mainTypePath
        self.subTypePath = subTypePath
    }

    func fetchTopMangas() {
        guard !isFetching else { return }

        currentPage = 1
        fetchNextTopMangas()
    }

    func fetchNextTopMangas() {
        guard !isFetching else { return }

        let urlString = "https://api.jikan.moe/v3/top/\(mainTypePath)/\(currentPage)/\(subTypePath)"
        guard let url = URL(string: urlString) else { return }

        AF.request(url).responseJSON { [unowned self] response in
            guard let data = response.data else {
                self.delegate?.viewModelLoadItemFailed(self)
                self.isFetching = false
                return
            }

            let decoder = JSONDecoder()
            guard let mangaList = try? decoder.decode(TopMangas.self, from: data) else {
                self.delegate?.viewModelLoadItemFailed(self)
                self.isFetching = false
                return
            }

            self.handleIncomingMangaList(mangaList)
        }
    }

    func handleIncomingMangaList(_ mangaList: TopMangas) {
        DispatchQueue.main.async {
            if self.currentPage == 1 {
                self.allMangas = mangaList.top
                self.favoriteMangas.removeAll()
            } else {
                self.allMangas.append(contentsOf: mangaList.top)
            }

            if mangaList.top.count < 50 {
                self.hasMoreToFetch = false
            } else {
                self.currentPage += 1
            }

            self.delegate?.shouldReloadTableView(self)
            self.isFetching = false
        }
    }

}
