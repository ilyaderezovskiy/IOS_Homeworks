//
//  ViewController.swift
//  idderezovskiyPW5
//
//  Created by Ilya Derezovskiy on 10.11.2021.
//

import UIKit
import SafariServices
import MessageUI

class ArticleViewController: UIViewController, UISearchBarDelegate {

    let tableView = UITableView.init(frame: .zero, style: UITableView.Style.grouped)
    
    private var viewModels = [NewsTableViewCellViewModel]()
    private var articles = ArticleManager.getArticles() //[ArticleModel]()
    private let searchVC = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "News"
        self.navigationController?.navigationBar.prefersLargeTitles = true

        self.view.addSubview(self.tableView)
        self.tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.updateLayout(with: self.view.frame.size)
        
        fetchTopStories()
        createSearchBar()
    }
    private func createSearchBar() {
        navigationItem.searchController = searchVC
        searchVC.searchBar.delegate = self
    }
    private func fetchTopStories() {
        APICaller.shared.getTopStories { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap( {
                    NewsTableViewCellViewModel(title: $0.title ?? "No title", description: $0.description ?? "No description", imageURL: URL(string: $0.urlToImage ?? ""))
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    private func updateLayout(with size: CGSize) {
       self.tableView.frame = CGRect.init(origin: .zero, size: size)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text, !text.isEmpty else {
            return
        }
        
        APICaller.shared.search(with: text) { [weak self] result in
            switch result {
            case .success(let articles):
                self?.articles = articles
                self?.viewModels = articles.compactMap( {
                    NewsTableViewCellViewModel(title: $0.title ?? "No title", description: $0.description ?? "No description", imageURL: URL(string: $0.urlToImage ?? ""))
                })
                
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
}

class TableViewCell: UITableViewCell {

    override func prepareForReuse() {
        super.prepareForReuse()
        self.accessoryType = .none
    }
}
extension ArticleViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModels[indexPath.row])
        cell.prepareForReuse()
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let shareAction = UITableViewRowAction(style: .destructive, title: "Share") { [self] action, indexPath in
            guard let e = URL(string: "https://vk.com/grizverg") else {
                return
            }
            let vc = SFSafariViewController(url: e)
            UIPasteboard.general.string = self.articles[indexPath.row].url
            present(vc, animated: true)
        }
        return [shareAction]
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        
        guard let url = URL(string: article.url ?? "") else {
            return
        }
        
        let webView = SFSafariViewController(url: url)
        present(webView, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}

extension ArticleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
}


