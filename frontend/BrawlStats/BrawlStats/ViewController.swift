//
//  ViewController.swift
//  BrawlStats
//
//  Created by Tony Chen on 3/30/20.
//  Copyright © 2020 BrawlStats-Purdue. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userTagField: UITextField!
    var personalStat = [String : Any]()
    var brawlers = [[String : Any]]()
    var club = [String : String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // getting json from URL
        let url = URL(string: "http://localhost:3000/players/9JCLVJV20")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                self.personalStat = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                // TODO: call a function that would generate the codeable and populate the personal stat page
                self.gettingInfo()
            }
        }
        task.resume()
        
        // Do not try to get personal stats here, request is in a separate thread, and the array will be empty
        
    }

    @IBAction func enterTapped(_ sender: Any) {
        print(userTagField.text)
    }
    
    // demo function on how to get the data.
    // TODO: turn this in to a codeable
    func gettingInfo() {
        
        // getting the basic information, tag can obviously be anything else,
        // example: name, nameColor, trophies
        // structure string : any
        print("tag: \(personalStat["tag"] as! String)")
        
        // getting club information, didn't have something to be tested on, but here is the structure
        // "club": {
        // "tag": "string",
        //  "name": "string"
        // }
        club = personalStat["club"] as! [String : String]
        print("clubs: \(club)")
        
        // getting brawlers information.
        // array of String : Any
        
        // getting the entire brawlers array
        brawlers = personalStat["brawlers"] as! [[String : Any]]
        
        // getting a specific brawlers by index
        print("brawler: \(brawlers[0])")
        
        // getting specific information from a brawler
        let selectedBralwer = brawlers[0];
        print("brawler's name: \(selectedBralwer["name"]!)")
    }
}
