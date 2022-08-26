//
//  SubcriptionViewModel.swift
//  Heron
//
//  Created by Triet Nguyen on 12/06/2022.
//

import RxSwift
import RxRelay

class MainSubscriptionViewModel {
    weak var controller     : MainSubscriptionViewController?
    var subcriptions        = BehaviorRelay<[SubscriptionData]>(value: [])
    
    func getListSubscription()
    {
        _SubscriptionService.getListSubscription { errorMessage, data in
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { action in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            if let subcriptionList = data {
                self.subcriptions.accept(subcriptionList)
            }
        }
    }
}
