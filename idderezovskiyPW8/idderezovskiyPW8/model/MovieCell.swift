//
//  MovieCell.swift
//  idderezovskiyPW8
//
//  Created by Ilya Derezovskiy on 22.03.2022.
//

import Foundation
import UIKit
final class MovieCell: UITableViewCell {
    static let indentifier = "MovieCell"
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var poster: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: Self.indentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        contentView.addSubview(poster)
        contentView.addSubview(title)

        NSLayoutConstraint.activate([
            poster.topAnchor.constraint(equalTo: bottomAnchor),
            poster.centerXAnchor.constraint(equalTo: centerXAnchor),
            poster.centerYAnchor.constraint(equalTo: centerYAnchor),
            poster.heightAnchor.constraint(equalToConstant: 250),
            
            title.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            title.topAnchor.constraint(equalTo: poster.bottomAnchor, constant: 5),
            title.rightAnchor.constraint(equalTo: rightAnchor, constant: -20)
        ])
    }
}

