//
//  PeopleModel.swift
//  LanguageApp
//
//  Created by Luke Thompson on 12/6/2024.
//

import Foundation

class PeopleModel: ObservableObject {
    @Published var users = []
    
    // Email login
    func fetchUsers(completion: @escaping (Error?) -> Void) {
        loggingIn = true
        
        let backendURL: String = UserDefaults.standard.string(forKey: "BackendURL") ?? ""
        
        // Define the URL of your backend login endpoint
        guard let url = URL(string: "\(backendURL)/account/login/email") else {
            self.loggingIn = false
            completion(NSError(domain: "InvalidURL", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"]))
            return
        }
        
        // Define the request parameters
        let parameters: [String: Any] = ["email": email, "password": password]
        guard let body = try? JSONSerialization.data(withJSONObject: parameters) else {
            self.loggingIn = false
            completion(NSError(domain: "SerializationError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to serialize parameters"]))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        // Perform the request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            // Handle response
            if let error = error {
                self.loggingIn = false
                completion(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                self.loggingIn = false
                if let data = data,
                   let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let message = json["message"] as? String {
                    completion(NSError(domain: "HTTPError", code: 0, userInfo: [NSLocalizedDescriptionKey: message]))
                } else {
                    completion(NSError(domain: "HTTPError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response"]))
                }
                return
            }
            
            guard let data = data else {
                self.loggingIn = false
                completion(NSError(domain: "NoData", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data returned"]))
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let token = json["token"] as? String,
                   let user_id = json["_id"] as? String,
                   let is_profile_setup = json["profileIsSetup"] as? Bool {
                    // Store token in storage (e.g., UserDefaults)
                    UserDefaults.standard.set(token, forKey: "JWT-Token")
                    UserDefaults.standard.set(user_id, forKey: "_id")
                    UserDefaults.standard.set(is_profile_setup, forKey: "Profile-Setup")
                    self.jwtToken = token
                    self.userID = user_id
                    self.isLoggedin = !self.jwtToken.isEmpty && !self.userID.isEmpty
                    self.profileIsSetup = is_profile_setup
                    self.loggingIn = false
                    completion(nil)
                } else {
                    self.loggingIn = false
                    completion(NSError(domain: "InvalidResponse", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON response"]))
                }
            } catch {
                self.loggingIn = false
                completion(error)
            }
        }
        
        task.resume()
    }
}
