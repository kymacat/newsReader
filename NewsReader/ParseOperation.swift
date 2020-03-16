//
//  Operations.swift
//  NewsReader
//
//  Created by Const. on 16.03.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import Foundation

private class ParseOperation : Operation {
    
    private var parserController: AllNewsController
    
    
    init(_ parserController: AllNewsController) {
        self.parserController = parserController
    }
    
    override func main() {
        parserController.parser = XMLParser(contentsOf:(NSURL(string:"http://www.vesti.ru/vesti.rss")! as URL))!
        parserController.parser.delegate = parserController
        parserController.parser.parse()
    }
}

class Parser {
    private var isFinished = true
    private let operationQueue = OperationQueue()
    private let parserController: AllNewsController
    
    init(_ parserController: AllNewsController) {
        self.parserController = parserController
    }
    
    func parse() {
        if isFinished {
            parserController.updatedNews.removeAll()
            isFinished = false
            let operation = ParseOperation(parserController)
            operation.completionBlock = {
                DispatchQueue.main.async { [weak self] in
                    if let newData = self?.parserController.updatedNews {
                        self?.parserController.news = newData
                    }
                    self?.parserController.tableView.reloadData()
                    self?.parserController.tableView.refreshControl?.endRefreshing()
                    self?.isFinished = true
                }
            }
            
            operationQueue.addOperation(operation)
        }
    }
}
