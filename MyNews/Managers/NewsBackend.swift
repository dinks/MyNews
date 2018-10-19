//
//  NewsBackend.swift
//  MyNews
//
//  Created by Dinesh V on 18.10.18.
//  Copyright © 2018 Dinesh. All rights reserved.
//

import Foundation
import Alamofire

private let apiKey = "654f479b4cb34f4ea18db7eda6437ec2"

class NewsBackend {
    static let instance = NewsBackend()
    
    let manager: SessionManager
    
    init() {
        let memoryCapacity = 100 * 1024 * 1024; // 100 MB
        let diskCapacity = 100 * 1024 * 1024; // 100 MB
        let cache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "shared_cache")
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.urlCache = cache
        
        manager = Alamofire.SessionManager(configuration: configuration)
    }
    
    lazy var url = {
        return URL(string: "https://newsapi.org/v2/")!
    }
    
    func getTopHeadlineFor(source: String, completionHandler: @escaping (Any?,Error?) -> Void) {
        requestJSON(path: "top-headlines", parameters: ["sortBy": "publishedAt", "sources": source], completionHandler: completionHandler)
    }
    
    func requestJSON(path: String, parameters:[String:Any]?, completionHandler: @escaping (Any?,Error?) -> Void) {
        let requestURL = url().appendingPathComponent(path)
        requestJSON(url: requestURL, parameters: parameters, completionHandler: completionHandler)
    }
    
    func requestJSON(url: URL, parameters: [String:Any]?, completionHandler: @escaping (Any?, Error?) -> Void) {
        var requestParams = parameters ?? Dictionary<String,Any>()
        
        requestParams["apiKey"] = apiKey
        
        manager.request(url, method: .get, parameters: requestParams).responseJSON {
            response in
            completionHandler(response.result.value,response.result.error)
        }
    }
}
