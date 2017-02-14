//
//  HistoryTableTableViewController.swift
//  Smashtag
//
//  Created by Akshay Ramaswamy on 2/14/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

//reloads tweet history
class HistoryTableTableViewController: UITableViewController {

    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalTruth().recentValues.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Recent Searches", for: indexPath)
        cell.textLabel?.text = GlobalTruth().recentValues[indexPath.row]
        
        return cell
    }
    
    //extra credit - allows user to delete certain searches
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            GlobalTruth().removeAtIndex(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    // sets search text before seguing to Tweet Table View Controller if user clicks on recent search item
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let tvController = segue.destination as? TweetTableViewController {
            if let cell = sender as? UITableViewCell {
                tvController.searchText = cell.textLabel?.text
            }
        }
        
    }
    
}
