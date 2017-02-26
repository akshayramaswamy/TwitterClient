//
//  SearchTerm.swift
//  Smashtag
//
//  Created by Akshay Ramaswamy on 2/24/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class SearchTerm: NSManagedObject {
    
    class func findOrCreateSearch(term: String, matching tweetInfo: Twitter.Tweet, in context: NSManagedObjectContext) throws -> SearchTerm?
    {
        let request: NSFetchRequest<SearchTerm> = SearchTerm.fetchRequest()
        request.predicate = NSPredicate(format: "term = %@", term)
        //don't need to sort because only 1 or 0 of these items
        //check if search term is already in database
        do {
            let searchTermArray = try context.fetch(request)
            if !searchTermArray.isEmpty{
                if let tweet = try? Tweet.findOrCreateTweet(term: term, matching: tweetInfo, in: context) {
                    searchTermArray[0].addToTweets(tweet!)
                }
                return searchTermArray[0]
            }
        } catch {
            throw error
        }
    
        //create new search term in database
        let searchTerm = SearchTerm(context: context)
        if let tweet = try? Tweet.findOrCreateTweet(term: term, matching: tweetInfo, in: context) {
            searchTerm.addToTweets(tweet!)
        }
        return searchTerm
        
    }
    
    
    
}

