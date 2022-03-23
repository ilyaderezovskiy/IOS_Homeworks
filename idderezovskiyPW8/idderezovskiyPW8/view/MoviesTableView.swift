//
//  MoviesListView.swift
//  idderezovskiyPW8
//
//  Created by Ilya Derezovskiy on 23.03.2022.
//

import UIKit

class MoviesTableView: UIView {
    
    var tableView = UITableView()
    var searchField = UITextField()
    private let controller: MoviesViewProtocol!
    
    private func configureSearchField() {
        addSubview(searchField)
        
        searchField.pinTop(to: self)
        searchField.pinLeft(to: self)
        searchField.pinRight(to: self)
        searchField.delegate = self
        
        searchField.textColor = .black
        searchField.attributedPlaceholder = NSAttributedString(
            string: "Поиск...",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        searchField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    private func configureTableView() {
        addSubview(tableView)
        
        tableView.pinTop(to: searchField.bottomAnchor)
        tableView.pinLeft(to: self)
        tableView.pinRight(to: self)
        tableView.pinBottom(to: self)
        
        tableView.backgroundColor = .clear
        tableView.dataSource = controller
        tableView.delegate = controller
        tableView.register(MovieView.self, forCellReuseIdentifier: MovieView.identifier)
    }

    init(frame: CGRect, controller: MoviesViewProtocol) {
        self.controller = controller
        super.init(frame: frame)
        self.backgroundColor = .white
        
        configureSearchField()
        configureTableView()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        controller.search(textField.text ?? "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MoviesTableView: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        controller.search(textField.text ?? "")
    }
}

