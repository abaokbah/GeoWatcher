//
//  PopupViewController.swift
//  Places
//
//  Created by Sultan Khan on 4/29/17.
//  Copyright © 2017 Razeware LLC. All rights reserved.
//

import UIKit

class PopupViewController: UIViewController {
  var message = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."
  var imageName = ""
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textView: UITextView!
    @IBAction func favButton(_ sender: UIButton) {
      if sender.title(for: .normal) == "☆" {
        sender.setTitle("★", for: .normal)
      } else {
        sender.setTitle("☆", for: .normal)
      }
    }
    @IBAction func dissmissButton(_ sender: UIButton) {
      self.dismiss(animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
textView.text = message
      imageView.image = UIImage.init(named: imageName)
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
