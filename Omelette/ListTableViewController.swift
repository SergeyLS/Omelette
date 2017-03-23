//
//  ListTableViewController.swift
//  Omelette
//
//  Created by Sergey Leskov on 3/23/17.
//  Copyright © 2017 Sergey Leskov. All rights reserved.
//

import UIKit
import CoreData

class ListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    
   
    //==================================================
    // MARK: - Stored Properties
    //==================================================
    @IBOutlet weak var imageUI: UIImageView!
    @IBOutlet weak var titleUI: UILabel!
    @IBOutlet weak var textUI: UILabel!
    
    var searchController: UISearchController!
    
    lazy var fetchResultController = CoreDataManager.shared.fetchedResultsController(entityName: "Recipe", keyForSort: "title")
    
    //==================================================
    // MARK: - General
    //==================================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.placeholder = "Search..."
//        searchController.searchBar.tintColor = UIColor.white
//        searchController.searchBar.barTintColor = UIColor(red: 20.0/255.0, green: 20.0/255.0, blue: 20.0/255.0, alpha: 1.0)

        
        // UIRefreshControl
        refreshControl = UIRefreshControl()
        refreshControl?.backgroundColor = UIColor.white
        refreshControl?.tintColor = UIColor.gray
        refreshControl?.addTarget(self, action: #selector(loadData), for: UIControlEvents.valueChanged)


        fetchResultController.delegate = self
        do {
            try fetchResultController.performFetch()
        } catch {
            print(error)
        }

        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableViewAutomaticDimension
        
        loadData()
     }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //==================================================
    // MARK: - Table view data source
    //==================================================

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
       return fetchResultController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchResultController.sections, sections.count > 0 {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
        
        let recipe = fetchResultController.object(at: indexPath) as! Recipe
        
        cell.titleUI.text = recipe.title
        cell.descriptionUI.text = recipe.descript
        
        cell.photoUI.image = UIImage()
        cell.photoUI.layer.cornerRadius = cell.photoUI.frame.height / 2.0
        cell.photoUI.layer.masksToBounds = true
        
        DispatchQueue.main.async {
            RecipeManager.getImage(recipe: recipe, completion: { (image) in
                
                cell.photoUI.image = image
                
                
            })
        }

        
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = fetchResultController.object(at: indexPath) as! Recipe
        
        if let profile_path = recipe.profile_path,
            let url = URL(string: profile_path)
        {
             UIApplication.shared.open(url)
        }
        

    }

    
    //==================================================
    // MARK: - fetchResultController
    //==================================================
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView?.reloadData()
    }

    
    //==================================================
    // MARK: - load
    //==================================================
    
    func loadData() {
        RecipeManager.getFromAPI {[weak self] result in
            DispatchQueue.main.async {
                self?.refreshControl?.endRefreshing()
             }
        }
        
    }
    
    //==================================================
    // MARK: - Search
    //==================================================
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            
            if searchText.isEmpty {
                fetchResultController.fetchRequest.predicate =   nil
            } else {
                fetchResultController.fetchRequest.predicate =   NSPredicate(format:"title contains[cd] %@", searchText)
            }
            
            
             do {
                try fetchResultController.performFetch()
            } catch {
                print(error)
            }
            tableView.reloadData()
            
        }
        
    }

}
