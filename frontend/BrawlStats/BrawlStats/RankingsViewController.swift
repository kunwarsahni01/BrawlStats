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
    
    var selectedPlayer = Player()
    var personalStat = [String: Any]()
    var brawlers = [[String: Any]]()
    var iconArr = ["1", "2", "3", "4", "5"]
    
    // ranking tableview
    @IBOutlet var rankingTableView: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rankingTableView.dataSource = self
        rankingTableView.delegate = self
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
        cell.profileImage.image = UIImage(named: iconArr[abs(player.tag.hashValue % iconArr.count)])
        cell.profileImage.layer.cornerRadius = 20
        cell.profileImage.clipsToBounds = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedTag = playerArr[indexPath.row].tag.dropFirst()
        getData(usertag: String(selectedTag))
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "tableToStat" {
            if let personalStats = segue.destination as? PersonalStatViewController {
                personalStats.player = selectedPlayer
            }
        }
    }
    
    func getData(usertag: String) {
        // getting json from URL
        let url = URL(string: "http://104.198.180.127:3000/players/\(usertag)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: request) { data, _, error in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                self.personalStat = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                self.initStruct()
                self.segToStat()
            }
        }
        task.resume()
    }
    
    func segToStat() {
        print(selectedPlayer)
        performSegue(withIdentifier: "tableToStat", sender: self)
    }
    
    func initStruct() {
        selectedPlayer.tag = personalStat["tag"] as? String ?? "#000000000"
        selectedPlayer.name = personalStat["name"] as? String ?? "Name Not Found"
        selectedPlayer.nameColor = personalStat["nameColor"] as? String ?? "#FFFFFFFF"
        selectedPlayer.trophies = personalStat["trophies"] as? Int ?? 0
        selectedPlayer.highestTrophies = personalStat["highestTrophies"] as? Int ?? 0
        selectedPlayer.expLevel = personalStat["expLevel"] as? Int ?? 0
        selectedPlayer.expPoints = personalStat["expPoints"] as? Int ?? 0
        selectedPlayer.isQualifiedFromChampionshipChallenge = personalStat["isQualifiedFromChampionshipChallenge"] as? Bool ?? false
        selectedPlayer.ThreeVSThreeVictories = personalStat["3vs3Victories"] as? Int ?? 0
        selectedPlayer.soloVictories = personalStat["soloVictories"] as? Int ?? 0
        selectedPlayer.duoVictories = personalStat["duoVictories"] as? Int ?? 0
        selectedPlayer.bestRoboRumbleTime = personalStat["bestRoboRumbleTime"] as? Int ?? 0
        selectedPlayer.bestTimeAsBigBrawler = personalStat["bestTimeAsBigBrawler"] as? Int ?? 0
        selectedPlayer.bestTimeAsBigBrawler = personalStat["bestTimeAsBigBrawler"] as? Int ?? 0
        selectedPlayer.club = personalStat["club"] as? [String: String] ?? [String: String]()
        brawlers = personalStat["brawlers"] as? [[String: Any]] ?? [[String: Any]]()
        for brawler in brawlers {
            var insert = Brawler()
            insert.id = brawler["id"] as? Int ?? 0
            insert.name = brawler["name"] as? String ?? ""
            insert.power = brawler["power"] as? Int ?? 0
            insert.rank = brawler["rank"] as? Int ?? 0
            insert.trophies = brawler["trophies"] as? Int ?? 0
            insert.highestTrophies = brawler["highestTrophies"] as? Int ?? 0
            // insert.starPowers = brawler["starPowers"] as! [String: String]
            selectedPlayer.brawlers.append(insert)
        }
    }
}
