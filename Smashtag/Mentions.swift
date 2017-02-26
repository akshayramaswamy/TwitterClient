//
//  Mentions.swift
//  Smashtag
//
//  Created by Akshay Ramaswamy on 2/24/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import CoreData
import Twitter

class Mentions: NSManagedObject {
    
    
    class func findOrCreateMention(in context: NSManagedObjectContext, hashTagOrUserMention: String, term: String) throws -> Mentions?
    {
        let request: NSFetchRequest<Mentions> = Mentions.fetchRequest()
        request.predicate = NSPredicate(format: "text =[cd] %@ AND searchTerm = %@", hashTagOrUserMention, term)
        //if mention exists in database, increment it
        do {
            let mention = try context.fetch(request)
            if !mention.isEmpty{
                mention[0].count = mention[0].count + 1
                return mention[0]
            }
        }
        catch {
            throw error
        }
        //otherwise create a new mention with count set to 1
        let mention = Mentions(context: context)
        mention.count = 1
        mention.searchTerm = term
        mention.text = hashTagOrUserMention.lowercased()
        return mention
        
    }
    
}

