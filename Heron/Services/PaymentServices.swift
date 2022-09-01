//
//  PaymentServices.swift
//  Heron
//
//  Created by Luu Luc on 31/08/2022.
//

import UIKit
import Stripe

class PaymentServices: NSObject {
    public static let sharedInstance    = PaymentServices()
    private var paymentSheet            : PaymentSheet?
    private var configuration           = PaymentSheet.Configuration()
    
    override init() {
        super.init()
        
        STPAPIClient.shared.publishableKey = kStripePublishableKey
        configuration.merchantDisplayName = "Heron Inc."
        configuration.allowsDelayedPaymentMethods = false
    }
    
    func payment(_ paymentIntentClientSecret: String,
                 completion: @escaping (PaymentSheetResult) -> Void ) {
        
        self.paymentSheet = PaymentSheet(paymentIntentClientSecret: paymentIntentClientSecret, configuration: self.configuration)
        self.paymentSheet?.present(from: _NavController, completion: { paymentResult in
            // MARK: Handle the payment result
            completion(paymentResult)
        })
    }
}
