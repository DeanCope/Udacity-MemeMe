//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Dean Copeland on 3/23/17.
//  Copyright © 2017 Dean Copeland. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var meme = Meme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        imageView.image = meme.memedImage
    }


}
