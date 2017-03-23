//
//  RecipeManager.swift
//  Omelette
//
//  Created by Sergey Leskov on 3/23/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import Foundation
import UIKit
import CoreData

enum Result<T> {
    case success(T)
    case failure(Error)
}



class RecipeManager {
    
    static func getRecipeByTitle(title: String) -> Recipe? {
        
        if title == "" { return nil }
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: Recipe.type)
        let predicate = NSPredicate(format: "title == %@", argumentArray: [title])
        request.predicate = predicate
        
        let resultsArray = (try? CoreDataManager.shared.viewContext.fetch(request)) as? [Recipe]
        
        return resultsArray?.first ?? nil
    }

    
    static func getFromAPI(completion: @escaping () -> Void) {
        NetworkManager.getFromAPI() { result in
            switch result {
            case .success(let resultDict):
                let moc = CoreDataManager.shared.newBackgroundContext
                moc.perform{ [weakMoc = moc] in
                    for  element in resultDict {
                          guard
                              let title = element["title"] as? String
                            else {
                                print("error - getFromAPI")
                            continue
                        }
                        
                        
                        if let _ = getRecipeByTitle(title: title )  {
                        } else {
                            // New
                            guard let _ = Recipe.entity(dictionary: element as NSDictionary, context: weakMoc) else {
                                print("Error: Could not create a new Recipe from API.")
                                continue
                            }
                            
                        } //else
                        
                    } //for  element in popularDict
                    
                    CoreDataManager.shared.save(context: weakMoc)
                    completion()
                }
                
            case .failure(_):
                completion()
            }
        }
    }
    
    
    
    static func getImage(recipe: Recipe, completion: @escaping (_ image: UIImage) -> Void)  {
        
        if let foto = recipe.photo
        {
            
            completion(UIImage(data: foto)!)
            
            
        } else {
            
            if let photo_path = recipe.photo_path,
                let url = URL(string: photo_path)
            {
                NetworkManager.getDataFromUrl(url: url) { (data, response, error)  in
                    guard let data = data, error == nil else { return }
                    
                    DispatchQueue.main.async() { () -> Void in
                        
                        let image = UIImage(data: data)!
                        
                        let data = UIImagePNGRepresentation(image)
                        
                        recipe.photo = data
                        CoreDataManager.shared.saveContext()
                        
                        completion(image)
                    }
                    
                }
            }
        }
        
    } //func getImage
    
    
    
    
}
