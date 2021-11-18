//
//  ArticleManager.swift
//  idderezovskiyPW5
//
//  Created by Ilya Derezovskiy on 12.11.2021.
//

import Foundation

class ArticleManager {
    private static var articles = [ArticleModel]()
    
    public static func getArticles() -> [ArticleModel] {
        return ArticleManager.articles
    }
}
