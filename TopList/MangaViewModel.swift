//
//  MangaViewModel.swift
//  TopList
//
//  Created by Derek Tseng on 2020/10/15.
//  Copyright © 2020 Derek Tseng. All rights reserved.
//

import Foundation

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
    private var currentPage = 1
    var mode = Mode.top
    weak var delegate: MangaViewModelDelegate?

}
