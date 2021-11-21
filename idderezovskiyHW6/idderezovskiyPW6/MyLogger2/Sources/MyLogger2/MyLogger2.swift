import Foundation

public struct MyLogger2 {
    public static func log(_ s: String) {
         print("MyLogger2 from swift package (\(Date())): \(s)")
     }
}
