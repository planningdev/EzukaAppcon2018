//
//  AppModel.swift
//  EzukaAppcon2018
//
//  Created by Atsushi KONISHI on 2018/11/06.
//  Copyright © 2018 小西篤志. All rights reserved.
//

import Foundation
import UIKit.UIImage

class AppModel: NSObject {
    
    enum RequestItemKind {
        case app
        case idea
    }
    
    func readItem(_ token: String, itemKind: RequestItemKind, onSuccess: @escaping ([ItemEntity]) -> Void, onError: @escaping () -> Void) {
        let request: URLRequest?
        switch itemKind {
        case .app:
            request = Router.readApps.makeURLRequest(token)
        case .idea:
            request = Router.readIdeas.makeURLRequest(token)
        }
        guard let unwrappedRequest = request else { return }
        let task = URLSession.shared.dataTask(with: unwrappedRequest) { (data, res, err) in
            if (err != nil) {
                print("err")
                onError()
            } else {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:Any]
                    
                    let results: [[String:Any]]
                    switch itemKind {
                    case .app:
                        results = json["apps"] as! [[String:Any]]
                    case .idea:
                        results = json["ideas"] as! [[String:Any]]
                    }
//                    let results = json["apps"] as! [[String:Any]]
                    let apps: [ItemEntity] = results.map{ result -> ItemEntity in
                        let appData = try! JSONSerialization.data(withJSONObject: result, options: [])
                        return try! JSONDecoder().decode(ItemEntity.self, from: appData)
                    }
                    print(apps)
                    onSuccess(apps)
                } catch let e {
                    print(e)
                    onError()
                }
                print("success")
            }
        }
        task.resume()
    }
    
    func voteItem(_ token: String, targetId: Int, kind: RequestItemKind, onSuccess: @escaping () -> Void, onError: @escaping () -> Void) {
        var request: URLRequest? = nil
        switch kind {
        case .app:
            request = Router.voteApp(id: targetId).makeURLRequest(token)
        case .idea:
            request = Router.voteIdea(id: targetId).makeURLRequest(token)
        }
        guard let unwrappedRequest = request else { onError(); return }
        let task = URLSession.shared.dataTask(with: unwrappedRequest) { (data, res, err) in
            if err != nil {
                // 投票失敗
                onError()
            } else {
                // 投票成功
                onSuccess()
            }
        }
        task.resume()
    }
    
    
    func getVoteStatus(_ token: String, onSuccess: @escaping (VoteStatusEntity) -> Void, onError: @escaping () -> Void) {
        guard let request = Router.fetchVoteStatus(token: token).makeURLRequest(token) else { return }
        let task = URLSession.shared.dataTask(with: request) { (data, res, err) in
            if err != nil {
                onError()
            } else {
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String:Any]
                    let statusData = try JSONSerialization.data(withJSONObject: json["votable"]!, options: [])
                    let voteStatus = try JSONDecoder().decode(VoteStatusEntity.self, from: statusData)
                    print(voteStatus)
                    onSuccess(voteStatus)
                } catch let e {
                    print(e)
                    onError()
                }
            }
        }
        task.resume()
    }
    
    func fetchImage(urlString: String, onSuccess: @escaping (UIImage?) -> Void, onError: @escaping () -> Void) {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { (data, res, err) in
            if err != nil {
                onError()
            } else {
                if let unwrappedData = data {
                    onSuccess(UIImage(data: unwrappedData))
                } else {
                    onError()
                }
            }
        }
        task.resume()
    }
}
