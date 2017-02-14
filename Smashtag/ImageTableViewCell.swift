//
//  ImageTableViewCell.swift
//  Smashtag
//
//  Created by Akshay Ramaswamy on 2/13/17.
//  Copyright © 2017 Stanford University. All rights reserved.
//

import UIKit

    
    class ImageTableViewCell: UITableViewCell {
        
        @IBOutlet weak var attachedImage: UIImageView!
       
        //@IBOutlet weak var spinner: UIActivityIndicatorView!
        
        var imageUrl: NSURL? { didSet { updateUI() } }
        
        func updateUI() {
            attachedImage?.image = nil
            if let url = imageUrl {
                //spinner?.startAnimating()
                
                DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                    let urlContents = try? Data(contentsOf: url as URL)
                        if let imageData = urlContents, url == self?.imageUrl {
                           
                                self?.attachedImage?.image = UIImage(data: imageData)
                                
                            
                            
                            
                            //self?.spinner?.stopAnimating()
                        } else{
                            self?.attachedImage?.image = nil
                    }
                    }
                
            }
        }
        
    }


