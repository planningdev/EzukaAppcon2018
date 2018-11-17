//
//  Router.swift
//  EzukaAppcon2018
//
//  Created by Atsushi KONISHI on 2018/11/06.
//  Copyright © 2018 小西篤志. All rights reserved.
//

import Foundation

enum Router {
    case readApps
    case readIdeas
    case voteApp(id: Int)
    case voteIdea(id: Int)
    case fetchVoteStatus(token: String)
    case fetchAppImage(imagePath: String)
    
    static let baseURL = "https://staging.voteapp2018.planningdev.com"
    static let sufix = "/api/v1"
    
    var method: String {
        switch self {
        case .readApps:
            return "GET"
        case .voteApp:
            return "POST"
        case .voteIdea:
            return "POST"
        case .fetchVoteStatus:
            return "GET"
        case .fetchAppImage:
            return "GET"
        case .readIdeas:
            return "GET"
        }
    }
    
    var path: String {
        switch self {
        case .readApps:
            return "/apps"
        case .voteApp(let id):
            return "/apps/\(id.description)/vote"
        case .voteIdea(let id):
            return "/idea/\(id.description)/vote"
        case .fetchVoteStatus(let token):
            return "/vote_tokens/\(token)"
        case .fetchAppImage(let imagePath):
            return imagePath
        case .readIdeas:
            return "/ideas"
        }
    }
    
    func makeURLRequest(_ token: String) -> URLRequest? {
        guard let url = URL(string: Router.baseURL + Router.sufix) else { return nil }
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue(token, forHTTPHeaderField: "X-Vote-Token")
//        switch self {
//        case .readApps:
//            urlRequest.addValue(qrToken, forHTTPHeaderField: "X-Vote-Token")
//            break
//        case .voteApp:
//            urlRequest.addValue(qrToken, forHTTPHeaderField: "X-Vote-Token")
//            break
//        case .voteIdea:
//            urlRequest.addValue(qrToken, forHTTPHeaderField: "X-Vote-Token")
//            break
//        case .fetchVoteStatus(let token):
//            urlRequest.addValue(token, forHTTPHeaderField: "X-Vote-Token")
//        }
        return urlRequest
    }
}
