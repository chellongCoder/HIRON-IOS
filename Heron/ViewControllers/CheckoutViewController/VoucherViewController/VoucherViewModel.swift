//
//  VoucherViewModel.swift
//  Heron
//
//  Created by Luu Luc on 04/06/2022.
//

import UIKit
import RxRelay

class VoucherViewModel: NSObject {
    public var listUserVouchers = BehaviorRelay<[VoucherDataSource]>(value: [])
    public var animation        = BehaviorRelay<Bool>(value: false)
    
    func getListVoucher() {
        self.animation.accept(true)
        _PromotionServices.getListVouchers() { errorMessage, listNewVouchers in
            self.animation.accept(false)
            
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { action in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            if let listNewVouchers = listNewVouchers {
                guard let selectedVoucher = _CartServices.voucherCode.value else {
                    self.listUserVouchers.accept(listNewVouchers)
                    return
                }
                
                for voucher in listNewVouchers {
                    if voucher.id == selectedVoucher.id {
                        voucher.isSelectedVoucher = true
                    }
                }
                self.listUserVouchers.accept(listNewVouchers)
            }
        }
    }
}
