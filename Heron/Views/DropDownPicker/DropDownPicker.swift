//
//  DropDownPicker.swift
//  Heron
//
//  Created by Longnn on 23/01/2023.
//

import Foundation
import DropDown
import UIKit

class DropDownPicker: UIView {
    
    var selectedItem = UILabel()
    
    let menu: DropDown = {
        let menu = DropDown()
        menu.dataSource = [
            "Item1",
            "Item2",
            "Item3",
            "Item3",
            "Item4"
        ]
        return menu
    }()
    
    @objc func onToggle(sender : UITapGestureRecognizer) {
        menu.show()
    }

    init(_ dataSource: [String]) {
        super.init(frame: .zero)
        menu.dataSource = dataSource
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.onToggle))
        self.addGestureRecognizer(gesture)
        menu.anchorView = self
        
        self.addSubview(selectedItem)
        selectedItem.text = "Category"
        selectedItem.textColor = kDefaultTextColor
        selectedItem.font = getCustomFont(size: 14.5, name: .bold)
        selectedItem.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(16)
        }
        
        let dropDownImg = UIImageView()
        dropDownImg.image = UIImage.init(named: "down_icon")
        dropDownImg.contentMode = .scaleAspectFit
        self.addSubview(dropDownImg)
        dropDownImg.snp.makeConstraints { make in
            make.width.equalTo(20)
            make.height.equalTo(14)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-16)
        }
        
        menu.selectionAction = { [unowned self] (index: Int, item: String) in
          print("Selected item: \(item) at index: \(index)")
            selectedItem.text = item
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
