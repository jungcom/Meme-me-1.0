//
//  SentMemesTableViewController.swift
//  Meme me 1.0
//
//  Created by Anthony Lee on 6/4/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit
private let reuseIdentifier = "MemeCell"

class SentMemesTableViewController: UITableViewController {
    
    var memes: [Meme]! {
        var object = UIApplication.shared.delegate
        var appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.leftBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
        let meme = self.memes[(indexPath as NSIndexPath).row]
        
        // Set the name and image
        cell.textLabel?.text = meme.topText
        cell.detailTextLabel?.text = meme.bottomText
        cell.imageView?.image = meme.memedImage

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let memeDetailController = storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetailController.meme = memes[indexPath.row]
        self.navigationController!.pushViewController(memeDetailController, animated: true)
    }

}
