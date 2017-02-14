//
//  GlobalTruth.swift
//  Smashtag
//
//  Created by Akshay Ramaswamy on 2/14/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import Foundation

class GlobalTruth{
    //stores the past 100 searches
    private let storedHistory = UserDefaults.standard
    var recentValues: [String] {
        get {
            return storedHistory.array(forKey: "History") as? [String] ?? []
        }
        set { storedHistory.set(newValue, forKey: "History") }
        
    }
    
    //adds search to history, and replaces search if it has
    //already been done
    func add(search: String) {
        if let index = recentValues.index(of: search)
        {
            recentValues.remove(at: index)
        }
        recentValues.insert(search, at: 0)
        while recentValues.count > 100 {
            recentValues.removeLast()
        }
        
    }
    
    func removeAtIndex(index: Int) {
        recentValues.remove(at: index)
    }
}
