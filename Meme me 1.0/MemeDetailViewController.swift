//
//  MemeDetailViewController.swift
//  Meme me 1.0
//
//  Created by Anthony Lee on 6/5/18.
//  Copyright © 2018 Udacity. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var meme: Meme?
    
    @IBOutlet weak var detailImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailImageView.image = meme?.memedImage
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
