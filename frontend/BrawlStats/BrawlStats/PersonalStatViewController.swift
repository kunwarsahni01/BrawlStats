//
//  PersonalStatViewController.swift
//  BrawlStats
//
//  Created by Tony Chen on 4/6/20.
//  Copyright © 2020 BrawlStats-Purdue. All rights reserved.
//

import Foundation
import UIKit
import Charts

extension UIColor {
    convenience init?(hexString: String) {
        var chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
        switch chars.count {
        case 3: chars = chars.flatMap { [$0, $0] }; fallthrough
        case 6: chars = ["F","F"] + chars
        case 8: break
        default: return nil
        }
        self.init(red: .init(strtoul(String(chars[2...3]), nil, 16)) / 255,
                green: .init(strtoul(String(chars[4...5]), nil, 16)) / 255,
                 blue: .init(strtoul(String(chars[6...7]), nil, 16)) / 255,
                alpha: .init(strtoul(String(chars[0...1]), nil, 16)) / 255)
    }
}

class PersonalStatViewController: UIViewController {
    var battlelog = [Battle]()
    var battlelogResults = [String: Any]()
    
    var player = Player()
    @IBOutlet var NameTextField: UILabel!
    @IBOutlet var ClubTextField: UILabel!
    @IBOutlet var TrophyTextField: UILabel!
    @IBOutlet var XpTextField: UILabel!
    @IBOutlet var roundedView: UIView!
    @IBOutlet var SolosTextField: UILabel!
    @IBOutlet var DuosTextField: UILabel!
    @IBOutlet var ThreeVThreeTextField: UILabel!
    @IBOutlet var RoboTimeTextField: UILabel!
    @IBOutlet var CharacterImageView: UIImageView!
    @IBOutlet weak var trophyGraph: LineChartView!
    @IBOutlet weak var battleOneImage: UIImageView!
    @IBOutlet weak var battleTwoImage: UIImageView!
    @IBOutlet weak var battleThreeImage: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func getTrophyChange() -> Int {
        var trophyChange = 0
        for battle in battlelog {
            trophyChange += battle.trophyChange
        }
        return trophyChange
    }
    
    func getNumBattles() -> Int {
        return battlelog.count
    }
    
    func initBattlelog() {
        let battleArray = battlelogResults["items"]
        
        for battle in battleArray as! [[String: Any]] {
            let battleDetails: NSDictionary = battle["battle"] as! NSDictionary
            let eventDetails: NSDictionary = battle["event"] as! NSDictionary
            // print(battleDetails)
            
            var tempBattle = Battle()
            tempBattle.duration = battleDetails["duration"] as? Int ?? 0
            tempBattle.mode = battleDetails["mode"] as? String ?? "no mode"
            tempBattle.result = battleDetails["result"] as? String ?? "rank"
            tempBattle.rank = battleDetails["rank"] as? Int ?? -1
            tempBattle.trophyChange = battleDetails["trophyChange"] as? Int ?? 0
            tempBattle.type = battleDetails["type"] as? String ?? "unranked"
            
            var tempEvent = Event()
            tempEvent.id = eventDetails["id"] as? Int ?? -1
            tempEvent.map = eventDetails["map"] as? String ?? "no map"
            tempEvent.mode = eventDetails["mode"] as? String ?? "no mode"
            
            tempBattle.event = tempEvent
            
            battlelog.append(tempBattle)
        }
        print("battlelog length: \(battlelog.count)")
    }
    
    func getBattleLog() {
        var done = false
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
            done = true
        }
        task.resume()
        repeat {
            RunLoop.current.run(until: Date(timeIntervalSinceNow: 0.01))
        } while !done
    }
    
    // This function looks at the current player and returns the Brawler object of the highest trophy brawler the player has
    func highestTropheyBrawler() -> (Brawler) {
        let brawlers = player.brawlers
        // print(brawlers)
        
        var highestBrawler = brawlers[0]
        
        for brawler in brawlers {
            // print(brawler)
            if brawler.trophies > highestBrawler.trophies {
                highestBrawler = brawler
            }
        }
        
        print(highestBrawler)
        
        return highestBrawler
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func generateChartData() -> [Double] {
        var currentTrophies = player.trophies
        
        var data = [Double]()
        
        data.append(Double(currentTrophies))
        
        for i in (0..<getNumBattles()).reversed() {
            let tempTrophies = battlelog[i].trophyChange
            currentTrophies -= tempTrophies
            data.append(Double(currentTrophies))
        }
        
        data.reverse()
        
        return data
    }
    
    
    
    func setChartData() {
        
        // var currentTrophies = player.trophies
        
        let chartData = generateChartData()
        
        let values = (0..<getNumBattles()).map { (i) -> ChartDataEntry in
            let val = chartData[i]
            return ChartDataEntry(x: Double(i), y: Double(val))
        }
        let set1 = LineChartDataSet(entries: values, label: "Trophy Change")
        
        // One line that changes all different parts that need a color
        let chartColor = UIColor(hexString: "#1B375A")
        
        set1.setColor(NSUIColor(cgColor: chartColor!.cgColor))
        
        set1.drawFilledEnabled = true
        set1.drawCirclesEnabled = false
        set1.drawCircleHoleEnabled = false
        set1.lineWidth = 2
        set1.fillAlpha = 0.5
        set1.drawValuesEnabled = false
        let gradientColors = [chartColor!.cgColor, UIColor.clear.cgColor] as CFArray // Colors of the gradient
        let colorLocations:[CGFloat] = [1.0, 0.0] // Positioning of the gradient
        let gradient = CGGradient.init(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations)
        set1.fill = Fill.fillWithLinearGradient(gradient!, angle: 90.0)
        set1.mode = .cubicBezier
        let data = LineChartData(dataSet: set1)
        data.setDrawValues(false)
        
        self.trophyGraph.data = data
        self.trophyGraph.isUserInteractionEnabled = false
    }
    
    func setBattlelogImages() {
        print(battlelog[0])
        if (battlelog[0].result == "victory" || (battlelog[0].result == "rank" && battlelog[0].rank < 5)) {
            battleOneImage.image = UIImage(systemName: "checkmark.rectangle.fill")
            battleOneImage.image = battleOneImage.image?.withRenderingMode(.alwaysTemplate)
            battleOneImage.tintColor = UIColor.green
        } else if (battlelog[0].result == "draw") {
            battleOneImage.image = UIImage(systemName: "minus.rectangle.fill")
            battleOneImage.image = battleOneImage.image?.withRenderingMode(.alwaysTemplate)
            battleOneImage.tintColor = UIColor.yellow
        } else {
            battleOneImage.image = UIImage(systemName: "xmark.rectangle.fill")
            battleOneImage.image = battleOneImage.image?.withRenderingMode(.alwaysTemplate)
            battleOneImage.tintColor = UIColor.red
        }
        
        print(battlelog[1])
        
        if (battlelog[1].result == "victory" || (battlelog[1].result == "rank" && battlelog[1].rank < 5)) {
            battleTwoImage.image = UIImage(systemName: "checkmark.rectangle.fill")
            battleTwoImage.image = battleTwoImage.image?.withRenderingMode(.alwaysTemplate)
            battleTwoImage.tintColor = UIColor.green
        } else if (battlelog[1].result == "draw") {
            battleTwoImage.image = UIImage(systemName: "minus.rectangle.fill")
            battleTwoImage.image = battleTwoImage.image?.withRenderingMode(.alwaysTemplate)
            battleTwoImage.tintColor = UIColor.yellow
        } else {
            battleTwoImage.image = UIImage(systemName: "xmark.rectangle.fill")
            battleTwoImage.image = battleTwoImage.image?.withRenderingMode(.alwaysTemplate)
            battleTwoImage.tintColor = UIColor.red
        }
        print(battlelog[2])
        
        if (battlelog[2].result == "victory" || (battlelog[2].result == "rank" && battlelog[2].rank < 5)) {
            battleThreeImage.image = UIImage(systemName: "checkmark.rectangle.fill")
            battleThreeImage.image = battleThreeImage.image?.withRenderingMode(.alwaysTemplate)
            battleThreeImage.tintColor = UIColor.green
        } else if (battlelog[1].result == "draw") {
            battleThreeImage.image = UIImage(systemName: "minus.rectangle.fill")
            battleThreeImage.image = battleThreeImage.image?.withRenderingMode(.alwaysTemplate)
            battleThreeImage.tintColor = UIColor.yellow
        } else {
            battleThreeImage.image = UIImage(systemName: "xmark.rectangle.fill")
            battleThreeImage.image = battleThreeImage.image?.withRenderingMode(.alwaysTemplate)
            battleThreeImage.tintColor = UIColor.red
        }
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
        
        let highestBrawler = highestTropheyBrawler()
        print("highestBraler: \(highestBrawler.name.lowercased())")
        
        var highestBrawlerName = highestBrawler.name
        
        if highestBrawlerName == "EL PRIMO" {
            highestBrawlerName = "el_primo"
        }
        if highestBrawlerName == "MR. P" {
            highestBrawlerName = "mr_p"
        }
        
        
        CharacterImageView.image = UIImage(named: highestBrawlerName.lowercased())
        // Change Character Image View through line above.
        /*
         Current Character Models:
         colt
         crow
         spike
         poco
         */
        getBattleLog()
        // print("Battlelog: \(battlelog)")
        print("Player Name: \(player.name)")
        print("Number of Battles: \(getNumBattles())")
        print("Trophy Change: \(getTrophyChange())")
        // print("Highest Trophy Brawler: \(highestTropheyBrawler())")
        
        
        trophyGraph.drawBordersEnabled = false
        //trophyGraph.dragEnabled = true
        trophyGraph.setScaleEnabled(true)
        // trophyGraph.pinchZoomEnabled = true
        trophyGraph.xAxis.drawGridLinesEnabled = true
        trophyGraph.xAxis.enabled = false
        trophyGraph.rightAxis.enabled = false
        trophyGraph.legend.enabled = false
        trophyGraph.minOffset = 10
        setChartData()
            
        trophyGraph.animate(xAxisDuration: 2)
        
        setBattlelogImages()
        

    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
