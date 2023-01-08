//
//  SelectDoctorTableViewCell.swift
//  Heron
//
//  Created by Lucas Luu on 25/07/2022.
//

import UIKit

class SelectDoctorTableViewCell: UITableViewCell {
    
    private let doctorContentView   = DoctorListingView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        
        self.contentView.addSubview(doctorContentView)
        doctorContentView.snp.makeConstraints { make in
            make.center.size.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Data
    func setDataSource(_ doctorData: DoctorDataSource) {
        self.doctorContentView.setDataSource(doctorData)
    }
    
    func setDelegate(_ delegate: DoctorListingViewDelegate) {
        self.doctorContentView.delegate = delegate
    }
}
