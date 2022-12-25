//
//  FeatureView.swift
//  Heron
//
//  Created by Lucas on 12/25/22.
//

import UIKit

class FeatureView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .systemPink
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Data
    func setDataSource(_ productDat: ProductDataSource) {
        
    }
}
