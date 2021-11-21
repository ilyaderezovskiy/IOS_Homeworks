//
//  MyLogger1.swift
//  MyLogger1
//
//  Created by Ilya Derezovskiy on 21.11.2021.
//

import UIKit

public struct MyLogger1 {
    public static func log(_ s: String) {
        print("MyLogger1 from framework (\(Date())): \(s)")
    }
}
