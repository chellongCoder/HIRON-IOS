//
//  ProductListingViewModel.swift
//  Heron
//
//  Created by Luu Luc on 28/04/2022.
//

import UIKit

class ProductListingViewModel: NSObject {
    weak var controller     : ProductListingViewController? = nil
    var listProducts        : [String] = ["","","","","","","","","","",]
    var listBanners         : [String] = ["","","","","","","","",]
}
