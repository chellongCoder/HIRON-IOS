//
//  OrderViewModel.swift
//  Heron
//
//  Created by Triet Nguyen on 11/06/2022.
//

import RxSwift
import RxRelay

class MyOrderViewModel: NSObject {

    weak var controller             : MyOrderViewController?
    public let filter               = BehaviorRelay<String>(value:"pending")
    public var orders               = BehaviorRelay<[OrderDataSource]>(value: [])
    private let disposeBag          = DisposeBag()
    
    override init() {
        super.init()
        self.filter
            .observe(on: MainScheduler.instance)
            .subscribe { _ in
                self.getMyOrder()
            }
            .disposed(by: disposeBag)
    }
    
    private func getMyOrder() {
        self.controller?.startLoadingAnimation()
        _OrderServices.getMyOrders(param: ["filter[status][eq]": filter.value]) { errorMessage, newOrder in
            self.controller?.endLoadingAnimation()
            
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { action in
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
    
//    func checkout() {
//        reloadAnimation.accept(true)
//        assert(cartData.value != nil, "Cart empty")
//        
//        guard let cartData = self.cartData.value else {return}
//        
//        _CartServices.checkout(cart: cartData) { errorMessage, successMessage in
//            self.reloadAnimation.accept(false)
//            
//            if errorMessage != nil {
//                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
//                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { action in
//                    alertVC.dismiss()
//                }))
//                _NavController.showAlert(alertVC)
//                return
//            }
//            
//            // TODO: Clear cart
//            let alertVC = UIAlertController.init(title: NSLocalizedString("Alert", comment: ""), message: "Checkout success", preferredStyle: .alert)
//            alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { action in
//                alertVC.dismiss()
//            }))
//            _NavController.showAlert(alertVC)
//        }
//    }
}
