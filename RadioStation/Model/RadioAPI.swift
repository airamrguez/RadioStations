//
//  RadioAPI.swift
//  RadioStation
//
//  Created by Airam Rguez on 09/05/2020.
//  Copyright © 2020 Airam Rguez. All rights reserved.
//

import Foundation

enum RadioAPI {
    static let BaseURL = "http://de1.api.radio-browser.info/"
    static let Format = "json"
    
    static let TagsURL = "\(BaseURL)\(Format)/tags"
    
    static func getTags(onComplete: @escaping(([String]) -> Void)) {
        guard let url = URL(string: TagsURL) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            do {
                guard let jsonResponse = try JSONSerialization.jsonObject(with: data, options: []) as? [Any] else { return }
                guard let jsonArray = jsonResponse as? [[String: Any]] else { return }
                
                var tags = [String]()
                for object in jsonArray {
                    guard let name = object["name"] as? String else { return }
                    tags.append(name)
                }
                onComplete(tags)
            } catch let error {
                print(error)
            }
        }.resume()
    }
}
