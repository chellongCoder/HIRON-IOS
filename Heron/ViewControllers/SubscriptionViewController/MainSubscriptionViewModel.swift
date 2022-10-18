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
    weak var controller             : MainSubscriptionViewController?
    var subcriptions                = BehaviorRelay<[SubscriptionData]>(value: [])
    private let pendingSubscription = BehaviorRelay<[UserRegisteredSubscription]>(value: [])
    private let disposeBag          = DisposeBag()
    
    override init() {
        super.init()
        
        self.getCurrentUserSubscription()
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
            print(errorMessage ?? "")
            print(successMessage ?? "")
        }
    }
    
    func getCurrentUserSubscription() {
        _SubscriptionService.getUserRegisteredSubscriptionPlan { _, listUserSubscriptions in
            let userPendingSub = listUserSubscriptions?.filter({ userRegisteredSubscription in
                return userRegisteredSubscription.getStatusText() == "Under Payment"
            })
            
            self.pendingSubscription.accept(userPendingSub ?? [])
        }
    }
    
    func getListSubscription() {
        _SubscriptionService.getListSubscription { errorMessage, data in
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
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
    
    func switchPlanTo(fromPlan: UserRegisteredSubscription, toPlan: SubscriptionData) {
        self.controller?.startLoadingAnimation()
        _SubscriptionService.switchPlan(fromPlan: fromPlan.id, toNewPlan: toPlan.id) { errorMessage, _ in
            self.controller?.endLoadingAnimation()
            
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    alertVC.dismiss()
                    self.controller?.navigationController?.popToRootViewController(animated: true)
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            let alertVC = UIAlertController.init(title: NSLocalizedString("Switch success!", comment: ""),
                                                 message: "You have successfully switched to the new plan.",
                                                 preferredStyle: .alert)
            alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                alertVC.dismiss()
                self.controller?.navigationController?.popToRootViewController(animated: true)
            }))
            _NavController.showAlert(alertVC)
        }
    }
}
