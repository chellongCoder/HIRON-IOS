//
//  UserAddressListingViewModel.swift
//  Heron
//
//  Created by Luu Luc on 05/06/2022.
//

import UIKit
import RxRelay

class UserAddressListingViewModel: NSObject {
    public var listUserAddress  = BehaviorRelay<[ContactDataSource]>(value: [])
    public var animation        = BehaviorRelay<Bool>(value: false)
    
    func getListUserAddress() {
        
        animation.accept(true)
        _DeliveryServices.getListUserAddress { errorMessage, listNewUserAddress in
            self.animation.accept(false)
            
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { action in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            if let listNewUserAddress = listNewUserAddress {
                self.listUserAddress.accept(listNewUserAddress)
            }
        }
    }
}
