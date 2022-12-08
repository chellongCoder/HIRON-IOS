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
    public let filter               = BehaviorRelay<String?>(value:nil)
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
        
        var param : [String:Any] = [:]
        
        if let filter = self.filter.value {
            param["filter[status][eq]"] = filter
        }
        
        _OrderServices.getMyOrders(param: param) { errorMessage, newOrder in
            self.controller?.endLoadingAnimation()
            
            if errorMessage != nil {
                let alertVC = UIAlertController.init(title: NSLocalizedString("Error", comment: ""), message: errorMessage, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
                    alertVC.dismiss()
                }))
                _NavController.showAlert(alertVC)
                return
            }
            
            if var data = newOrder {
                
                // Hiden all PENDING order
                data = data.filter({ orderDataSource in
                    return orderDataSource.getOrderStatusValue() != "PENDING"
                })
                self.orders.accept(data)
            }
        }
    }
}
