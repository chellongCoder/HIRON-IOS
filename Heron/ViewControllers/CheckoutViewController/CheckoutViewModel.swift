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

    public var cartData             = BehaviorRelay<CartDataSource?>(value: nil)
    public var deliveryAddress      = BehaviorRelay<ContactDataSource?>(value: nil)
    public var billingAddress       = BehaviorRelay<ContactDataSource?>(value: nil)
    public var voucherCode          = BehaviorRelay<String?>(value: nil)
}
