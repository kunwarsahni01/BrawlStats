//
//  Battle.swift
//  BrawlStats
//
//  Created by Hugh Bromund on 4/16/20.
//  Copyright © 2020 BrawlStats-Purdue. All rights reserved.
//

import Foundation

struct Battle: Codable {
    var duration: Int = 0
    var mode: String = ""
    var result: String = ""
    var rank: Int = 0
    var trophyChange: Int = 0
    var type: String = ""
    // var starPlayer: BattlePlayer = BattlePlayer()
    // Teams
    // var teams: [BattlePlayer]
    // var battleTime: String = ""
    var event: Event = Event()
}
