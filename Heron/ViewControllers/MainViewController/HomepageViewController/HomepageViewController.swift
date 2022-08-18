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
        let alertVC = UIAlertController.init(title: NSLocalizedString("Sign out", comment: ""),
                                             message: "Are you sure to sign out?", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("OK", comment: ""), style: .default, handler: { _ in
            alertVC.dismiss()
            _AppCoreData.signOut()
            _NavController.gotoLoginPage()
        }))
        alertVC.addAction(UIAlertAction.init(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { _ in
            alertVC.dismiss()
        }))
        _NavController.showAlert(alertVC)
    }
}
