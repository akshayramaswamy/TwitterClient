//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by Akshay Ramaswamy on 2/13/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class MentionsTableViewController: UITableViewController {
    
    private var mentions = [(title: String, mentionSections: Array<MentionType>)]()
    
    enum MentionType {
        case url(String)
        case hashtag(String)
        case userMention(String)
        case Image(NSURL, Double)
        
    }
    var tweet: Tweet? {
        didSet {
            if let media = tweet?.media, media.count > 0 {
                let imageTuple = (title: "Images",
                                  mentionSections: media.map { MentionType.Image($0.url as NSURL, $0.aspectRatio) })
                mentions.append(imageTuple)
                
            }
            if let urls = tweet?.urls, urls.count > 0 {
                let urlTuple = (title: "URLs",
                                mentionSections: urls.map { MentionType.url($0.keyword)})
                mentions.append(urlTuple)
                
            }
            if let users = tweet?.userMentions {
                let username = "@\(tweet!.user.screenName)"
                var userItems = [MentionType.userMention(username)]
                
                if users.count > 0 {
                    userItems =  userItems + users.map { MentionType.userMention($0.keyword) }
                }
                let userMentionTuple = (title: "Users", mentionSections: userItems)
                mentions.append(userMentionTuple)
            }
            if let hashtags = tweet?.hashtags, hashtags.count > 0 {
                let hashtagTuple  = (title: "Hashtags",
                                     mentionSections: hashtags.map { MentionType.hashtag($0.keyword) })
                mentions.append(hashtagTuple)
                
            }
            
            
            
            title = tweet?.user.screenName
        }
    }
    
    
    private func cellKeyWord(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, keyword: String) ->UITableViewCell{
        let cell =
            tableView.dequeueReusableCell(withIdentifier: "Mentions Identifier", for: indexPath)
        cell.textLabel?.text = keyword
        return cell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let mention = mentions[indexPath.section].mentionSections[indexPath.row]
        switch mention {
        case .hashtag(let keyword):
            return cellKeyWord(tableView, cellForRowAt: indexPath, keyword: keyword)
        case .url(let keyword):
            return cellKeyWord(tableView, cellForRowAt: indexPath, keyword: keyword)
        case .userMention(let keyword):
            return cellKeyWord(tableView, cellForRowAt: indexPath, keyword: keyword)
            
        case .Image(let url, _):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "Image Identifier", for: indexPath) as! ImageTableViewCell
            cell.imageUrl = url
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let mention = mentions[indexPath.section].mentionSections[indexPath.row]
        switch mention {
        case .Image(_, let ratio):
            let width = tableView.bounds.size.width
            return  width / CGFloat(ratio)
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return mentions.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return mentions[section].mentionSections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mentions[section].title
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "From hashtag or user mention" {
            if let cell = sender as? UITableViewCell {
                if let url = cell.textLabel?.text {
                    if url.hasPrefix("http"), #available(iOS 10, *){
                        UIApplication.shared.open(NSURL(string: url)! as URL)
                        return false
                    }
                }
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "From hashtag or user mention"{
            let destinationController = segue.destination
            
            if let tweetsController = destinationController as? TweetTableViewController {
                
                if let cell = sender as? UITableViewCell {
                    tweetsController.searchText = cell.textLabel?.text
                }
                
                
            }
        }
        if segue.identifier == "From Image"{
            let destinationController = segue.destination
            if let imageController = destinationController as? ImageViewController {
                if let cell = sender as? ImageTableViewCell {
                    
                    imageController.imageURL = cell.imageUrl as URL?

                    imageController.title = title
                }
            }
        }
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
