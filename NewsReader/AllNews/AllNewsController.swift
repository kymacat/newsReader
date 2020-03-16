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
    var currElement: String?
    var currNews: NewsCellModel?
    
    var news: [NewsCellModel] = []
    var updatedNews: [NewsCellModel] = []
    
    var parser = XMLParser()
    var parseOperation: Parser?
    
    let myRefreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Обновление")
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

        
        parseOperation = Parser(self)
        if let operation = parseOperation {
            operation.parse()
        }
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? NewsCell else { return UITableViewCell() }

        cell.configure(with: news[indexPath.row])

        return cell
    }
    
    // MARK: - Frontend
    
    @objc func showCategories(sender: UIButton) {
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        if let operation = parseOperation {
            operation.parse()
        }
    }
}
    

// MARK: - XMLParser Delegate
    
extension AllNewsController : XMLParserDelegate {
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        currElement = elementName
        
        if elementName == "item" {
            currNews = NewsCellModel(title: "", date: "")
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item" {
            if let news = currNews {
                self.updatedNews.append(news)
            }
            currNews = nil
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if currNews != nil {
            
            if currElement == "title" {
                currNews!.title += data
            }
            if currElement == "pubDate" {
                currNews!.date += data
            }
        }
        
    }

}
