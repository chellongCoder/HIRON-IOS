//
//  AddUserAddressViewModel.swift
//  Heron
//
//  Created by Luu Luc on 05/06/2022.
//

import UIKit
import RxRelay

class AddUserAddressViewModel: NSObject {
    weak var controller : AddUserAddressViewController? = nil
    public var contact  = BehaviorRelay<ContactDataSource>(value: ContactDataSource.init(JSONString: "{}", context: nil)!)
    public var animation = BehaviorRelay<Bool>(value: false)
    
    func createNewAddress() {
        self.animation.accept(true)
        _DeliveryServices.createNewUserAddress(newContact: contact.value) { errorMessage, isSuccess in
            self.animation.accept(true)
            
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
}
