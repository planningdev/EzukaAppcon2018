//
//  AppListViewController.swift
//  EzukaAppcon2018
//
//  Created by Atsushi KONISHI on 2018/11/04.
//  Copyright © 2018 小西篤志. All rights reserved.
//

import UIKit

class AppListViewController: UIViewController {

    @IBOutlet weak var appCollection: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    func setup() {
        appCollection.delegate = self
        appCollection.dataSource = self
        
        appCollection.register(UINib(nibName: "AppCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AppCell")
        self.navigationItem.title = "リスト"
    }
}


extension AppListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppCell", for: indexPath) as! AppCollectionViewCell
        cell.setup()
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // collectionViewの上下左右のマージンを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
    }
    
    // セルの大きさを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let edge = (collectionView.frame.width - 16 * 3) / 2
        return CGSize(width: edge, height: edge)
    }
    // セル間のマージンを設定(横)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    // セル間のマージンを設定(縦)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "ToDetail", sender: self)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
