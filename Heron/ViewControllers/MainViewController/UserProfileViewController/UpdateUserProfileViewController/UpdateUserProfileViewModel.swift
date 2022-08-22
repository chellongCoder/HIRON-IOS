//
//  UpdateEHealthProfileViewModel.swift
//  Heron
//
//  Created by Luu Luc on 22/08/2022.
//

import UIKit

class UpdateUserProfileViewModel: NSObject {
    weak var controller : UpdateUserProfileViewController?
    
    func getUserProfile() {
        _UserServices.getUserProfile()
    }
}
