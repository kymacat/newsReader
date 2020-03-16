//
//  TableViewController.swift
//  NewsReader
//
//  Created by Const. on 12.03.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, XMLParserDelegate {
    
    var parser = XMLParser()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        parser = XMLParser(contentsOf:(NSURL(string:"http://www.vesti.ru/vesti.rss")! as URL))!
        parser.delegate = self
        parser.parse()
        
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = titles[indexPath.row]

        return cell
    }
    
    // MARK: - XMLParser Delegate
    
    var currElement: String?
    var currTitle: String?
    var titles: [String] = []
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {

        currElement = elementName
        
        if elementName == "item" {
            currTitle = String()
        }
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item" {
            if let title = currTitle {
                titles.append(title)
                
            }
            currTitle = nil
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if currTitle != nil {
            
            if currElement == "title" {
                currTitle! += data
            }
        }
        
    }

}
