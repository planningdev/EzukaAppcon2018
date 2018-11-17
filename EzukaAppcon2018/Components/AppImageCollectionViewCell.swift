//
//  AppImageCollectionViewCell.swift
//  EzukaAppcon2018
//
//  Created by Atsushi KONISHI on 2018/11/04.
//  Copyright © 2018 小西篤志. All rights reserved.
//

import UIKit

class AppImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var appImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.layer.cornerRadius = 8
        self.contentView.layer.borderColor = UIColor.lightGray.cgColor
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.masksToBounds = true
        activityIndicator.isHidden = true
    }
    
    func setup() {
        appImageView.image = UIImage(named: "EzukaAppconLogo")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.appImageView.image = nil
    }

}
