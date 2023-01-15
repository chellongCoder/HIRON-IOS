//
//  BookingStepView.swift
//  Heron
//
//  Created by Lucas on 1/8/23.
//

import UIKit

class BookingStepView: UIView {
    
    private var step                    : Int = 0
    private let specialtyStep           = StepView()
    private let doctorStep              = StepView()
    private let visitingTimeStep        = StepView()
    private let confirmCheckoutStep     = StepView()
    private let makePaymentStep         = StepView()
    
    private let line1       = UIView()
    private let line2       = UIView()
    private let line3       = UIView()
    private let line4       = UIView()
    
    init(step: Int) {
        super.init(frame: .zero)
        
        specialtyStep.setSelected(true)
        specialtyStep.setStepTitleLabel("Specialty")
        self.addSubview(specialtyStep)
        specialtyStep.snp.makeConstraints { make in
            make.top.left.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.2)
        }
        
        line1.backgroundColor = kDisableColor
        line1.layer.cornerRadius = 1
        self.addSubview(line1)
        line1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.height.equalTo(2)
            make.width.equalTo(40)
            make.left.equalTo(specialtyStep.snp.right).offset(-20)
        }
        
        doctorStep.setStepCount(2)
        doctorStep.setStepTitleLabel("Doctor")
        self.addSubview(doctorStep)
        doctorStep.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(specialtyStep.snp.right)
            make.width.equalToSuperview().multipliedBy(0.2)
        }
        
        line2.backgroundColor = kDisableColor
        line2.layer.cornerRadius = 1
        self.addSubview(line2)
        line2.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.height.equalTo(2)
            make.width.equalTo(40)
            make.left.equalTo(doctorStep.snp.right).offset(-20)
        }
        
        visitingTimeStep.setStepCount(3)
        visitingTimeStep.setStepTitleLabel("Time")
        self.addSubview(visitingTimeStep)
        visitingTimeStep.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(doctorStep.snp.right)
            make.width.equalToSuperview().multipliedBy(0.2)
        }
        
        line3.backgroundColor = kDisableColor
        line3.layer.cornerRadius = 1
        self.addSubview(line3)
        line3.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.height.equalTo(2)
            make.width.equalTo(40)
            make.left.equalTo(visitingTimeStep.snp.right).offset(-20)
        }
        
        confirmCheckoutStep.setStepCount(4)
        confirmCheckoutStep.setStepTitleLabel("Checkout")
        self.addSubview(confirmCheckoutStep)
        confirmCheckoutStep.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(visitingTimeStep.snp.right)
            make.width.equalToSuperview().multipliedBy(0.2)
        }
        
        line4.backgroundColor = kDisableColor
        line4.layer.cornerRadius = 1
        self.addSubview(line4)
        line4.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.height.equalTo(2)
            make.width.equalTo(40)
            make.left.equalTo(confirmCheckoutStep.snp.right).offset(-20)
        }

        makePaymentStep.setStepCount(5)
        makePaymentStep.setStepTitleLabel("Payment")
        self.addSubview(makePaymentStep)
        makePaymentStep.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalTo(confirmCheckoutStep.snp.right)
            make.width.equalToSuperview().multipliedBy(0.2)
        }
        
        if step == 0 {
            specialtyStep.setSelected(true)
        } else if step == 1 {
            specialtyStep.setSelected(true)
            line1.backgroundColor = kPrimaryColor
            doctorStep.setSelected(true)
        } else if step == 2 {
            specialtyStep.setSelected(true)
            line1.backgroundColor = kPrimaryColor
            doctorStep.setSelected(true)
            line2.backgroundColor = kPrimaryColor
            visitingTimeStep.setSelected(true)
        } else if step == 3 {
            specialtyStep.setSelected(true)
            line1.backgroundColor = kPrimaryColor
            doctorStep.setSelected(true)
            line2.backgroundColor = kPrimaryColor
            visitingTimeStep.setSelected(true)
            line3.backgroundColor = kPrimaryColor
            confirmCheckoutStep.setSelected(true)
        } else if step == 4 {
            specialtyStep.setSelected(true)
            line1.backgroundColor = kPrimaryColor
            doctorStep.setSelected(true)
            line2.backgroundColor = kPrimaryColor
            visitingTimeStep.setSelected(true)
            line3.backgroundColor = kPrimaryColor
            confirmCheckoutStep.setSelected(true)
            line4.backgroundColor = kPrimaryColor
            makePaymentStep.setSelected(true)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setStep(_ step : Int) {
        self.step = step
    }
}

class StepView: UIView {
    
    private let circleView      = UIView()
    private let circleViewIcon  = UIImageView()
    private let circleViewCount = UILabel()
    private let stepTitle       = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        circleView.backgroundColor = .white
        circleView.layer.borderColor = kDisableColor.cgColor
        circleView.layer.borderWidth = 2
        circleView.layer.cornerRadius = 12
        self.addSubview(circleView)
        circleView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(24)
        }
        
        circleViewIcon.isHidden = true
        circleViewIcon.image = UIImage.init(named: "checkbox_selected")
        circleViewIcon.layer.masksToBounds = true
        self.addSubview(circleViewIcon)
        circleViewIcon.snp.makeConstraints { make in
            make.center.equalTo(circleView)
            make.height.width.equalTo(12)
        }
        
        circleViewCount.text = ""
        circleViewCount.textColor = kDisableColor
        circleViewCount.font = getCustomFont(size: 11.5, name: .bold)
        circleViewCount.isHidden = false
        circleViewCount.textAlignment = .center
        self.addSubview(circleViewCount)
        circleViewCount.snp.makeConstraints { make in
            make.center.equalTo(circleView)
        }
        
        stepTitle.text = ""
        stepTitle.font = getCustomFont(size: 11, name: .semiBold)
        stepTitle.textColor = .black
        stepTitle.textAlignment = .center
        self.addSubview(stepTitle)
        stepTitle.snp.makeConstraints { make in
            make.top.equalTo(circleView.snp.bottom).offset(8)
            make.centerX.equalTo(circleView)
        }
        
    }
    
    func setStepCount(_ step: Int) {
        circleViewCount.text = String(format: "%ld", step)
    }
    
    func setSelected(_ bool: Bool) {
        if bool == true {
            circleView.backgroundColor = kPrimaryColor
            circleView.layer.borderColor = kPrimaryColor.cgColor
            
            self.circleViewIcon.isHidden = false
            self.circleViewCount.isHidden = true
        }
    }
    
    func setStepTitleLabel(_ title: String) {
        self.stepTitle.text = title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class StepLine : UIView {
    
    private let selectedLine    = UIView()
    private let unselectedLine  = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = kDisableColor
        
        selectedLine.backgroundColor = kDisableColor
        selectedLine.layer.cornerRadius = 1
        self.addSubview(selectedLine)
        selectedLine.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(30)
            make.height.equalTo(2)
            make.width.equalTo(40)
            make.left.equalToSuperview().offset(-20)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
