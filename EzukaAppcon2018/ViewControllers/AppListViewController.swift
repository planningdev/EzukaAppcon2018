//
//  AppListViewController.swift
//  EzukaAppcon2018
//
//  Created by Atsushi KONISHI on 2018/11/04.
//  Copyright © 2018 小西篤志. All rights reserved.
//

import UIKit

class AppListViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var appCollection: UICollectionView!
    
    var apps: [ItemEntity] = []
    var token: String? = nil
    var itemKind: AppModel.RequestItemKind = .app
    
    let appModel = AppModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
        
        activityIndicator.isHidden = true
    }
    
    private func startCommunicating() {
        self.view.isUserInteractionEnabled = false
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
    }
    
    private func stopCommunicating() {
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
        self.view.isUserInteractionEnabled = true
    }
}

extension AppListViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return apps.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AppCell", for: indexPath) as! AppCollectionViewCell
        let app = apps[indexPath.item]
        guard let title = app.title, let teamName = app.teamName else {
            cell.setup(appName: "App Name", teamName: "team Name")
            return cell
        }
        cell.setup(appName: title, teamName: teamName)
        if let urlString = apps[indexPath.item].squareImage {
            cell.activityIndicator.startAnimating()
            appModel.fetchImage(urlString: urlString,
                                onSuccess: { (image) in
                                    DispatchQueue.main.async {
                                        cell.activityIndicator.stopAnimating()
                                        cell.appImage.image = image
                                    }
                },
                                onError: { () in
                                    DispatchQueue.main.async {
                                        cell.activityIndicator.stopAnimating()
                                        cell.appImage.image = UIImage(named: "EzukaAppconIcon")
                                    }
            })
        }
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
        let width = collectionView.frame.width - 16*2
        let height = CGFloat(240)
//        let edge = (collectionView.frame.width - 16 * 3) / 2
        return CGSize(width: width, height: height)
    }
    // セル間のマージンを設定(横)
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 16
//    }
    // セル間のマージンを設定(縦)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailVC = storyboard!.instantiateViewController(withIdentifier: "ItemDetail") as! AppDetailViewController
        detailVC.app = self.apps[indexPath.item]
//        detailVC.voteStatus = status
        detailVC.token = self.token
        detailVC.itemKind = self.itemKind
        self.navigationController?.pushViewController(detailVC, animated: true)
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
