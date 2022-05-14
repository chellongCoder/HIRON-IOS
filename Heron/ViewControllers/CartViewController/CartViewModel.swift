//
//  CartViewModel.swift
//  Heron
//
//  Created by Luu Luc on 15/05/2022.
//

import UIKit

class CartViewModel: NSObject {
    weak var controller     : CartViewController? = nil
    var listProducts        : [ProductDataSource] = []
}
