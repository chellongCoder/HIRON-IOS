//
//  DetailOrderViewModel.swift
//  Heron
//
//  Created by Luu Luc on 19/08/2022.
//

import UIKit
import RxRelay

class DetailOrderViewModel: NSObject {
    weak var controller : DetailOrderViewController?
    public var orders               = BehaviorRelay<[OrderDataSource]>(value: [])
    
    func getMyOrder() {
        _OrderServices.getMyOrders(param: [:]) { errorMessage, newOrder in
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""),
                                                     message: errorMessage,
                                                     preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""),
                                                     style: .default,
                                                     handler: { _ in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            if let data = newOrder {
                self.orders.accept(data)
            }
        }
    }
    
}
