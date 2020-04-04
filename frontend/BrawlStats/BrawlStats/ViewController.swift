//
//  ViewController.swift
//  BrawlStats
//
//  Created by Tony Chen on 3/30/20.
//  Copyright © 2020 BrawlStats-Purdue. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
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
        let url = URL(string: "http://localhost:3000/players/\(usertag)")!
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
        if let text = userTagField.text, !text.isEmpty
        {
            getData(usertag: text)
        } else {
            print("Field is Empty!!")
        }
    }
    
    // demo function on how to get the data.
    // TODO: turn this in to a codeable
    func initStruct() {
        player.tag = personalStat["tag"] as! String
        player.name = personalStat["name"] as! String
        player.nameColor = personalStat["nameColor"] as! String
        player.trophies = personalStat["trophies"] as! Int
        player.highestTrophies = personalStat["highestTrophies"] as! Int
        player.expLevel = personalStat["expLevel"] as! Int
        player.expPoints = personalStat["expPoints"] as! Int
        player.isQualifiedFromChampionshipChallenge = personalStat["isQualifiedFromChampionshipChallenge"] as! Bool
        player.ThreeVSThreeVictories = personalStat["3vs3Victories"] as! Int
        player.soloVictories = personalStat["soloVictories"] as! Int
        player.duoVictories = personalStat["duoVictories"] as! Int
        player.bestRoboRumbleTime = personalStat["bestRoboRumbleTime"] as! Int
        player.bestTimeAsBigBrawler = personalStat["bestTimeAsBigBrawler"] as! Int
        player.bestTimeAsBigBrawler = personalStat["bestTimeAsBigBrawler"] as! Int
        player.club = personalStat["club"] as! [String: String]
        brawlers = personalStat["brawlers"] as! [[String: Any]]
        for brawler in brawlers {
            var insert = Brawler()
            insert.id = brawler["id"] as! Int
            insert.name = brawler["name"] as! String
            insert.power = brawler["power"] as! Int
            insert.rank = brawler["rank"] as! Int
            insert.trophies = brawler["trophies"] as! Int
            insert.highestTrophies = brawler["highestTrophies"] as! Int
            //insert.starPowers = brawler["starPowers"] as! [String: String]
            player.brawlers.append(insert)
        }
    }
    
    func printingInfo() {
        print(player)
    }
}
