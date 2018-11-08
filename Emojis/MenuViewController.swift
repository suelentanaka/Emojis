//
//  ViewController.swift
//  Emojis
//
//  Created by Suelen Tanaka on 2018-10-14.
//  Copyright © 2018 Suelen Tanaka. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet weak var logoIMG: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoIMG.loadGif(name: "logoGIF")
    }

}

