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
    
    

    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        NameTextField.text = player.name
        ClubTextField.text = player.club["name"] ?? "No Club"
        TrophyTextField.text = String(player.trophies)
        XpTextField.text = String(player.expPoints)
    }
    

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
