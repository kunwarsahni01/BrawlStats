//
//  Brawler.swift
//  BrawlStats
//
//  Created by Kunwar Sahni on 4/4/20.
//  Copyright © 2020 BrawlStats-Purdue. All rights reserved.
//

import Foundation

struct Brawler: Codable {
    var id: Int = 0
    var name: String = ""
    var power: Int = 0
    var rank: Int = 0
    var trophies: Int = 0
    var highestTrophies: Int = 0
    var starPowers: [String] = []
}
