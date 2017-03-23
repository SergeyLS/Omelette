//
//  NetworkManager.swift
//  Omelette
//
//  Created by Sergey Leskov on 3/23/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation


class NetworkManager {
    
    static func getFromAPI(completion: @escaping (Result<[[String : AnyObject]]>) -> Void) {
        
        let stringURL = RecipepuppyConfig.DefaultURL
        
        let url = URL(string: stringURL)!
        
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let session = URLSession(configuration: .default)
        let task: URLSessionDataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let data = data,
                let dataDictionary = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String : Any],
                let popularsRep = dataDictionary["results"] as? [[String : AnyObject]]
            {
                completion(Result.success(popularsRep))
                
            } else {
                completion(Result.failure(error!))
            }
            
        }
        task.resume()
        
    }
    
    
    static func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
}
