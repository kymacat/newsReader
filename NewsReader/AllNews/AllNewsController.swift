//
//  TableViewController.swift
//  NewsReader
//
//  Created by Const. on 12.03.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit

class AllNewsController: UITableViewController {
    
    fileprivate let reuseIdentifier = String(describing: NewsCell.self)
    
    // MARK: - Data
    private var currElement: String?
    private var currNews: NewsModel?
    
    var news: [NewsModel] = []
    var updatedNews: [NewsModel] = []
    var newsForCategory: [NewsModel] = []
    
    
    private var categoryFlag = false
    private var currCategory = String()
    private var categories = Set<String>()
    
    var parser = XMLParser()
    private var parseOperation: Parser?
    
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIBarButtonItem(title: "Категории", style: .done, target: self, action: #selector(showCategories(sender:)))
        button.tintColor = .black
        
        navigationItem.rightBarButtonItem = button
        navigationItem.title = "Новости"
        
        tableView.refreshControl = myRefreshControl
        tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60

        myRefreshControl.beginRefreshing()
        parseOperation = Parser(self)
        if let operation = parseOperation {
            operation.parse()
        }
        
    }
    
    // MARK: - Frontend
    
    @objc func showCategories(sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        for category in categories {
            let categoryAction = UIAlertAction(title: category, style: .default) { [weak self] (action: UIAlertAction) in
                if let VC = self {
                    VC.categoryFlag = true
                    VC.currCategory = category
                    VC.updateDataForCategory()
                    VC.tableView.reloadData()
                    VC.navigationItem.rightBarButtonItem?.title = category
                }
            }
            alert.addAction(categoryAction)
        }
        
        let action = UIAlertAction(title: "Все", style: .default) { [weak self] (action: UIAlertAction) in
            self?.categoryFlag = false
            self?.tableView.reloadData()
            self?.navigationItem.rightBarButtonItem?.title = "Категории"
            
        }
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        if let operation = parseOperation {
            operation.parse()
        }
    }
    
    func updateDataForCategory() {
        newsForCategory.removeAll()
        for news in self.news {
            if news.category == currCategory {
                newsForCategory.append(news)
            }
        }
    }
}


// MARK: - Table view data source
extension AllNewsController {
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !categoryFlag {
            return news.count
        } else {
            return newsForCategory.count
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? NewsCell else { return UITableViewCell() }

        if !categoryFlag {
            cell.configure(with: news[indexPath.row])
        } else {
            cell.configure(with: newsForCategory[indexPath.row])
        }
        

        return cell
    }
    
    // MARK: - Navigation
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? NewsCell,
            let title = cell.newsLabel.text else { return }
        
        let viewController = NewsViewController(newsTitle: title, fullText: cell.fullText, imageUrl: cell.imageUrl)
        viewController.view.backgroundColor = .white
        navigationController?.pushViewController(viewController, animated: true)
    }
    
}
    

// MARK: - XMLParser Delegate
    
extension AllNewsController : XMLParserDelegate {
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        currElement = elementName
        
        if elementName == "item" {
            currNews = NewsModel(title: "", date: "", category: "", fullText: "")
        }
        
        if elementName == "enclosure" {
            currNews?.imageUrl = attributeDict["url"]
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item" {
            if let news = currNews {
                self.updatedNews.append(news)
                self.categories.insert(news.category)
            }
            currNews = nil
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if currNews != nil {
            
            
            if currElement == "title" {
                currNews?.title += data
            }
            if currElement == "pubDate" {
                currNews?.date += data
            }
            if currElement == "category" {
                currNews?.category += data
            }
            
            if currElement == "yandex:full-text" {
                currNews?.fullText += data
            }
            
        }
        
    }

}
