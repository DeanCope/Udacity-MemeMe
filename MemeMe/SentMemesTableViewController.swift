//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Dean Copeland on 3/23/17.
//  Copyright © 2017 Dean Copeland. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {

    private struct Storyboard {
        static let reuseIdentifier = "SentMemeCell"
        static let showMemeDetailSegueId = "ShowMemeDetail"
    }
    
    var memes: [Meme] {
        get {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.memes
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.memes.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.reuseIdentifier, for: indexPath) as! SentMemeTableViewCell
        
        let meme = memes[indexPath.row]
        cell.memeImageView.image = meme.memedImage
        cell.memeLabel.text = meme.topText + "... " + meme.bottomText
        
        return cell
    }
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //If the triggered seque is the "ShowMemeDetail" segue
        if segue.identifier == Storyboard.showMemeDetailSegueId {
            // Figure out which row was selected
            if let row = tableView.indexPathForSelectedRow?.row {
                
                // Get the meme associated with this row and pass it along
                let meme = memes[row]
                let detailViewController = segue.destination as! MemeDetailViewController
                detailViewController.meme = meme
            }
        }
    }

}
