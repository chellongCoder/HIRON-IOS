//
//  DoctorDetailsViewModel.swift
//  Heron
//
//  Created by Lucas Luu on 31/07/2022.
//

import UIKit
import RxRelay

class DoctorDetailsViewModel: NSObject {
    weak var controller     : DoctorDetailsViewController?
    var doctorData          = BehaviorRelay<DoctorDataSource?>(value: nil)
}
