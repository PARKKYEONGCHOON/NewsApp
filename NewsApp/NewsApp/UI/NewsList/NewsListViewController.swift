//
//  ViewController.swift
//  NewsApp
//
//  Created by 박경춘 on 2023/03/31.
//

import SnapKit
import UIKit

final class NewsListViewController: UIViewController {
    
    private lazy var presenter = NewsListPresenter(viewController: self)
    
    private lazy var refreshControl: UIRefreshControl = {
       let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(didCalledRefresh), for: .valueChanged)
        
        return refreshControl
    }()
    
    private lazy var tableView: UITableView = {
      let tableView = UITableView()
        tableView.delegate = presenter
        tableView.dataSource = presenter
        
        tableView.register(NewsListTableViewCell.self, forCellReuseIdentifier: NewsListTableViewCell.indentifier)
        tableView.register(NewsListTableViewHeaderView.self, forHeaderFooterViewReuseIdentifier: NewsListTableViewHeaderView.identifier)
        
        tableView.refreshControl = refreshControl
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        
        NewsSearchManager()
            .request(from: "아이폰", start: 1, display: 20) { newArray in
                print(newArray)
            }
    }

}

extension NewsListViewController: NewsListProtocol {
    
    
    func setupNavigationBar() {
        navigationItem.title = "NEWS"
        navigationController?.navigationBar
            .prefersLargeTitles = true
    }
    
    func setupLayout() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    func endRefreshing() {
        refreshControl.endRefreshing()
    }
    
    func moveToNewsWebViewController(with news: News) {
        
        let newWebViewController = NewsWebViewController(news: news)
        
        navigationController?.pushViewController(newWebViewController, animated: true)
        
    }
    
    func reloadTableView() {
        
        tableView.reloadData()
        
    }
}


private extension NewsListViewController {
    
    @objc func didCalledRefresh() {
        presenter.didCalledRefresh()
    }
}
