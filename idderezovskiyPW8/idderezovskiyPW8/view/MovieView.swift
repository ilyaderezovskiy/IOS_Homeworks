//
//  Movie.swift
//  idderezovskiyPW8
//
//  Created by Ilya Derezovskiy on 22.03.2022.
//

import UIKit

class MovieView: UITableViewCell {
    static let identifier = "MovieCell"
    private let poster = UIImageView()
    private let title = UILabel()
    
    init() {
        super.init(style: .default, reuseIdentifier: Self.identifier)
        self.backgroundColor = .white
        configureUI()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(movie: Movie) {
        title.text = movie.title
        poster.image = movie.poster
    }
    
    private func configureUI() {
        poster.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        addSubview(poster)
        addSubview(title)
        
        poster.pinTop(to: self)
        poster.pinLeft(to: self)
        poster.pinRight(to: self)
        poster.setHeight(to: 300)
        
        title.pinTop(to: poster.bottomAnchor, 30)
        title.pinLeft(to: self)
        title.pinRight(to: self)
        title.setHeight(to: 30)
        
        title.textAlignment = .center
        title.textColor = .black
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

