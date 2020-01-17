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
    
    func refreshToken(completed: @escaping (Bool) -> Void) {
        let urlString = refreshTokenURL
        performRequest(urlString: urlString) {
            if $0 {
                completed(true)
            }
        }
    }
    
    func performRequest(urlString: String, completed: @escaping (Bool) -> Void) {
        // 1. Create a URL
        
        if let url = URL(string: urlString), let refreshToken = keychain.get("refreshToken") {
            
            
            let bodyString = "refresh_token=\(refreshToken)"
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = bodyString.data(using: .utf8)
            
            // 2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            // 3. Give the session a task
            let task = session.dataTask(with: request) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    self.parseJSON(refreshTokenData: safeData) {
                        if $0 {
                            completed(true)
                        }
                    }
                }
            }
            task.resume()
            
        }
        
    }
    
    func parseJSON(refreshTokenData: Data, completed: (Bool) -> Void) {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(RefreshTokenData.self, from: refreshTokenData)
            keychain.set(decodedData.access_token, forKey: "accessToken")
            keychain.set(decodedData.refresh_token, forKey: "refreshToken")
            
            let expiration_date = Date().addingTimeInterval(Double(decodedData.expires_in))
            defaults.set(expiration_date, forKey: "expirationDate")
            
            print(decodedData.access_token)
            completed(true)
        } catch {
            print(error)
        }
        
    }
    
   
}
