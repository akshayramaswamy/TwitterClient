//
//  SmashTweetersTableViewController.swift
//  Smashtag
//
//  Created by Akshay Ramaswamy on 2/22/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class SmashTweetersTableViewController: FetchedResultsTableViewController
{
    var mention: String?{
        didSet{updateUI()}
    }
    
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer{
            didSet{updateUI()}
    }
    
    var fetchedResultsController: NSFetchedResultsController<Mentions>?
    
    private func updateUI(){
        if let context = container?.viewContext, mention != nil {
            let request: NSFetchRequest<Mentions> = Mentions.fetchRequest()
            
            //sort by mention count, break ties alphabetically (with @ signs first)
            request.sortDescriptors = [NSSortDescriptor(
                key: "count",
                ascending: false
                ), NSSortDescriptor(
                key: "text",
                ascending: true,
                selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                )]
            let minCount = 1
            request.predicate = NSPredicate(format: "count > \(minCount) AND searchTerm =[cd] %@", mention!)
        
            fetchedResultsController = NSFetchedResultsController<Mentions>(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
            fetchedResultsController?.delegate = self
            try? fetchedResultsController?.performFetch()
            tableView.reloadData()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PopularMention Cell", for: indexPath)
        if let mention = fetchedResultsController?.object(at: indexPath) {
            cell.textLabel?.text = mention.text
            let tweetCount = mention.count
            cell.detailTextLabel?.text = "\(tweetCount) tweet\((tweetCount == 1) ? "" : "s")"
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let tvController = segue.destination as? TweetTableViewController {
                if let cell = sender as? UITableViewCell {
                    tvController.searchText = cell.textLabel?.text
                }
            }
        
    }
    
    
}
