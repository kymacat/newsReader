//
//  NewsCell.swift
//  NewsReader
//
//  Created by Const. on 16.03.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell, ConfigurableView {
    

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var newsLabel: UILabel!
    
    var category: String!
    var fullText: String!
    var imageUrl: String?
    
    func configure(with model: NewsModel) {
        newsLabel.text = model.title
        category = model.category
        fullText = model.fullText
        imageUrl = model.imageUrl
                        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.init(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
        let date = dateFormatter.date(from: model.date)!
        
        dateFormatter.locale = Locale.init(identifier: "ru_RU")
        
        if Calendar.current.isDateInToday(date) {
            dateFormatter.dateFormat = "HH:mm"
        } else {
            dateFormatter.dateFormat = "dd MMM HH:mm"
        }
        
        timeLabel.text = dateFormatter.string(from: date)
    }
}
