//
//  ViewController.swift
//  BrawlStats
//
//  Created by Tony Chen on 3/30/20.
//  Copyright © 2020 BrawlStats-Purdue. All rights reserved.
//

import UIKit
import Foundation

class EnterPlayerTagViewController: UIViewController {
    @IBOutlet var userTagField: UITextField!
    var personalStat = [String: Any]()
    var brawlers = [[String: Any]]()
    var player = Player()
    let recentSearchKey = "recentSearchKey"
    let numRecentSearches = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let userDefaults = UserDefaults.standard
        
        // If searches hasn't been setup yet, it will be initialized as an empty array
        let searches: [String] = userDefaults.object(forKey: recentSearchKey) as? [String] ?? []
        
        print(searches)
        
        for (index, search) in searches.enumerated() {
            // for each search, we want to create a new button on the view.
            let button = UIButton(frame: CGRect(x: 100, y: 100 + 100*index, width: 100, height: 50))
            button.backgroundColor = .green
            button.setTitle(search, for: .normal)
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            self.view.addSubview(button)
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        print("Button tapped")
        print(sender.titleLabel!.text!)
        
        self.getData(usertag: sender.titleLabel!.text!)
    }
    
    
    func addRecentSearch(usertag: String) {
        let userDefaults = UserDefaults.standard
        
        // If searches hasn't been setup yet, it will be initialized as an empty array
        var searches: [String] = userDefaults.object(forKey: recentSearchKey) as? [String] ?? []
        
        // to make sure we don't have duplicates, only insert if they dont already exist
        if (!searches.contains(usertag)) {
            // insert the new usertag at the front
            searches.insert(usertag, at: 0);
        }
        
        // if the length is now longer than numRecentSearches, we will remove the final element
        if (searches.count > numRecentSearches) {
            searches.removeLast()
        }
        
        // Now we put the data back in UserDefaults.
        
        userDefaults.set(searches, forKey: recentSearchKey)
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
                self.addRecentSearch(usertag: usertag)
                self.personalStat = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                // TODO: call a function that would generate the codeable and populate the personal stat page
                self.initStruct()
//                self.printingInfo()
                self.segToPersonalStat()
            }
        }
        task.resume()
    }
    
    @IBAction func enterTapped(_ sender: Any) {
        
        if let text = userTagField.text?.uppercased(), !text.isEmpty
        {
            let characterSet = Set(String("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890"))
            
            getData(usertag: String(text.filter { characterSet.contains($0) }))
        } else {
            let alert = UIAlertController(title: "Error", message: "Field is empty!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
    }
    
    func segToPersonalStat() {
        print(player.tag)
        if (player.tag == "#000000000") {

            let alert = UIAlertController(title: "Error", message: "Invalid Tag!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        } else {
            performSegue(withIdentifier: "EnterTagToPersonalStat", sender: self)
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
        player.club = personalStat["club"] as? [String: String] ?? [String:String]()
        brawlers = personalStat["brawlers"] as? [[String: Any]] ?? [[String: Any]]()
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
}
