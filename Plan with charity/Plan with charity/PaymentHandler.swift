//
//  PaymentHandler.swift
//  Plan with charity
//
//  Created by Ilya Derezovskiy on 14.03.2022.
//

import SwiftUI
import PassKit

typealias PaymentCompletionHandler = (Bool) -> Void

class PaymentHandler: NSObject {

static let supportedNetworks: [PKPaymentNetwork] = [
    .amex,
    .masterCard,
    .visa
]

var paymentController: PKPaymentAuthorizationController?
var paymentSummaryItems = [PKPaymentSummaryItem]()
var paymentStatus = PKPaymentAuthorizationStatus.failure
var completionHandler: PaymentCompletionHandler?
    public var totalSum: Double = 0

    func startPayment(completion: @escaping PaymentCompletionHandler) {

    let total = PKPaymentSummaryItem(label: "ToTal", amount: NSDecimalNumber(string: String(format: "%f", totalSum)), type: .final)

    paymentSummaryItems = [total];
    completionHandler = completion

    // Create our payment request
    let paymentRequest = PKPaymentRequest()
    paymentRequest.paymentSummaryItems = paymentSummaryItems
    paymentRequest.merchantIdentifier = "merchant.com.YOURDOMAIN.YOURAPPNAME"
    paymentRequest.merchantCapabilities = .capability3DS
    paymentRequest.countryCode = "RU"
    paymentRequest.currencyCode = "RUB"
    paymentRequest.requiredShippingContactFields = [.phoneNumber, .emailAddress]
    paymentRequest.supportedNetworks = PaymentHandler.supportedNetworks

    // Display our payment request
    paymentController = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
    paymentController?.delegate = self
    paymentController?.present(completion: { (presented: Bool) in
        if presented {
            NSLog("Presented payment controller")
        } else {
            NSLog("Failed to present payment controller")
            self.completionHandler!(false)
         }
     })
  }
}

extension PaymentHandler: PKPaymentAuthorizationControllerDelegate {

func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {

    if payment.shippingContact?.emailAddress == nil || payment.shippingContact?.phoneNumber == nil {
        paymentStatus = .failure
    } else {
        paymentStatus = .success
    }

    completion(paymentStatus)
}

func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
    controller.dismiss {
        DispatchQueue.main.async {
            if self.paymentStatus == .success {
                self.completionHandler!(true)
            } else {
                self.completionHandler!(false)
            }
        }
    }
}

}
