//
//  ViewController.swift
//  BrawlStats
//
//  Created by Tony Chen on 3/30/20.
//  Copyright © 2020 BrawlStats-Purdue. All rights reserved.
//

import UIKit

class EnterPlayerTagViewController: UIViewController {
    @IBOutlet var userTagField: UITextField!
    var personalStat = [String: Any]()
    var brawlers = [[String: Any]]()
    var player = Player()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
                // TODO: call a function that would generate the codeable and populate the personal stat page
                self.initStruct()
                self.printingInfo()
            }
        }
        task.resume()
        
        // Do not try to get personal stats here, request is in a separate thread, and the array will be empty
    }
    
    @IBAction func enterTapped(_ sender: Any) {
        if let text = userTagField.text?.uppercased(), !text.isEmpty
        {
            var val = text.uppercased()
            if (text.first == "#") {
                val = String(text.dropFirst())
            }
            getData(usertag: String(val.filter { !" \n\t\r".contains($0) }))
        } else {
            print("Field is Empty!!")
        }
    }
    
    // demo function on how to get the data.
    // TODO: turn this in to a codeable
    func initStruct() {
        player.tag = personalStat["tag"] as? String ?? "#000000000"
        player.name = personalStat["name"] as? String ?? "Name Not Found"
        player.nameColor = personalStat["nameColor"] as? String ?? "#FFFFFFFF"
        player.trophies = personalStat["trophies"] as? Int ?? 0
        player.highestTrophies = personalStat["highestTrophies"] as? Int ?? 0
        player.expLevel = personalStat["expLevel"] as? Int ?? 0
        player.expPoints = personalStat["expPoints"] as? Int ?? 0
        player.isQualifiedFromChampionshipChallenge = personalStat["isQualifiedFromChampionshipChallenge"] as? Bool ?? false
        player.ThreeVSThreeVictories = personalStat["3vs3Victories"] as? Int ?? 0
        player.soloVictories = personalStat["soloVictories"] as? Int ?? 0
        player.duoVictories = personalStat["duoVictories"] as? Int ?? 0
        player.bestRoboRumbleTime = personalStat["bestRoboRumbleTime"] as? Int ?? 0
        player.bestTimeAsBigBrawler = personalStat["bestTimeAsBigBrawler"] as? Int ?? 0
        player.bestTimeAsBigBrawler = personalStat["bestTimeAsBigBrawler"] as? Int ?? 0
        player.club = personalStat["club"] as! [String: String]
        brawlers = personalStat["brawlers"] as! [[String: Any]]
        for brawler in brawlers {
            var insert = Brawler()
            insert.id = brawler["id"] as? Int ?? 0
            insert.name = brawler["name"] as? String ?? ""
            insert.power = brawler["power"] as? Int ?? 0
            insert.rank = brawler["rank"] as? Int ?? 0
            insert.trophies = brawler["trophies"] as? Int ?? 0
            insert.highestTrophies = brawler["highestTrophies"] as? Int ?? 0
            //insert.starPowers = brawler["starPowers"] as! [String: String]
            player.brawlers.append(insert)
        }
    }
    
    func printingInfo() {
        print(player)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
}
