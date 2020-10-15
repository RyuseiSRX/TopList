//
//  TopMangas.swift
//  Manga
//
//  Created by Derek Tseng on 2020/9/30.
//  Copyright © 2020 Derek Tseng. All rights reserved.
//

import Foundation

class TopMangas: Codable {
    var top: [Manga]

    private enum CodingKeys: String, CodingKey {
        case top
    }
}
