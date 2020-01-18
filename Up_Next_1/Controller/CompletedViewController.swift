//
//  CompletedViewController.swift
//  Up_Next_1
//
//  Created by Michaela Morrow on 1/17/20.
//  Copyright © 2020 Michaela Morrow. All rights reserved.
//

import UIKit
import SafariServices

class CompletedViewController: UIViewController {
    
    var playlistURL: String?
    
    
    @IBOutlet weak var openPlaylistButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true

        // Do any additional setup after loading the view.
    }
    
    @IBAction func openPlaylistPressed(_ sender: UIButton) {
        
        print(playlistURL ?? "Couldn't find url")
        openSpotifyWeb()
    }
    
    func openSpotifyWeb() {
        if let url = URL(string: playlistURL!) {
            let config = SFSafariViewController.Configuration()

            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
