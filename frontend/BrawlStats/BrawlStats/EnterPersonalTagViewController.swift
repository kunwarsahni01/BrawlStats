//
//  EnterPersonalTagViewController.swift
//  BrawlStats
//
//  Created by Kunwar Sahni on 4/17/20.
//  Copyright © 2020 BrawlStats-Purdue. All rights reserved.
//

import UIKit

class EnterPersonalTagViewController: UIViewController {
    @IBOutlet var userTagField: UITextField!
    @IBOutlet weak var userTagView: UIView!
    var personalStat = [String: Any]()
    var brawlers = [[String: Any]]()
    var player = Player()
    let recentSearchKey = "recentSearchKey"
    let numRecentSearches = 5
    
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
        userTagView.layer.cornerRadius = 10
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
        // print(player.club)
        if (player.tag == "#000000000") {
            
            let alert = UIAlertController(title: "Error", message: "Invalid Tag!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        } else {
            performSegue(withIdentifier: "EnterToHome", sender: self)
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "EnterToHome" {
            if let homeStatPage = segue.destination as? HomeStatsViewController {
                homeStatPage.player = player
            }
        }
        
    }

}
