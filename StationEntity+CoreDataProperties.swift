//
//  StationEntity+CoreDataProperties.swift
//  RadioStation
//
//  Created by Airam Rguez on 10/05/2020.
//  Copyright © 2020 Airam Rguez. All rights reserved.
//
//

import Foundation
import CoreData


extension StationEntity {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<StationEntity> {
        return NSFetchRequest<StationEntity>(entityName: "StationEntity")
    }

    @NSManaged public var imageURL: String
    @NSManaged public var isFavourite: Bool
    @NSManaged public var name: String
    @NSManaged public var streamURL: String

}
