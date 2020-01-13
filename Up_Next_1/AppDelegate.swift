//
//  AppDelegate.swift
//  Up_Next_1
//
//  Created by Michaela Morrow on 1/5/20.
//  Copyright © 2020 Michaela Morrow. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    lazy var rootViewController = LogInViewController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // Override point for customization after application launch.
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // I added below from spotify and changed self to rootViewController and added a . before .OpenURLOptionsKey
    
//    func sessionManager(manager: SPTSessionManager, didInitiate session: SPTSession) {
//      print("success", session)
//        DispatchQueue.main.async {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard.instantiateViewController(identifier: "SearchViewController") as! ViewController
//        self.navigationController!.pushViewController(vc, animated: true)
//        }
//    }
//
//    func sessionManager(manager: SPTSessionManager, didFailWith error: Error) {
//      print("fail", error)
//    }
//    func sessionManager(manager: SPTSessionManager, didRenew session: SPTSession) {
//      print("renewed", session)
//    }
//
//    let SpotifyClientID = "8f39e1b6b595428cb6b26fae696b2495"
//    let SpotifyRedirectURL = URL(string: "up-next-quick-start://spotify-login-callback")!
//
//    lazy var configuration = SPTConfiguration(
//      clientID: SpotifyClientID,
//      redirectURL: SpotifyRedirectURL
//    )
//
//    lazy var sessionManager: SPTSessionManager = {
//      if let tokenSwapURL = URL(string: "https://up-next-quick-start-token-swap.herokuapp.com/api/token"),
//         let tokenRefreshURL = URL(string: "https://up-next-quick-start-token-swap.herokuapp.com/api/refresh_token") {
//        self.configuration.tokenSwapURL = tokenSwapURL
//        self.configuration.tokenRefreshURL = tokenRefreshURL
//        self.configuration.playURI = ""
//      }
//      let manager = SPTSessionManager(configuration: self.configuration, delegate: self)
//      return manager
//    }()
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
      rootViewController.sessionManager.application(app, open: url, options: options)
      return true
    }
    
}

