//
//  DiscountView.swift
//  Heron
//
//  Created by Longnn on 11/11/2022.
//

class DiscountView: UIView {

    var discount     = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.masksToBounds = true
    
        discount.text = "30%"
        
        discount.font = getCustomFont(size: 9, name: .bold)
        discount.textColor = UIColor.init(hexString: "ff6d6e")
        self.addSubview(discount)
        discount.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
    }

    func setDiscount(_ str: String) {
        self.discount.text = str
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
