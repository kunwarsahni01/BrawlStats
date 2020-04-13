//
//  RankingsViewController.swift
//  BrawlStats
//
//  Created by Tony Chen on 4/13/20.
//  Copyright © 2020 BrawlStats-Purdue. All rights reserved.
//

import UIKit

class RankingsViewController: UIViewController {
    
    // raw data a list of top 200 players
    var playerList = [[String: Any]]()
    
    // array of RankPlayer
    var playerArr = [RankPlayer]()

    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    func getData() {
        // getting json from URL
        let url = URL(string: "http://104.198.180.127:3000/rankings/global/players")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { data, _, error in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                // raw data
                var rawData = [String: Any]()
                rawData = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.playerList = rawData["items"] as! [[String: Any]]
                self.initArr()
            }
        }
        task.resume()
    }
    
    func initArr() {
        for i in 0...playerList.count - 1 {
            var tempRankPlayer = RankPlayer()
            tempRankPlayer.tag = playerList[i]["tag"] as? String ?? "#00000000"
            tempRankPlayer.rank = playerList[i]["rank"] as? Int ?? 0
            tempRankPlayer.trophies = playerList[i]["trophies"] as? Int ?? 0
            tempRankPlayer.name = playerList[i]["name"] as? String ?? ""
            if let tempClub = playerList[i]["club"] {
                tempRankPlayer.clubName = (tempClub as! [String: Any])["name"] as! String
            } else {
                tempRankPlayer.clubName = ""
            }
            tempRankPlayer.nameColor = playerList[i]["nameColor"] as? String ?? "0xFFFFFFFF"
             
        }
        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
