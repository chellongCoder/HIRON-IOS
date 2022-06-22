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
        _DeliveryServices.getListUserAddress()
    }
}
