//
//  Manga.swift
//  TopList
//
//  Created by Derek Tseng on 2020/10/15.
//  Copyright © 2020 Derek Tseng. All rights reserved.
//

import Foundation

class Manga: Codable, Equatable {
    var title: String
    var imageURL: String
    var startDate: String?
    var endDate: String?
    var rank: Int
    var type: String
    var url: String
    var isFavorite = false

    private enum CodingKeys: String, CodingKey {
        case title
        case imageURL = "image_url"
        case startDate = "start_date"
        case endDate = "end_date"
        case rank
        case type
        case url
    }

    static func == (lhs: Manga, rhs: Manga) -> Bool {
        return lhs.url == rhs.url
    }
}
