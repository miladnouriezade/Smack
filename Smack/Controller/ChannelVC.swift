//
//  ChannelVC.swift
//  Smack
//
//  Created by Milad Nourizade on 8/25/18.
//  Copyright © 2018 Milad Nourizade. All rights reserved.
//

import UIKit

class ChannelVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController().rearViewRevealWidth = self.view.frame.size.width - 60
    }

   

}
