//
//  TypeSelectionViewModel.swift
//  TopList
//
//  Created by Derek Tseng on 2020/10/13.
//  Copyright © 2020 Derek Tseng. All rights reserved.
//

import Foundation

class TypeSelectionViewModel {

    enum MainType: String {
        case anime
        case manga
        case people
        case characters

        var title: String {
            switch self {
            case .anime:
                return "Anime"
            case .manga:
                return "Manga"
            case .people:
                return "People"
            case .characters:
                return "Characters"
            }
        }

        var apiPath: String {
            return rawValue
        }
    }

    enum AnimeSubType: String {
        case all
        case airing
        case upcoming
        case tv
        case movie
        case ova
        case special
        case bypopularity
        case favorite

        var title: String {
            switch self {
            case .all:
                return "All"
            case .airing:
                return "Airing"
            case .upcoming:
                return "Upcoming"
            case .tv:
                return "TV"
            case .movie:
                return "Movie"
            case .ova:
                return "OVA"
            case .special:
                return "Special"
            case .bypopularity:
                return "By Popularity"
            case .favorite:
                return "Favorite"
            }
        }

        var apiPath: String {
            switch self {
            case .all:
                return ""
            default :
                return rawValue
            }
        }
    }

    enum MangaSubType: String {
        case all
        case manga
        case novels
        case oneshots
        case doujin
        case manhwa
        case manhua
        case bypopularity
        case favorite

        var title: String {
            switch self {
            case .all:
                return "All"
            case .manga:
                return "Manga"
            case .novels:
                return "Novels"
            case .oneshots:
                return "Oneshots"
            case .doujin:
                return "Doujin"
            case .manhwa:
                return "Manhwa"
            case .manhua:
                return "Manhua"
            case .bypopularity:
                return "By Popularity"
            case .favorite:
                return "Favorite"
            }
        }

        var apiPath: String {
            switch self {
            case .all:
                return ""
            default :
                return rawValue
            }
        }
    }

    private let mainTypes: [MainType] = [.anime, .manga, .people, .characters]
    private let animeSubTypes: [AnimeSubType] = [.all, .airing, .upcoming, .tv, .movie, .ova, .special, .bypopularity, .favorite]
    private let mangaSubTypes: [MangaSubType] = [.all, .manga, .novels, .oneshots, .doujin, .manhwa, .manhua, .bypopularity, .favorite]
}
