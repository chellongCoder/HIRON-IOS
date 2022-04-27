//
//  UITableView_EXT.swift
//
//  Created by Lucas Luu on 9/30/21.
//  Copyright © 2021 CB/I Digital .Inc
//  All rights reserved.
//

import UIKit

extension UITableView {
    func isLast(_ indexPath: IndexPath) -> Bool {
        return indexPath.row == numberOfRows(inSection: indexPath.section) - 1
    }

    func isFirst(_ indexPath: IndexPath) -> Bool {
        return indexPath.row == 0
    }
}
