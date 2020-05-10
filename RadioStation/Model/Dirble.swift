//
//  Dirble.swift
//  RadioStation
//
//  Created by Airam Rguez on 10/05/2020.
//  Copyright © 2020 Airam Rguez. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum DirbleAPI {
    static func fetchFavouriteStations() -> [Station]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = appDelegate.persistentContainer.viewContext
        
        let favRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "StationEntity")
        favRequest.predicate = NSPredicate(format: "isFavourite == %@", NSNumber(booleanLiteral: true))
        
        var favStations: [Station]? = nil
        do {
            let records = try context.fetch(favRequest)
            favStations = records.map{ Station(from: $0 as! StationEntity) }
        } catch let error {
            print(error)
        }
        
        return favStations
    }
}
