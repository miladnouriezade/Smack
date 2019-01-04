//
//  AddChannel.swift
//  Smack
//
//  Created by Milad Nourizade on 1/2/19.
//  Copyright © 2019 Milad Nourizade. All rights reserved.
//

import UIKit

class AddChannelVC: UIViewController {
    
    //Outlets
    
    @IBOutlet weak var channelName: UITextField!
    @IBOutlet weak var channelDesc: UITextField!
    @IBOutlet weak var bgView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()

    }
    
    func setupView() {
        
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector (closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
        
        channelName.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedStringKey.foregroundColor :placeholderColor])
        channelDesc.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedStringKey.foregroundColor : placeholderColor])
    }
    
    @IBAction func createChannel(_ sender: Any) {
        guard let title = channelName.text, channelName.text != "" else { return }
        guard let desc = channelDesc.text else { return }
        
        SocketService.instance.addChannel(channelDescription: desc, channelName: title) { (success) in
            if success {
                SocketService.instance.getChannel(completion: { (success) in
                    if success {
                         self.dismiss(animated: true, completion: nil)
                    }
                })
            }
        }
    }
    
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func closeTap(_ recognizer : UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    

}
