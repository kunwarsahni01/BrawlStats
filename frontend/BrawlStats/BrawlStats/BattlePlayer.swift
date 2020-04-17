//
//  BattlePlayer.swift
//  BrawlStats
//
//  Created by Hugh Bromund on 4/16/20.
//  Copyright © 2020 BrawlStats-Purdue. All rights reserved.
//

import Foundation

struct BattlePlayer: Codable {
    var brawler:Brawler = Brawler()
    var name:String = ""
    var tag:String = ""
}
