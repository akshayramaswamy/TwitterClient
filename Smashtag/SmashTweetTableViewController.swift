//
//  SmashTweetTableViewController.swift
//  Smashtag
//
//  Created by Akshay Ramaswamy on 2/22/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import Twitter
import CoreData

class SmashTweetTableViewController: TweetTableViewController
{
    //default to appdelegate persistent container
    var container: NSPersistentContainer? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    override func insertTweets(_ newTweets: [Twitter.Tweet]) {
        super.insertTweets(newTweets)
        updateDatabase(with: newTweets)
    }
    
    private func updateDatabase(with tweets: [Twitter.Tweet]){
        container?.performBackgroundTask{ [weak self] context in
            for twitterInfo in tweets {
                //add tweet
                _ = try? SearchTerm.findOrCreateSearch(term: (self?.searchText!)!, matching: twitterInfo, in: context)
            }
            try? context.save()
            self?.printDatabaseStatistics()
        }
        
    }
    
    private func printDatabaseStatistics(){
        if let context = container?.viewContext {
            context.perform {
                if let tweetCount = (try? context.fetch(Tweet.fetchRequest()))?.count{
                    print ("\(tweetCount) tweets")
                }

            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Tweeters Mentioning Search Term"{
            if let tweetersTVC = segue.destination as? SmashTweetersTableViewController{
                tweetersTVC.mention = searchText
                tweetersTVC.container = container
            }
        }
        
        if let mentionsController = segue.destination as? MentionsTableViewController {
            if let tweetCell = sender as? TweetTableViewCell{
                mentionsController.tweet = tweetCell.tweet
            }
            
        }
    }
}
