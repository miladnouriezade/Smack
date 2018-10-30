//
//  RoundedCorner.swift
//  Smack
//
//  Created by Milad Nourizade on 10/20/18.
//  Copyright © 2018 Milad Nourizade. All rights reserved.
//

import UIKit
@IBDesignable
class RoundedCorner: UIImageView {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
    override func prepareForInterfaceBuilder() {
        setupView()
    }


}
