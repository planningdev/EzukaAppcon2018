//
//  AppCollectionViewCell.swift
//  EzukaAppcon2018
//
//  Created by Atsushi KONISHI on 2018/11/04.
//  Copyright © 2018 小西篤志. All rights reserved.
//

import UIKit

class AppCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var appImage: UIImageView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var teamNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setup() {
        appImage.image = UIImage(named: "EzukaAppconLogo")
        appNameLabel.text = "testApp"
        teamNameLabel.text = "testTeam"
    }

}
