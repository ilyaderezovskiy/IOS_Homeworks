//
//  CharityOrganization.swift
//  Plan with charity
//
//  Created by Ilya Derezovskiy on 13.03.2022.
//

import SwiftUI

class CharityOrganization {
    var name: String
    var annotation: String
    var url: URL
    var imgName: String
    
    init(name: String?, annotation: String?, url: String?, img: String?) {
        self.name = name ?? ""
        self.annotation = annotation ?? ""
        self.url = URL(string: url ?? "")!
        self.imgName = img ?? ""
    }
    
    init() {
        self.name = ""
        self.annotation = ""
        self.url = URL(string: "https:/apple.com/")!
        self.imgName = ""
    }
}
