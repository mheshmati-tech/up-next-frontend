//
//  ViewController.swift
//  Up_Next_1
//
//  Created by Michaela Morrow on 1/5/20.
//  Copyright © 2020 Michaela Morrow. All rights reserved.
//

import UIKit
import KeychainSwift

class ViewController: UIViewController, UITextFieldDelegate {
    
    let defaults = UserDefaults.standard
    let keychain = KeychainSwift()
    
    @IBOutlet weak var cityNameField: UITextField!
    @IBOutlet weak var playlistNameField: UITextField!
    
    var spotifyManager = SpotifyManager()
    var refreshTokenManager = RefreshTokenManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true
        
        cityNameField.delegate = self
        playlistNameField.delegate = self
    }

    @IBAction func generatePressed(_ sender: UIButton) {
        print("The first access token is \(keychain.get("accessToken") ?? String()) yeah")

//        let currentDate = Date()
//        if let expirationDate = defaults.object (forKey: "expirationDate") as? Date {
//            if expirationDate < currentDate.addingTimeInterval(5.0 * 60.0) {
//                refreshTokenManager.refreshToken()
//            }
//        }
        // once it finishes the check expiration process, submit the form
        // will probably need another round of closures within in order to switch to a new page when the process is complete
        checkExpiration {
            if $0 {
                DispatchQueue.main.async {
                    self.submitForm()
                }
            }
        }
        
//        cityNameField.endEditing(true)
//        submitForm()
        print("Generate button pressed")
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            return true
        } else {
            cityNameField.placeholder = "You must enter a city name!"
            playlistNameField.placeholder = "You must enter a playlist name!"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        if var city = cityNameField.text, let accessToken = keychain.get("accessToken") {
//            city = city.replacingOccurrences(of: " ", with: "%20")
//            spotifyManager.createPlaylist(cityName: city, accessToken: accessToken)
//        }
//        cityNameField.text = ""
//        cityNameField.placeholder = "Enter a city name"
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func submitForm() {
        print("The second access token is \(keychain.get("accessToken") ?? String()) yeah")
        if var city = cityNameField.text, var playlistName = playlistNameField.text, let accessToken = keychain.get("accessToken") {
            city = city.replacingOccurrences(of: " ", with: "%20")
            playlistName = playlistName.replacingOccurrences(of: " ", with: "%20")
            spotifyManager.createPlaylist(accessToken: accessToken, cityName: city, playlistName: playlistName) {
                if $0 {
                    let newPlaylistURL = $1
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(identifier: "CompletedViewController") as! CompletedViewController
                        vc.playlistURL = newPlaylistURL
                        self.navigationController!.pushViewController(vc, animated: true)
                    }
                }
            }
        }
        cityNameField.text = ""
        cityNameField.placeholder = "Enter a City Name"
        playlistNameField.text = ""
        playlistNameField.placeholder = "Enter a Playlist Name"
    }
    
    func checkExpiration(completed: @escaping (Bool) -> Void) {
        let currentDate = Date()
        if let expirationDate = defaults.object (forKey: "expirationDate") as? Date {
            // refresh the token if it will expire in less than 5 mintues
            if expirationDate < currentDate.addingTimeInterval(5.0 * 60.0) {
                refreshTokenManager.refreshToken {
                    if $0 {
                        completed(true)
                    }
                }
            } else {
                completed(true)
            }
        } else {
            completed(true)
        }
    }
    
}

