//
//  NewsListPresenter.swift
//  NewsApp
//
//  Created by 박경춘 on 2023/03/31.
//

import UIKit

protocol NewsListProtocol: AnyObject {
    func setupNavigationBar()
    func setupLayout()
    func endRefreshing()
    func moveToNewsWebViewController(with news: News)
    func reloadTableView()
}

final class NewsListPresenter: NSObject {
    
    private weak var viewController: NewsListProtocol?
    private let newsSearchManager: NewsSearchManagerProtocol
    
    private var currentKeyword = "아이폰"
    private var currentPage: Int = 0
    
    private let display: Int = 20
    
    private var newsList: [News] = []
    
    init(viewController: NewsListProtocol, newsSearchManager: NewsSearchManagerProtocol = NewsSearchManager()) {
        self.viewController = viewController
        self.newsSearchManager = newsSearchManager
    }
    
    func viewDidLoad() {
        viewController?.setupNavigationBar()
        viewController?.setupLayout()
        requestNewsList(isNeededToReset: false)
    }
    
    func didCalledRefresh() {
        requestNewsList(isNeededToReset: true)
        //viewController?.endRefreshing()
    }
    
}

extension NewsListPresenter: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let news = newsList[indexPath.row]
        viewController?.moveToNewsWebViewController(with: news)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let currentROw = indexPath.row
        
        guard (currentROw % 20) == display - 3 && (currentROw / display) == (currentROw - 1) else {
            return
        }
        
        requestNewsList(isNeededToReset: false)
    }
    
}

extension NewsListPresenter: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        newsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsListTableViewCell.indentifier, for: indexPath) as? NewsListTableViewCell
        
        let news = newsList[indexPath.row]
        cell?.setup(news: news)
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(
            withIdentifier: NewsListTableViewHeaderView.identifier
        ) as? NewsListTableViewHeaderView
        header?.setup()

        return header
    }
}

private extension NewsListPresenter {
    
    func requestNewsList(isNeededToReset: Bool) {
        
        if isNeededToReset {
            currentPage = 0
            newsList = []
        }
        
        newsSearchManager.request(
            from: currentKeyword,
            start: (currentPage * display) + 1,
            display: display) { [weak self] newValue in
                //self?.newsList = newValue
                self?.newsList += newValue
                self?.currentPage += 1
                self?.viewController?.reloadTableView()
                self?.viewController?.endRefreshing()
            }
    }
}
