//
//  Recipe+CoreDataProperties.swift
//  Omelette
//
//  Created by Sergey Leskov on 3/23/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData


extension Recipe {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Recipe> {
        return NSFetchRequest<Recipe>(entityName: "Recipe");
    }

    @NSManaged public var photo: Data?
    @NSManaged public var title: String?
    @NSManaged public var descript: String?
    @NSManaged public var profile_path: String?
    @NSManaged public var photo_path: String?
    

}
