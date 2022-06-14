//
//  MainSubscriptionViewController.swift
//  Heron
//
//  Created by Triet Nguyen on 11/06/2022.
//

import UIKit
import RxSwift

class MainSubscriptionViewController: BaseViewController, UICollectionViewDelegate {

    var imagePicker = UIImagePickerController()
    var collectionView: UICollectionView!
    let sign_in_btn = UIButton()
    private let vm   = SubcriptionViewModel()
    var selectedIndex       : IndexPath? = nil {
        didSet {
                sign_in_btn.successButton(title: selectedIndex == nil ? "Skip":"Confirm")
        }
    }
    private let disposeBag          = DisposeBag()
//            let vm = AuthViewModel()

            override func configUI() {
                let bg = UIImageView(image: UIImage(named: "bg"))
                bg.contentMode = .scaleAspectFit
                self.view.addSubview(bg)
                bg.snp.makeConstraints {
                    $0.left.right.top.bottom.equalToSuperview()
                }
                
                
                let child_vỉew = UIView()
                self.view.addSubview(child_vỉew)
                child_vỉew.layer.cornerRadius = 25
                child_vỉew.backgroundColor = UIColor.init(hexString: "1890FF")?.withAlphaComponent(0.2)
                child_vỉew.snp.makeConstraints {
                    $0.left.right.equalToSuperview()
                    $0.bottom.equalToSuperview().offset(20)
                    $0.height.equalToSuperview().multipliedBy(0.7)
                }
                
                let stack_view   = UIStackView()
                stack_view.axis  = .vertical
                stack_view.distribution  = .fillProportionally
                stack_view.alignment = .center
                stack_view.spacing   = 10.0
                child_vỉew.addSubview(stack_view)
                stack_view.snp.makeConstraints {
                    $0.left.right.equalToSuperview()
                    $0.top.equalToSuperview().offset(20)
                }
                
                let sign_in_lbl = UILabel()
                sign_in_lbl.text = "Which plan do you wanna use?"
                
                let sign_up_lbl = UILabel()
                sign_up_lbl.text = "Save up to 15%"
                
                sign_in_btn.successButton(title: "Skip")
                sign_in_btn.addTarget(self, action: #selector(continue_action), for: .touchUpInside)
//
                let viewWidth = UIScreen.main.bounds.size.width/2 - 20;
                let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                layout.itemSize = CGSize(width: viewWidth, height: viewWidth)
                layout.minimumInteritemSpacing = 0
                layout.minimumLineSpacing = 0
                layout.scrollDirection = .horizontal

                collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
                collectionView.delegate = self
                collectionView.register(SubcriptionCollectionViewCell.self, forCellWithReuseIdentifier: "SubcriptionCollectionViewCell")
                collectionView.showsVerticalScrollIndicator = false
                collectionView.backgroundColor = .clear
                
                stack_view.addArrangedSubview(sign_in_lbl)
                stack_view.addArrangedSubview(sign_up_lbl)
                stack_view.addArrangedSubview(collectionView)
                stack_view.addArrangedSubview(sign_in_btn)
                
             
                sign_in_btn.snp.makeConstraints {
                    $0.width.equalToSuperview().multipliedBy(0.5)
                }

                collectionView.snp.makeConstraints {
                    $0.width.equalToSuperview()
                    $0.height.equalTo(200)
                }
               
                
                
    //            self.addNavigationBarButton(imageName: "ic-back-navi", direction: .left, action: #selector(back))
        //        self.btnNext.stylingActive(cornerRadius: 5.0)
        //        self.imgAddIDCard.cardStyle(color: AppConfig.Color.blueBlur)
        //
        //        //setup pick TransportLicense
        //        let tapImgAddIDCard = UITapGestureRecognizer(target: self, action: #selector(actionAddIDCard(_:)))
        //        self.imgAddIDCard.addGestureRecognizer(tapImgAddIDCard)
        //        self.imgAddIDCard.isUserInteractionEnabled = true
            }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            vm.getListSubscription()
            
        }
            
            @objc func continue_action(_ sender: Any) {
                if selectedIndex == nil {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    let vc = SubscriptionPaymentViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            

    override func bindingData() {
        vm.subcriptions.observe(on: MainScheduler.instance)
            .subscribe { cartDataSource in
//                self.cartHotInfo.cartPriceValue.text = String(format: "$%ld", cartDataSource?.grandTotal ?? 0)
            }
            .disposed(by: disposeBag)
        
        
        vm.subcriptions
            .bind(to: collectionView.rx.items) {
                (collectionView: UICollectionView, index: Int, element: SubcriptionData) in
                let indexPath = IndexPath(row: index, section: 0)
                         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubcriptionCollectionViewCell", for: indexPath) as! SubcriptionCollectionViewCell
                cell.titleLabel.text = element.subsItem?.name
                cell.priceLabel.text = "$\(element.finalPrice!)"
                cell.footerLabel.text = "\(element.createdAt!)"
                
                if self.selectedIndex?.row == indexPath.row && self.selectedIndex?.section == indexPath.section {
                           cell.setSelected(true)
                       } else {
                           cell.setSelected(false)
                       }
               
//                          cell.value?.text = "\(element) @ \(row)"
                          return cell
            }
            .disposed(by: disposeBag)
    }

    
    //MARK: - UICollectionViewDataSource
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return vm.subcriptions.value.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SubcriptionCollectionViewCell", for: indexPath) as! SubcriptionCollectionViewCell
//        cell.titleLabel.text = "Monthly subcription"
//        cell.priceLabel.text = "$ 10.00/month"
//        cell.footerLabel.text = "Include 14 days free"
////        let cellData = viewModel.listCategories[indexPath.row]
////        cell.setDataSource(data: cellData)
//////
//        if selectedIndex?.row == indexPath.row && selectedIndex?.section == indexPath.section {
//            cell.setSelected(true)
//        } else {
//            cell.setSelected(false)
//        }
//
//        return cell
//    }
//
//    //MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let tempIndex = self.selectedIndex {
            if self.selectedIndex == indexPath {
                self.selectedIndex = nil
            } else {
                self.selectedIndex = indexPath
            }
            self.collectionView.reloadItems(at: [tempIndex, indexPath])
            return
        }


        self.selectedIndex = indexPath
        self.collectionView.reloadItems(at: [indexPath])
    }
        }



