//
//  NewsViewController.swift
//  NewsReader
//
//  Created by Const. on 17.03.2020.
//  Copyright © 2020 Oleginc. All rights reserved.
//

import UIKit

class NewsViewController: UIViewController {

    weak var scrollView: UIScrollView!
    weak var newsImage: UIImageView?
    weak var activityIndicator: UIActivityIndicatorView?
    weak var titleLabel: UILabel!
    weak var fullTextLabel: UILabel!
    
    
    var newsTitle: String
    var fullText: String
    var imageUrl: String?
    
    
    // MARK: - Life cycle
    
    init(newsTitle: String, fullText: String, imageUrl: String?) {
        self.newsTitle = newsTitle
        self.fullText = fullText
        self.imageUrl = imageUrl
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillView()
    }
    
    // MARK: - fill View
    
    
    private func fillView() {
        // MARK: Scroll View
        
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scrollView = scroll
        
        
        view.addSubview(scrollView)
        
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // MARK: News Image
        
        if let url = imageUrl {

            let imageView = UIImageView()
            imageView.contentMode = .scaleToFill
            imageView.backgroundColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 15
            
            newsImage = imageView
            
            scrollView.addSubview(newsImage!)

            newsImage?.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                newsImage!.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
                newsImage!.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
               newsImage!.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
               newsImage!.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9),
               newsImage!.heightAnchor.constraint(equalTo: newsImage!.widthAnchor, multiplier: 0.5)
            ])
            
            
            // MARK: IndicatorView
            
            let indicator = UIActivityIndicatorView()
            indicator.hidesWhenStopped = true
            indicator.color = .black
            indicator.style = .whiteLarge
            
            activityIndicator = indicator
            scrollView.addSubview(activityIndicator!)
            activityIndicator?.startAnimating()
            
            activityIndicator!.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                activityIndicator!.centerYAnchor.constraint(equalTo: newsImage!.centerYAnchor),
                activityIndicator!.centerXAnchor.constraint(equalTo: newsImage!.centerXAnchor)
            ])
            
            loadImage(with: url)
        }
        
        // MARK: titleLabel
        
        let tLabel = UILabel()
        tLabel.textAlignment = .left
        tLabel.textColor = .black
        tLabel.font = UIFont.systemFont(ofSize: self.view.frame.width/18, weight: UIFont.Weight.medium)
        tLabel.text = newsTitle
        tLabel.numberOfLines = 0
        
        titleLabel = tLabel
        scrollView.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if let imageView = newsImage {
            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20).isActive = true
        } else {
            titleLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        }
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        ])
        
        // MARK: fullTextLabel
        
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: self.view.frame.width/20, weight: UIFont.Weight.light)
        label.text = fullText
        label.numberOfLines = 0
        
        fullTextLabel = label
        scrollView.addSubview(fullTextLabel)
        
        fullTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            fullTextLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 20),
            fullTextLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -20),
            fullTextLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            fullTextLabel.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -10),
            fullTextLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9)
        ])
        
        
        
    }
    
    private func loadImage(with url: String) {
        let operationQueue = OperationQueue()
        
        operationQueue.addOperation {
            guard
                let url = URL(string: url),
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) else {return print("Something wrong with image")}
            
            DispatchQueue.main.async { [weak self] in
                self?.newsImage?.image = image
                self?.activityIndicator?.stopAnimating()
            }
        }
    }

}
