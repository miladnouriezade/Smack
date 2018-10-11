//
//  AvatarPickerVC.swift
//  Smack
//
//  Created by Milad Nourizade on 10/11/18.
//  Copyright © 2018 Milad Nourizade. All rights reserved.
//

import UIKit

class AvatarPickerVC: UIViewController {
    //Outlets
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //Variables
    var avatarType:AvatarType = AvatarType.dark
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            avatarType = .dark
        }else {
            avatarType = .light
        }
        collectionView.reloadData()
    }
    
    
}

extension AvatarPickerVC:UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if avatarType == .dark {
            let selectedAvatarName = "dark\(indexPath.item)"
            UserDataService.instance.setAvatarName(selectedAvatarName)
        }else {
            let selectedAvatarName = "light\(indexPath.item)"
            UserDataService.instance.setAvatarName(selectedAvatarName)
        }
        dismiss(animated: true, completion: nil)
    }
    
}


extension AvatarPickerVC:UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as? AvatarCell {
            cell.configureCell(index: indexPath.item, type: avatarType)
            return cell
        }
        return AvatarCell()
    }
    
}


extension AvatarPickerVC:UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var numberOfColumns:CGFloat = 3
        if UIScreen.main.bounds.width > 320 {
            numberOfColumns = 4
        }
        let cellSpace:CGFloat = 10
        let padding:CGFloat = 40
        let cellDimension = ((collectionView.bounds.width - padding) - (numberOfColumns - 1) * cellSpace) / numberOfColumns
        
        return CGSize(width: cellDimension, height: cellDimension)
    }
    
    
}
