//
//  Tweet.swift
//  Smashtag
//
//  Created by Akshay Ramaswamy on 2/22/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class Tweet: NSManagedObject {
    class func findOrCreateTweet(term: String, matching tweetInfo: Twitter.Tweet, in context: NSManagedObjectContext) throws -> Tweet?
    {
        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        request.predicate = NSPredicate(format: "unique = %@", tweetInfo.identifier)

        //don't need to sort because only 1 or 0 of these items
        do {
            let tweetArray = try context.fetch(request)
            if !tweetArray.isEmpty{
                //return if tweet is already in database (so we don't double count)
                return tweetArray[0]
            }
        } catch {
            throw error
        }
        
        //otherwise create new tweet in database and add hashtag / user mentions
        let tweet = Tweet(context: context)
        tweet.unique = tweetInfo.identifier
        tweet.text = tweetInfo.text
        tweet.created = tweetInfo.created as NSDate
        for hashtag in tweetInfo.hashtags {
            if let mention = try? Mentions.findOrCreateMention(in: context, hashTagOrUserMention: hashtag.keyword, term:term){
                tweet.addToMentions(mention!)
            }
        }
        for userMention in tweetInfo.userMentions {
            if let mention = try? Mentions.findOrCreateMention(in: context, hashTagOrUserMention: userMention.keyword, term:term){
                tweet.addToMentions(mention!)
            }
        }
        return tweet
    
    }
    
}
