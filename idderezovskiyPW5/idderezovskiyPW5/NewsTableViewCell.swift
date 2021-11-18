//
//  NewsTableViewCell.swift
//  idderezovskiyPW5
//
//  Created by Ilya Derezovskiy on 12.11.2021.
//

//
//  NewsTableViewCell.swift
//  idderezovskiyPW5
//
//  Created by Ilya Derezovskiy on 11.11.2021.
//

import UIKit

class NewsTableViewCellViewModel {
    var title: String?
    var description: String?
    var imageURL: URL?
    var imageData: Data? = nil
    
    init(
        title: String,
        description: String,
        imageURL: URL?
    ) {
        self.title = title
        self.description = description
        self.imageURL = imageURL
    }
}

var gradientColorOne : CGColor = UIColor(white: 0.85, alpha: 1.0).cgColor
var gradientColorTwo : CGColor = UIColor(white: 0.95, alpha: 1.0).cgColor

class NewsTableViewCell: UITableViewCell {
    static let  identifier = "NewsTableViewCell"
    
    private let newsTitleLable: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let subtitleLable: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    private let newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.backgroundColor = .secondarySystemBackground
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(newsTitleLable)
        contentView.addSubview(subtitleLable)
        contentView.addSubview(newsImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        newsTitleLable.frame = CGRect(
            x: 10,
            y: 0,
            width: contentView.frame.size.width - 170,
            height: 70)
        
        subtitleLable.frame = CGRect(
            x: 10,
            y: 60,
            width: contentView.frame.size.width - 170,
            height: contentView.frame.size.height / 2)
        
        newsImageView.frame = CGRect(
            x: contentView.frame.size.width - 150,
            y: 5,
            width: 140,
            height: contentView.frame.size.height - 10)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(with viewModel: NewsTableViewCellViewModel) {
        newsTitleLable.text = viewModel.title
        subtitleLable.text = viewModel.description
        
        if let data = viewModel.imageData {
            newsImageView.image = UIImage(data: data)
        } else if let url = viewModel.imageURL {
            //fetch
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                viewModel.imageData = data
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
