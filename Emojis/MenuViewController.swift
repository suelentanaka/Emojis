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
    
    @IBAction func moviesACT(_ sender: Any) {
       quiz="movies"
    }
    @IBAction func tvShowACT(_ sender: Any) {
        quiz="tv"
    }
    @IBAction func brandsACT(_ sender: Any) {
        quiz="brands"
    }
    
    public var quiz:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoIMG.loadGif(name: "logoGIF")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is MoviesViewController {
            let vc = segue.destination as? MoviesViewController
            vc?.quiz = quiz
        }
    }

}

