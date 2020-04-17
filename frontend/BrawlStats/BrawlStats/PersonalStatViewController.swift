//
//  PersonalStatViewController.swift
//  BrawlStats
//
//  Created by Tony Chen on 4/6/20.
//  Copyright © 2020 BrawlStats-Purdue. All rights reserved.
//

import UIKit
import Foundation

class PersonalStatViewController: UIViewController {
    
    var battlelog = [Battle]()
    var battlelogResults = [String: Any]()

    
    var player = Player()
    @IBOutlet weak var NameTextField: UILabel!
    @IBOutlet weak var ClubTextField: UILabel!
    @IBOutlet weak var TrophyTextField: UILabel!
    @IBOutlet weak var XpTextField: UILabel!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var SolosTextField: UILabel!
    @IBOutlet weak var DuosTextField: UILabel!
    @IBOutlet weak var ThreeVThreeTextField: UILabel!
    @IBOutlet weak var RoboTimeTextField: UILabel!
    @IBOutlet weak var CharacterImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func initBattlelog() {
        let battleArray = battlelogResults["items"]
        
        for battle in battleArray as! [[String: Any]] {
            let battleDetails:NSDictionary = battle["battle"] as! NSDictionary
            let eventDetails:NSDictionary = battle["event"] as! NSDictionary
            // print(battleDetails)
            
            var tempBattle = Battle()
            tempBattle.duration = battleDetails["duration"] as? Int ?? 0
            tempBattle.mode = battleDetails["mode"] as! String
            tempBattle.result = battleDetails["result"] as? String ?? "rank"
            tempBattle.rank = battleDetails["rank"] as? Int ?? -1
            tempBattle.trophyChange = battleDetails["trophyChange"] as? Int ?? 0
            tempBattle.type = battleDetails["type"] as? String ?? "unranked"
            
            var tempEvent = Event()
            tempEvent.id = eventDetails["id"] as! Int
            tempEvent.map = eventDetails["map"] as! String
            tempEvent.mode = eventDetails["mode"] as! String
            
            tempBattle.event = tempEvent
            
            battlelog.append(tempBattle)
        }
        print("battlelog: \(battlelog)")
    }
    
    

    func getBattleLog() {
        var usertag = player.tag
        // Since usertags start with a #, we remove the first character
        usertag.remove(at: usertag.startIndex)
        print(usertag)
        let url = URL(string: "http://104.198.180.127:3000/players/\(usertag)/battlelog")!
         let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { data, _, error in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                // self.addRecentSearch(usertag: usertag)
                print("typeof data: \(type(of: data))")
                self.battlelogResults = try! JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]

                self.initBattlelog()
            }
        }
        task.resume()
    }
    

    // This function looks at the current player and returns the Brawler object of the highest trophy brawler the player has
    func highestTropheyBrawler() -> (Brawler) {
        
        let brawlers = player.brawlers
        // print(brawlers)
        
        var highestBrawler = brawlers[0];
        
        for brawler in brawlers {
            // print(brawler)
            if (brawler.trophies > highestBrawler.trophies) {
                highestBrawler = brawler;
            }
        }
        
        print(highestBrawler);
        
        return highestBrawler
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        getBattleLog()
        roundedView.layer.cornerRadius = 38
        NameTextField.text = player.name
        ClubTextField.text = player.club["name"] ?? "No Club"

        TrophyTextField.text = String(player.trophies)
        XpTextField.text = String(player.expPoints)
        // highestTropheyBrawler()
        // print(player)
        TrophyTextField.text = "Trophies: \(String(player.trophies))"
        XpTextField.text = "XP: \n\(String(player.expPoints))"
        SolosTextField.text = "Solo Victories: \(String(player.soloVictories))"
        DuosTextField.text = "Duo Victories: \(String(player.duoVictories))"
        ThreeVThreeTextField.text = "3v3 Victories: \(String(player.ThreeVSThreeVictories))"
        RoboTimeTextField.text = "Robo Time: \(String(player.bestRoboRumbleTime))"
        CharacterImageView.image = UIImage(named: "colt")
        // Change Character Image View through line above.
        /*
            Current Character Models:
            colt
            crow
            spike
            poco
         */
    }
    

    @IBAction func backButtonTapped(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
