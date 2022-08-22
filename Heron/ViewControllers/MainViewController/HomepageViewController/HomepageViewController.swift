//
//  HomepageViewController.swift
//  Heron
//
//  Created by Luu Luc on 03/05/2022.
//

import UIKit

class HomepageViewController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let menuBtn = UIBarButtonItem.init(image: UIImage.init(systemName: "circle.grid.cross"),
                                           style: .plain,
                                           target: self,
                                           action: #selector(menuButtonTapped))
        self.navigationItem.leftBarButtonItem = menuBtn
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - Buttons
    @objc private func menuButtonTapped() {
        
    }
}
