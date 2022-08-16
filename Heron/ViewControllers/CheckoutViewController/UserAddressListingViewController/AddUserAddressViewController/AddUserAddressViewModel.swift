//
//  AddUserAddressViewModel.swift
//  Heron
//
//  Created by Luu Luc on 05/06/2022.
//

import UIKit
import RxRelay

class AddUserAddressViewModel: NSObject {
    weak var controller : AddUserAddressViewController?
    public var contact  = BehaviorRelay<ContactDataSource>(value: ContactDataSource.init(JSONString: "{}", context: nil)!)
    public var animation = BehaviorRelay<Bool>(value: false)
    public var isUpdated : Bool = false
    
    func createNewAddress() {
        self.animation.accept(true)
        _DeliveryServices.createNewUserAddress(newContact: contact.value) { errorMessage, isSuccess in
            self.animation.accept(false)
            
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { action in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            if isSuccess {
                self.controller?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    func updateAddress() {
        self.animation.accept(true)
        _DeliveryServices.updateUserAddress(newContact: contact.value) { errorMessage, isSuccess in
            self.animation.accept(false)
            
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            if isSuccess {
                self.controller?.navigationController?.popViewController(animated: true)
            }
        }
    }
}
