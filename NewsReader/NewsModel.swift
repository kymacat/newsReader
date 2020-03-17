//
//  Models.swift
//  NewsReader
//
//  Created by Const. on 16.03.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import Foundation

protocol ConfigurableView {
    associatedtype ConfigurationModel
    
    func configure(with model: ConfigurationModel)
}

struct NewsModel {
    var title: String
    var date: String
    var category: String
    var imageUrl: String?
    var fullText: String
}
