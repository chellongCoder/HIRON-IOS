//
//  MyApoitmentViewModel.swift
//  Heron
//
//  Created by Luu Luc on 21/08/2022.
//

import UIKit
import RxRelay

class MyApoitmentViewModel: NSObject {
    weak var controller : MyApoitmentViewController?
    public let filter               = BehaviorRelay<String>(value:"pending")
    public let listAppoitments      = BehaviorRelay<[String]>(value: [])
    
    
}
