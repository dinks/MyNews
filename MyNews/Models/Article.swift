//
//  Article.swift
//  MyNews
//
//  Created by Dinesh V on 18.10.18.
//  Copyright © 2018 Dinesh. All rights reserved.
//

import Foundation

class Article {
    var source: String?
    
    var author: String?
    var title: String?
    var description: String?
    var url: String?
    var urlToImage: String?
    var publishedAt: Date?
    var content: String?
    
    init(json: [String:AnyObject], source: String) {
        updateWith(json, source: source)
    }
    
    func updateWith(_ json: [String:AnyObject], source: String) {
        self.source = source
        
        author = json["author"] as? String
        title = json["title"] as? String
        description = json["description"] as? String
        url = json["url"] as? String
        urlToImage = json["urlToImage"] as? String
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        publishedAt = formatter.date(from: (json["publishedAt"] as? String)!)
        content = json["content"] as? String
    }
    
    static func parseJsonArray(_ jsonArray: [[String: AnyObject]], source: String) -> [Article] {
        var result = Array<Article>()
        for articleJson in jsonArray {
            result.append(Article.init(json: articleJson, source: source))
        }
        
        return result
    }
    
    static func getArticlesFor(_ source: String, completionHandler: @escaping ([Article]?, Error?) -> Void) {
        NewsBackend.instance.getTopHeadlineFor(source: source) { (jsonObject, error) in
            guard error == nil else {
                completionHandler(nil, error)
                return
            }
            
            if let resultDict = jsonObject as? [String: AnyObject],
                let articles = resultDict["articles"] as? [[String: AnyObject]] {
                DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive).async(execute: {
                    let articleArray = Article.parseJsonArray(articles, source: source)
                    
                    DispatchQueue.main.async(execute: {
                        completionHandler(articleArray, nil)
                    })
                })
            } else {
                completionHandler(nil, nil)
            }
        }
    }
}
