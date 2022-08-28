//
//  SubcriptionViewModel.swift
//  Heron
//
//  Created by Triet Nguyen on 12/06/2022.
//

import RxSwift
import RxRelay
import RxCocoa

class MainSubscriptionViewModel : NSObject {
    weak var controller     : MainSubscriptionViewController?
    var subcriptions        = BehaviorRelay<[SubscriptionData]>(value: [])
    var pendingSubscription = BehaviorRelay<[UserRegisteredSubscription]>(value: [])
    private let disposeBag  = DisposeBag()
    
    override init() {
        super.init()
        
        self.pendingSubscription
            .observe(on: MainScheduler.instance)
            .subscribe { pendingSubscription in
                DispatchQueue.global().async {
                    for sub in pendingSubscription.element ?? [] {
                        self.cancelSubscription(sub)
                    }
                }
            }
            .disposed(by: disposeBag)

    }
    
    private func cancelSubscription(_ userSubs: UserRegisteredSubscription) {
        _SubscriptionService.cancelImmediatelySubscription(userSubs) { errorMessage, successMessage in
            print(errorMessage)
            print(successMessage)
        }
    }
    
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
