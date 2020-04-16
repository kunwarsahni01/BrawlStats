//
//  PersonalStatViewController.swift
//  BrawlStats
//
//  Created by Tony Chen on 4/6/20.
//  Copyright © 2020 BrawlStats-Purdue. All rights reserved.
//

import UIKit

class PersonalStatViewController: UIViewController {
    
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
    

    func getBattleLog() {
        
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
