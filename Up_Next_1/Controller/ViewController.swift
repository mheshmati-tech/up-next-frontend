//
//  ViewController.swift
//  Up_Next_1
//
//  Created by Michaela Morrow on 1/5/20.
//  Copyright © 2020 Michaela Morrow. All rights reserved.
//

import UIKit
import KeychainSwift

class ViewController: UIViewController {
    
    let defaults = UserDefaults.standard
    let keychain = KeychainSwift()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func generatePressed(_ sender: UIButton) {
        print("Generate button pressed")
        print("The access token is \(keychain.get("accessToken") ?? String()) yeah")
    }
    
}

