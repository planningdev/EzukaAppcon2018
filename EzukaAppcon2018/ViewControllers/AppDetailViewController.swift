//
//  AppDetailViewController.swift
//  EzukaAppcon2018
//
//  Created by Atsushi KONISHI on 2018/11/06.
//  Copyright © 2018 小西篤志. All rights reserved.
//

import UIKit

class AppDetailViewController: UITableViewController {

    var app: ItemEntity? = nil
    var voteStatus: VoteStatusEntity? = nil
    var itemKind: AppModel.RequestItemKind = .app
    var token: String? = nil
    let appModel: AppModel = AppModel()
    let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    

    @IBOutlet weak var imageActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var squareImage: UIImageView!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var appImagesCollectionView: UICollectionView!
    @IBOutlet weak var appDescriptionLabel: UILabel!
    
    
    @IBOutlet weak var voteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        activityIndicatorSetup()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    func setup() {
        
        self.navigationItem.title = "詳細"
        
        voteButton.layer.cornerRadius = 12
        voteButton.clipsToBounds = true
        voteButton.addTarget(self, action: #selector(voteButtonTapped), for: .touchUpInside)
        
        self.tableView.delegate = self
        appImagesCollectionView.register(UINib(nibName: "AppImageCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        appImagesCollectionView.delegate = self
        appImagesCollectionView.dataSource = self
        
        guard let unwrappedApp = app else { return }
        self.appNameLabel.text = unwrappedApp.title
        self.teamNameLabel.text = unwrappedApp.teamName
        self.appDescriptionLabel.text = unwrappedApp.description
        imageActivityIndicator.startAnimating()
        
        squareImage.layer.cornerRadius = 24
        squareImage.clipsToBounds = true
        
        guard let squareImageURL = unwrappedApp.squareImage else { return }
        appModel.fetchImage(urlString: squareImageURL,
                            onSuccess: { [weak self] (image) in
                                DispatchQueue.main.async {
                                    self?.squareImage.image = image
                                    self?.imageActivityIndicator.stopAnimating()
                                    self?.imageActivityIndicator.isHidden = true
                                }

            },
                            onError: { [weak self] () in
                                DispatchQueue.main.async {
                                    self?.imageActivityIndicator.stopAnimating()
                                    self?.imageActivityIndicator.isHidden = true
                                }
        })
        

    }
    
    @objc func voteButtonTapped() {
        let alertController = UIAlertController(title: "本当に投票しますか？", message: "投票は元に戻せません", preferredStyle: .alert)
        let voteAction = UIAlertAction(title: "投票する", style: .default, handler: { _ in
            alertController.dismiss(animated: true, completion: nil)
            self.activityIndicator.startAnimating()
            guard let token = self.token, let app = self.app else { return }
            print("\(self.itemKind) in Detail")
            self.appModel.voteItem(token, targetId: app.id!, kind: self.itemKind,
                                   onSuccess: { [weak self] in
                                    DispatchQueue.main.async {
                                        self?.activityIndicator.stopAnimating()
                                        let completeAlertController = UIAlertController(title: "投票が完了しました", message: "ありがとうございました. 最初の画面に戻ります", preferredStyle: .alert)
                                        let backRootAction = UIAlertAction(title: "OK", style: .default, handler: {_ in
                                            completeAlertController.dismiss(animated: true, completion: nil)
                                            self?.navigationController?.popToRootViewController(animated: true)
                                        })
                                        completeAlertController.addAction(backRootAction)
                                        self?.present(completeAlertController, animated: true, completion: nil)
                                    }
                },
                                   onError: { [weak self] in
                                    DispatchQueue.main.async {
                                        self?.activityIndicator.stopAnimating()
                                        let completeAlertController = UIAlertController(title: "投票に失敗しました", message: "最初の画面に戻ります", preferredStyle: .alert)
                                        let backRootAction = UIAlertAction(title: "OK", style: .default, handler: {_ in
                                            completeAlertController.dismiss(animated: true, completion: nil)
                                            self?.navigationController?.popToRootViewController(animated: true)
                                        })
                                        completeAlertController.addAction(backRootAction)
                                        self?.present(completeAlertController, animated: true, completion: nil)
                                    }
            })

            
        })
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(voteAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func activityIndicatorSetup() {
        self.view.addSubview(activityIndicator)
        activityIndicator.color = .gray
        activityIndicator.hidesWhenStopped = true
//        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.item {
        case 0:
            return squareImage.frame.height + 24 * 2
        case 1:
            return 560
        case 4:
            return 96
        default:
            return UITableView.automaticDimension
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tableView {
            activityIndicator.frame = CGRect(x: scrollView.contentOffset.x, y: scrollView.contentOffset.y, width: activityIndicator.frame.width, height: activityIndicator.frame.height)
            
            print("scrolled")
        }
    }
    
    private func isActiveVote() {
        switch itemKind {
        case .app:
            guard let appStatus = voteStatus?.app else { return }
            if !appStatus {
                self.voteButton.isEnabled = false
                self.voteButton.alpha = 0.5
            }
        case .idea:
            guard let ideaStatus = voteStatus?.idea else { return }
            if !ideaStatus {
                self.voteButton.isEnabled = false
                self.voteButton.alpha = 0.5
            }
        }
    }
    
}

extension AppDetailViewController: UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return app?.Images.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! AppImageCollectionViewCell
        cell.activityIndicator.startAnimating()
        if let urlString = app?.Images[indexPath.item].imageURL {
            appModel.fetchImage(urlString: urlString,
                                onSuccess: { (image) in
                                    DispatchQueue.main.async {
                                        cell.appImageView.image = image
                                        cell.activityIndicator.stopAnimating()
                                    }

            },
                                onError: { () in
                                    DispatchQueue.main.async {
                                        cell.appImageView.image = UIImage(named: "EzukaAppconIcon")
                                        cell.activityIndicator.stopAnimating()
                                    }
            })
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 80, bottom: 8, right: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 40
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width * 0.8
        let height = collectionView.frame.height * 0.8
        return CGSize(width: width, height: height)
    }
}


