//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Dean Copeland on 3/23/17.
//  Copyright © 2017 Dean Copeland. All rights reserved.
//

import UIKit

private let reuseIdentifier = "MemeCollectionViewCell"

class SentMemesCollectionViewController: UICollectionViewController {
    
    var memes: [Meme] {
        get {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.memes
        }
    }
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space: CGFloat = 3.0
        let widthDimension = (self.view.frame.size.width - (2 * space)) / 3.0
        let heightDimension = (self.view.frame.size.height - (2 * space)) / 3.0

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: widthDimension, height: heightDimension)
        
        /*
         // For testing...
        if memes.count == 0 {
            let image1 = UIImage(named: "LaunchImage")
            let meme1 = Meme(topText: "THIS IS THE TOP",
                             bottomText: "THE BOTTOM",
                             originalImage: image1!, memedImage: image1!)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.memes.append(meme1)
            appDelegate.memes.append(meme1)
            appDelegate.memes.append(meme1)
            appDelegate.memes.append(meme1)
            appDelegate.memes.append(meme1)
            appDelegate.memes.append(meme1)
            appDelegate.memes.append(meme1)
            appDelegate.memes.append(meme1)
            appDelegate.memes.append(meme1)
            appDelegate.memes.append(meme1)
        }
 */
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView?.reloadData()
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //If the triggered seque is the "ShowMemeDetail" segue
        if segue.identifier == "ShowMemeDetail" {
            // Figure out which row was just tapped
            
            if let path = self.collectionView?.indexPathsForSelectedItems?.first {
                
                // Get the item associated with this row and pass it along
                // let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let meme = memes[path.row]
                let detailViewController = segue.destination as! MemeDetailViewController
                detailViewController.meme = meme
            }
        }

    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // Return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Return the number of items
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SentMemeCollectionViewCell
    
        let meme = memes[indexPath.row]
        
        cell.memeImageView?.image = meme.memedImage
    
        return cell
    }

}
