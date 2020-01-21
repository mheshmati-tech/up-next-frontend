//
//  RefreshTokenManager.swift
//  Up_Next_1
//
//  Created by Michaela Morrow on 1/16/20.
//  Copyright © 2020 Michaela Morrow. All rights reserved.
//

import Foundation
import KeychainSwift

struct RefreshTokenManager {
    
    let keychain = KeychainSwift()
    let defaults = UserDefaults.standard
    let refreshTokenURL = "https://up-next-playlist.herokuapp.com/api/refresh_token"
    
    func refreshToken(completed: @escaping (Bool, String) -> Void) {
        let urlString = refreshTokenURL
        performRequest(urlString: urlString) {
            if $0 {
                completed(true, $1)
            }
        }
    }
    
    func performRequest(urlString: String, completed: @escaping (Bool, String) -> Void) {
        
        if let url = URL(string: urlString), let refreshToken = keychain.get("refreshToken") {
            
            let bodyString = "refresh_token=\(refreshToken)"
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = bodyString.data(using: .utf8)
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    self.parseJSON(refreshTokenData: safeData) {
                        if $0 {
                            completed(true, $1)
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(refreshTokenData: Data, completed: (Bool, String) -> Void) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(RefreshTokenData.self, from: refreshTokenData)
            if decodedData.access_token != "false" {
                keychain.set(decodedData.access_token, forKey: "accessToken")
                keychain.set(decodedData.refresh_token, forKey: "refreshToken")
                
                let expiration_date = Date().addingTimeInterval(Double(decodedData.expires_in))
                defaults.set(expiration_date, forKey: "expirationDate")
                
                completed(true, "")
            } else {
                completed(true, "Failed to refresh Spotify log-in; restart the app to log-in again.")
            }
        } catch {
            print(error)
        }
        
    }
    
   
}
