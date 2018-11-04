//
//  DetailViewController.swift
//  EzukaAppcon2018
//
//  Created by Atsushi KONISHI on 2018/11/04.
//  Copyright © 2018 小西篤志. All rights reserved.
//

import UIKit
import QRCodeReader

class DetailViewController: UIViewController {

    @IBOutlet weak var scrollview: UIScrollView!
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var teamNameLabel: UILabel!
    
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
}
