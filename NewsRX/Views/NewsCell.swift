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
    
    let articleLabel:UILabel = {
        // TODO: Temp
        return UILabel()
        let articleLabel = UILabel()
        articleLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: NSLayoutConstraint.Axis.vertical)
        articleLabel.numberOfLines = 0
        return articleLabel
    }()
    
    var newsImageView: UIImageView = {
        // TODO: Temp
        return UIImageView()
        
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
//        addSubview(articleLabel)
//        addSubview(newsImageView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConstraints() {
        
//        newsImageView.snp.makeConstraints { make in
//           make.top.equalToSuperview().offset(20)
//           make.leading.equalToSuperview().offset(20)
//           make.trailing.equalToSuperview().offset(-20)
//           make.height.equalTo(0)
//        }
//
//        // Вопрос: почему после переезда на снапкит едет вёрстка у некоторых заголовков?
//
//        descriptionLabel.snp.makeConstraints { make in
//           make.top.equalTo(newsImageView.snp.bottom).offset(50)
//           make.leading.equalToSuperview().offset(20)
//           make.trailing.equalToSuperview().offset(-20)
//        }
//
//        articleLabel.snp.makeConstraints { make in
//            make.top.equalTo(descriptionLabel.snp.bottom).offset(15)
//            make.leading.equalToSuperview().offset(20)
//            make.trailing.bottom.equalToSuperview().offset(-20)
//
//        }
            
            // Вопрос: почему после переезда на снапкит едет вёрстка у некоторых заголовков?
            
            descriptionLabel.snp.makeConstraints { make in
               make.top.equalToSuperview().offset(0)
                make.bottom.equalToSuperview().offset(0)

               make.leading.equalToSuperview().offset(20)
               make.trailing.equalToSuperview().offset(-20)
            }
        
    }
    
}

