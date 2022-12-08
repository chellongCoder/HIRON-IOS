//
//  UserAddressListingViewModel.swift
//  Heron
//
//  Created by Luu Luc on 05/06/2022.
//

import UIKit
import RxRelay

class UserAddressListingViewModel: NSObject {
    public var animation        = BehaviorRelay<Bool>(value: false)
    
    func getListUserAddress() {
        animation.accept(true)
        _DeliveryServices.getListUserAddress { _, _ in
            self.animation.accept(false)
        }
    }
}
