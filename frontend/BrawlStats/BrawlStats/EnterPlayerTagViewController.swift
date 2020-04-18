//
//  ViewController.swift
//  BrawlStats
//
//  Created by Tony Chen on 3/30/20.
//  Copyright © 2020 BrawlStats-Purdue. All rights reserved.
//

import Foundation
import UIKit

class EnterPlayerTagViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet var userTagField: UITextField!
    @IBOutlet var UserTagView: UIView!
    @IBOutlet var roundedView: UIView!
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
        hideKeyboardWhenTappedAround()
        UserTagView.layer.cornerRadius = 10
        roundedView.layer.cornerRadius = 38
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // print("RECENT SEARCHES: \(getRecentSearchesPlayer())")
        
        // TODO: reload the recent searches data every time the view appears
    }
    
    func getRecentSearches() -> [Data] {
        let defaults = UserDefaults.standard
        let searchesData = defaults.object(forKey: recentSearchKey) as? [Data] ?? []
        // print("searchesData: \(searchesData)")
        return searchesData
    }
    
    func getRecentSearchesPlayer() -> [Player] {
        let searchesData: [Data] = getRecentSearches()
        
        var searches = [Player]()
        for searchData in searchesData {
            searches.insert(convertDataToPlayer(playerData: searchData), at: 0)
        }
        return searches
    }
    
    func convertPlayerToData(tempPlayer: Player) -> Data {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(tempPlayer) {
            return encoded
        }
        return Data()
    }
    
    func convertDataToPlayer(playerData: Data) -> Player {
        let decoder = JSONDecoder()
        if let decodedPlayer = try? decoder.decode(Player.self, from: playerData) {
            // print(decodedPlayer)
            return decodedPlayer
        }
        return Player()
    }
    
    @objc func buttonAction(sender: UIButton!) {
        // print("Button tapped")
        // print(sender.titleLabel!.text!)
        
        getData(usertag: sender.titleLabel!.text!)
    }
    
    func addRecentSearch(playerInfo: Player) {
        // let userDefaults = UserDefaults.standard
        
        // If searches hasn't been setup yet, it will be initialized as an empty array
        let searchesData: [Data] = getRecentSearches()
        
        var searches = [Player]()
        for searchData in searchesData {
            searches.insert(convertDataToPlayer(playerData: searchData), at: 0)
        }
        
        // to make sure we don't have duplicates, only insert if they dont already exist
        if !searches.contains(playerInfo) {
            // insert the new usertag at the front
            searches.insert(playerInfo, at: 0)
        }
        
        // if the length is now longer than numRecentSearches, we will remove the final element
        if searches.count > numRecentSearches {
            searches.removeLast()
        }
        
        // print("Searches: \(searches)")
        var temp = [Data]()
        for searchPlayer in searches {
            temp.insert(convertPlayerToData(tempPlayer: searchPlayer), at: 0)
        }
        // print("Searches as Data: \(temp)")
        let defaults = UserDefaults.standard
        defaults.set(temp, forKey: recentSearchKey)
        // print("Successfully encoded data")
        
        // Now we put the data back in UserDefaults.
        
        // userDefaults.set(searches, forKey: recentSearchKey)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // let userDefaults = UserDefaults.standard
        let searches: [Player] = getRecentSearchesPlayer()
        return searches.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentCollectionViewCell", for: indexPath) as! RecentCollectionViewCell
        // let userDefaults = UserDefaults.standard
        let searches: [Player] = getRecentSearchesPlayer()
        cell.userLabel.text = searches[indexPath.row].name
        cell.imageView.image = UIImage(named: "colt")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        // let userDefaults = UserDefaults.standard
        let searches: [Player] = getRecentSearchesPlayer()
        
        let player = searches[indexPath[1]]
        
        var usertag = player.tag
        // Since usertags start with a #, we remove the first character
        usertag.remove(at: usertag.startIndex)
        
        getData(usertag: usertag)
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
        if let text = userTagField.text?.uppercased(), !text.isEmpty {
            let characterSet = Set(String("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890"))
            
            getData(usertag: String(text.filter { characterSet.contains($0) }))
        } else {
            let alert = UIAlertController(title: "Error", message: "Field is empty!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true)
            return
        }
    }
    
    func segToPersonalStat() {
        // print(player.club)
        if player.tag == "#000000000" {
            let alert = UIAlertController(title: "Error", message: "Invalid Tag!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true)
            return
        } else {
            performSegue(withIdentifier: "EnterTagToPersonalStat", sender: self)
            addRecentSearch(playerInfo: self.player)
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
        player.club = personalStat["club"] as? [String: String] ?? [String: String]()
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
        if segue.identifier == "EnterTagToPersonalStat" {
            if let personalStatPage = segue.destination as? PersonalStatViewController {
                personalStatPage.player = player
            }
        }
    }
}
