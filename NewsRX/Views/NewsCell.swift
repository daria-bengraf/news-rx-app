//
//  NewsCell.swift
//  NewsRX
//
//  Created by Dariya Bengraf on 02.10.2020.
//  Copyright © 2020 Dariya Bengraf. All rights reserved.
//

import UIKit
import SnapKit

class NewsCell: UITableViewCell {
    
    let descriptionLabel:UILabel = {
        let description = UILabel()
        description.font = UIFont.boldSystemFont(ofSize: 14.0)
        description.numberOfLines = 0
        return description
    }()
    
    let publishedAt:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.numberOfLines = 0
        return label
    }()
    
    let articleLabel:UILabel = {
        let articleLabel = UILabel()
        articleLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.vertical)
        return articleLabel
    }()
    
    var newsImageView: UIImageView = {
        let iv =  UIImageView()
        iv.contentMode = .scaleAspectFill
        let data = #imageLiteral(resourceName: "placeholder").pngData()!
        iv.image = UIImage(data: data)
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        addSubview(descriptionLabel)
        addSubview(publishedAt)
        addSubview(articleLabel)
        addSubview(newsImageView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConstraints() {
        
        newsImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(100)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(newsImageView.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        
        articleLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(20)
        }
        
        publishedAt.snp.makeConstraints { make in
            make.top.equalTo(articleLabel.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
    }
    
}

