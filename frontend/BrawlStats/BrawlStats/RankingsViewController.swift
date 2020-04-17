//
//  RankingsViewController.swift
//  BrawlStats
//
//  Created by Tony Chen on 4/13/20.
//  Copyright © 2020 BrawlStats-Purdue. All rights reserved.
//

import UIKit

class RankingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // raw data a list of top 200 players, DO NOT USE
    var playerList = [[String: Any]]()
    
    // array of RankPlayer, Use this!
    var playerArr = [RankPlayer]()
    
    var player = Player()
    
    // ranking tableview
    @IBOutlet weak var rankingTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.rankingTableView.dataSource = self
        self.rankingTableView.delegate = self
        rankingTableView.separatorStyle = .none
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
                self.rankingTableView.reloadData()
                print(self.playerArr.count)
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
            playerArr.append(tempRankPlayer)
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RankingsPlayerTableViewCell") as! RankingsPlayerTableViewCell
        let player = playerArr[indexPath.row]
        cell.nameLabel.text = player.name
        cell.tagLabel.text = player.tag
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //player = playerArr[indexPath.row]
        //performSegue(withIdentifier: "tableToStats", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "tableToStats" {
            if let personalStats = segue.destination as? PersonalStatViewController {
                personalStats.player = player
            }
        }
        
    }
}
