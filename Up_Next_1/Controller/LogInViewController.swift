//
//  LogInViewController.swift
//  Up_Next_1
//
//  Created by Michaela Morrow on 1/9/20.
//  Copyright © 2020 Michaela Morrow. All rights reserved.
//

import UIKit
import KeychainSwift
import DotEnv

class LogInViewController: UIViewController, SPTSessionManagerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginSpinner.stopAnimating()
    }
    
    @IBOutlet weak var loginSpinner: UIActivityIndicatorView!
    
    let defaults = UserDefaults.standard
    let keychain = KeychainSwift()
    
    let projectRoot = URL(fileURLWithPath: #file).pathComponents.dropLast(3).joined(separator: "/")
    
    lazy var envFilePath:String = {
        return NSString.path(withComponents: [self.projectRoot, ".env"])
    }()
    
    lazy var env = {
        return DotEnv(withFile: envFilePath)
    }()
    
    lazy var SpotifyClientID:String = {
        return self.env.get("SPOTIFY_CLIENT_ID")!
    }()
    
    let SpotifyRedirectURL = URL(string: "up-next-quick-start://spotify-login-callback")!
    
    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
      print("success", session)
        keychain.set(session.accessToken, forKey: "accessToken")
        keychain.set(session.refreshToken, forKey: "refreshToken")
        defaults.set(session.expirationDate, forKey: "expirationDate")
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "SearchViewController") as! ViewController
            self.navigationController!.pushViewController(vc, animated: true)
            self.loginSpinner.stopAnimating()
        }
    }
    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
      print("fail", error)
        DispatchQueue.main.async{
          self.loginSpinner.stopAnimating()
          let alertController = UIAlertController(title: "Login Failed", message:
              "Unable to log in, please try again later.", preferredStyle: .alert)
          alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
          self.present(alertController, animated: true, completion: nil)
        }
    }
    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
      print("renewed", session)
        keychain.set(session.accessToken, forKey: "accessToken")
        keychain.set(session.refreshToken, forKey: "refreshToken")
        defaults.set(session.expirationDate, forKey: "expirationDate")
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "SearchViewController") as! ViewController
            self.navigationController!.pushViewController(vc, animated: true)
            self.loginSpinner.stopAnimating()
        }
    }

    lazy var configuration = SPTConfiguration(
      clientID: SpotifyClientID,
      redirectURL: SpotifyRedirectURL
    )

    lazy var sessionManager: SPTSessionManager = {
      if let tokenSwapURL = URL(string: "https://up-next-quick-start-token-swap.herokuapp.com/api/token"),
         let tokenRefreshURL = URL(string: "https://up-next-quick-start-token-swap.herokuapp.com/api/refresh_token") {
        self.configuration.tokenSwapURL = tokenSwapURL
        self.configuration.tokenRefreshURL = tokenRefreshURL
        self.configuration.playURI = ""
      }
      let manager = SPTSessionManager(configuration: self.configuration, delegate: self)
      return manager
    }()
    
    
    
    
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        let requestedScopes: SPTScope = [.appRemoteControl, .playlistModifyPrivate]
        if self.sessionManager.session != nil {
            self.sessionManager.renewSession()
        } else {
            self.sessionManager.initiateSession(with: requestedScopes, options: .default)
        }
        
        loginSpinner.startAnimating()
        
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
