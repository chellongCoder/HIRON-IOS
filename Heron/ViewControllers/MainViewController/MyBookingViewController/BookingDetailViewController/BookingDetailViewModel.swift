//
//  BookingDetailViewModel.swift
//  Heron
//
//  Created by Luu Luc on 09/09/2022.
//

import UIKit
import RxRelay

class BookingDetailViewModel: NSObject {
    weak var controller     : BookingDetailViewController?
    let bookingData         = BehaviorRelay<BookingAppointmentDataSource?>(value:nil)
}
