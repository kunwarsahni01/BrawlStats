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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func enterTapped(_ sender: Any) {
        print(userTagField.text)
    }
}
