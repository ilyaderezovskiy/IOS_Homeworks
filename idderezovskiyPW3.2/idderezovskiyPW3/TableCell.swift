//
//  TableCell.swift
//  idderezovskiyPW3
//
//  Created by Ilya Derezovskiy on 24.10.2021.
//

import UIKit

final class TableCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
