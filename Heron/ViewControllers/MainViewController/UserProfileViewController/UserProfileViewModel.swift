//
//  UserProfileViewModel.swift
//  Heron
//
//  Created by Luu Luc on 19/08/2022.
//

import UIKit

class UserProfileViewModel: NSObject {
    
    weak var controller : UserProfileViewController?
    
    func getUserProfile() {
        _UserServices.getUserProfile()
    }
}
