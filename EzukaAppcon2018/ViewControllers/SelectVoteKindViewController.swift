//
//  SelectVoteKindViewController.swift
//  EzukaAppcon2018
//
//  Created by Atsushi KONISHI on 2018/11/08.
//  Copyright © 2018 小西篤志. All rights reserved.
//

import UIKit

class SelectVoteKindViewController: UIViewController {

    var voteStatus: VoteStatusEntity? = nil
    var token: String? = nil
    let appModel = AppModel()
    @IBOutlet weak var voteAppButton: UIButton!
    @IBOutlet weak var voteIdeaButton: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setup() {
        activityIndicator.isHidden = true
        voteAppButton.layer.cornerRadius = 8
        voteIdeaButton.layer.cornerRadius = 8
        guard let appStatus = voteStatus?.app, let ideaStatus = voteStatus?.idea else { return }
        print("app: \(appStatus)")
        print("ideaStatus: \(ideaStatus)")
        if !appStatus {
            voteAppButton.isEnabled = false
            voteAppButton.alpha = 0.8
        }
        if !ideaStatus {
            voteIdeaButton.isEnabled = false
            voteIdeaButton.alpha = 0.8
        }
        voteAppButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        voteIdeaButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

    }

    @objc func buttonTapped(_ sender: UIButton) {
        print(token ?? "nil")
        var voteKind: AppModel.RequestItemKind = .app
        if sender == voteAppButton {
            voteKind = .app
        } else if sender == voteIdeaButton {
            voteKind = .idea
        }
        
        guard let token = self.token else { return }
        startCommunicating()
        self.appModel.readItem(token, itemKind: voteKind,
                               onSuccess: { (apps) in
                                DispatchQueue.main.async {
                                    let storyboard = self.storyboard
                                    let listVC = storyboard!.instantiateViewController(withIdentifier: "ItemList") as! AppListViewController
                                    listVC.apps = apps
                                    listVC.token = token
                                    listVC.itemKind = voteKind
                                    self.stopCommunicating()
                                    self.navigationController?.pushViewController(listVC, animated: true)
                                }
        },
                               onError: { () in
                                self.stopCommunicating()
                                print("Error!")
                                // ダイアログの表示
        })
//        if sender == voteAppButton {
//
//        } else if sender == voteIdeaButton {
//
//        }
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
