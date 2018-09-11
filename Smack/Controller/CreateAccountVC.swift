//
//  CreateAccountVC.swift
//  Smack
//
//  Created by Milad Nourizade on 9/11/18.
//  Copyright © 2018 Milad Nourizade. All rights reserved.
//

import UIKit

class CreateAccountVC: UIViewController {
    //Outlets
    @IBOutlet weak  var createAccountBtn:UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        createAccountBtn.layer.cornerRadius = 5

    }
    @IBAction func closeBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: Identifier.UNWIND, sender: nil)
    }
    
}
