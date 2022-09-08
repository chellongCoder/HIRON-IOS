//
//  DetailOrderViewModel.swift
//  Heron
//
//  Created by Luu Luc on 19/08/2022.
//

import UIKit
import RxRelay

class DetailOrderViewModel: NSObject {
    
    weak var controller             : DetailOrderViewController?
    public let orderData            = BehaviorRelay<OrderDataSource?>(value: nil)
    public let shippingData         = BehaviorRelay<OrderShippingData?>(value: nil)
    
    func getOrderShippingInfo() {
        
        guard let orderID = self.orderData.value?.id else {return}
        
        self.controller?.startLoadingAnimation()
        _DeliveryServices.getShippingInfor(orderID: orderID) { errorMessage, shippingData in
            self.controller?.endLoadingAnimation()
            
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            if let shippingData = shippingData {
                self.shippingData.accept(shippingData)
            }
        }
    }
}
