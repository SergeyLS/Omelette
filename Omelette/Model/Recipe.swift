//
//  Recipe+CoreDataClass.swift
//  Omelette
//
//  Created by Sergey Leskov on 3/23/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import CoreData


public class Recipe: NSManagedObject {

    //==================================================
    // MARK: - Stored Properties
    //==================================================
    
    static let type = "Recipe"
    
    
    //==================================================
    // MARK: - Initializers
    //==================================================
    
    class func entity(dictionary: NSDictionary, context: NSManagedObjectContext) -> Recipe? {
        guard let title = dictionary["title"] as? String,
            let profile_path = dictionary["href"] as? String,
            let photo_path = dictionary["thumbnail"] as? String,
            let descript = dictionary["ingredients"] as? String
            else {
                return nil
        }
        let resultEntity = Recipe(context: context)
        
        resultEntity.title = title
        resultEntity.profile_path = profile_path
        resultEntity.descript = descript
        resultEntity.photo_path = photo_path
        
        print("add \(type): " + title)
        
        return resultEntity;
    }

    
}
