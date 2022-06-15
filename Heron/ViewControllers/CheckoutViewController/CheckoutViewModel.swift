//
//  CheckoutViewModel.swift
//  Heron
//
//  Created by Luu Luc on 04/06/2022.
//

import UIKit
import RxSwift
import RxRelay

class CheckoutViewModel: NSObject {

    public var reloadAnimation      = BehaviorRelay<Bool>(value: false)
    public var cartPreCheckout      : CartPrepearedResponseDataSource?
    
    func reloadPrecheckoutData() {
        _DeliveryServices.getListUserAddress()
    }
    
    func placeOrder() {
        _CheckoutServices.createOder()
    }
}
