//
//  NewsCell.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 02.10.2020.
//  Copyright © 2020 Dariya Bengraf. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {
    
    let descriptionLabel:UILabel = {
        let description = UILabel()
        description.font = UIFont.boldSystemFont(ofSize: 20.0)
        description.numberOfLines = 0
        return description
    }()
    
    let articleLabel:UILabel = {
        let articleLabel = UILabel()
        articleLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.vertical)
        articleLabel.numberOfLines = 0
        return articleLabel
    }()
    
    var newsImageView: UIImageView = {
        let iv =  UIImageView()
        iv.contentMode = .scaleAspectFill
        let data = #imageLiteral(resourceName: "placeholder").pngData()!
        iv.image = UIImage(data: data)
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        addSubview(descriptionLabel)
        addSubview(articleLabel)
        addSubview(newsImageView)
        
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConstraints() {
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        newsImageView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        newsImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        newsImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        newsImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 50).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor,  constant: 20).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        
        articleLabel.translatesAutoresizingMaskIntoConstraints = false
        articleLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15).isActive = true
        articleLabel.leftAnchor.constraint(equalTo: leftAnchor,  constant: 20).isActive = true
        articleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        articleLabel.bottomAnchor.constraint(equalTo: bottomAnchor,  constant: -20).isActive = true
    }
    
}

