//
//  SelectDateAndTimeBooking.swift
//  Heron
//
//  Created by Lucas Luu on 25/07/2022.
//

import UIKit
import FSCalendar

class SelectDateAndTimeBookingViewController: BaseViewController,
                                FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {

    let calendar                    = FSCalendar()
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backBtn = UIBarButtonItem.init(image: UIImage.init(named: "back_icon")?.withRenderingMode(.alwaysOriginal),
                                           style: .plain,
                                           target: self,
                                           action: #selector(backButtonTapped))
        self.navigationItem.leftBarButtonItem = backBtn
        
        pageScroll.backgroundColor = .white
        pageScroll.showsVerticalScrollIndicator = false
        self.view.addSubview(pageScroll)
        pageScroll.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
        
        let contentView = UIView()
        contentView.backgroundColor = .white
        pageScroll.addSubview(contentView)
        contentView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.width.equalToSuperview()
        }
        
        let dateIcon = UIImageView()
        dateIcon.image = UIImage.init(named: "reminder_icon")
        contentView.addSubview(dateIcon)
        dateIcon.snp.makeConstraints {  (make) in
            make.top.equalToSuperview().offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(32)
        }
        
        let chooseDate = UILabel()
        chooseDate.text = "Select Date"
        chooseDate.textColor = .red
        chooseDate.font = getFontSize(size: 16, weight: .medium)
        contentView.addSubview(chooseDate)
        chooseDate.snp.makeConstraints {  (make) in
            make.centerY.equalTo(dateIcon)
            make.left.equalTo(dateIcon.snp.right).offset(12)
            make.right.equalToSuperview().offset(-16)
        }
        
        calendar.dataSource = self
        calendar.delegate = self
        calendar.customizeCalendarAppearance()
        contentView.addSubview(calendar)
        calendar.snp.makeConstraints { (make) in
            make.top.equalTo(dateIcon.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.height.equalTo(calendar.snp.width).multipliedBy(0.85)
        }
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = .lightGray
        contentView.addSubview(bottomLine)
        bottomLine.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(16)
            make.right.equalToSuperview()
            make.top.equalTo(calendar.snp.bottom)
            make.height.equalTo(1)
        }
        
        let previousBtn = UIButton()
        previousBtn.setImage(UIImage.init(named: "prev_black_calendar"), for: .normal)
        previousBtn.addTarget(self, action: #selector(prevButtonTapped), for: .touchUpInside)
        calendar.addSubview(previousBtn)
        previousBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(40)
        }
        
        let nextBtn = UIButton()
        nextBtn.setImage(UIImage.init(named: "next_black_calendar"), for: .normal)
        nextBtn.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        calendar.addSubview(nextBtn)
        nextBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
            make.width.height.equalTo(40)
        }
        
        let timeIcon = UIImageView()
        timeIcon.image = UIImage.init(named: "timer_icon")
        contentView.addSubview(timeIcon)
        timeIcon.snp.makeConstraints {  (make) in
            make.top.equalTo(calendar.snp.bottom).offset(16)
            make.left.equalToSuperview().offset(16)
            make.width.height.equalTo(32)
        }
        
        let chooseTime = UILabel()
        chooseTime.text = NSLocalizedString("kCartScreenChooseTimeTitle", comment: "")
        chooseTime.textColor = .lightGray
        chooseTime.font = getFontSize(size: 16, weight: .medium)
        contentView.addSubview(chooseTime)
        chooseTime.snp.makeConstraints {
            $0.left.equalTo(timeIcon.snp.right).offset(12)
            $0.right.equalToSuperview().offset(-16)
            $0.centerY.equalTo(timeIcon)
        }
        
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        self.view.addSubview(bottomView)
        bottomView.snp.makeConstraints {
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(80)
        }
        
        let continueBtn = UIButton()
        continueBtn.setTitle(NSLocalizedString("kSignInButtonTitle", comment: ""), for: .normal)
        continueBtn.setTitleColor(.white, for: .normal)
        continueBtn.backgroundColor = kPrimaryColor
        continueBtn.layer.cornerRadius = 8
        continueBtn.titleLabel?.font = getFontSize(size: 16, weight: .semibold)
        continueBtn.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        bottomView.addSubview(continueBtn)
        continueBtn.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-48)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-30)
        }
        
        let remindLbl = UILabel()
        remindLbl.isHidden = true
        remindLbl.text = NSLocalizedString("kCartScreenNoteMessage", comment: "")
        remindLbl.numberOfLines = 0
        remindLbl.font = getFontSize(size: 12, weight: .medium)
        remindLbl.textColor = kRedHightLightColor
        contentView.addSubview(remindLbl)
        remindLbl.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.right.equalToSuperview().offset(-16)
            $0.height.equalTo(30)
            $0.bottom.equalToSuperview().offset(-90)
        }
        
        let layout = SelectDateCalendarFlowLayout()
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
        layout.scrollDirection = .vertical
        
        
        self.collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: layout)
        self.collectionView?.isScrollEnabled = true
        self.collectionView?.backgroundColor = .white
        self.collectionView?.register(SelectDateCollectionViewCell.self, forCellWithReuseIdentifier: "SelectDateCollectionViewCell")
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints({ (make) in
            make.top.equalTo(chooseTime.snp.bottom).offset(10)
            make.centerX.width.equalToSuperview()
            make.bottom.equalTo(remindLbl.snp.top).offset(-20)
            make.height.equalTo(contentView.snp.width).multipliedBy(0.6)
        })
    }
    
    // MARK: - UIButton Action
    @objc private func continueButtonTapped() {

    }
    
    @objc private func cancelBtnTapped() {
        collectionView.reloadData()
    }
    
    @objc func prevButtonTapped() {
        let previousMonth = Calendar.current.date(byAdding: .month, value: -1, to: calendar.currentPage)!
        calendar.setCurrentPage(previousMonth, animated: true)
    }
    
    @objc func nextButtonTapped() {
        let nextMonth = Calendar.current.date(byAdding: .month, value: 1, to: calendar.currentPage)!
        calendar.setCurrentPage(nextMonth, animated: true)
    }
    
    override func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - UICalendar
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
    }
    
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
}

// MARK: - UICollectionViewDataSource
extension SelectDateAndTimeBookingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectDateCollectionViewCell", for: indexPath) as! SelectDateCollectionViewCell
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return resizeView(list: [], indexPath: indexPath, height: 46)
    }
    
    func resizeView(list: [String], indexPath: IndexPath, height: CGFloat) -> CGSize {
        let extraSpace: CGFloat = 32 + 4
        let width = 80 + extraSpace
        return CGSize(width: width, height: height)
    }
}

// MARK: - UICollectionViewDelegate, CustomWidthLayoutDelegate
extension SelectDateAndTimeBookingViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.reloadData()
        
    }
}
