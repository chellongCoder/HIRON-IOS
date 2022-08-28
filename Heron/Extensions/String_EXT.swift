//
//  String_EXT.swift
//
//  Created by Lucas Luu on 9/30/21.
//  Copyright © 2021 CB/I Digital .Inc
//  All rights reserved.
//

import Foundation

extension String {
    func htmlAttributedString() -> NSMutableAttributedString? {
        
        let modifiedFont = String(format:"<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: 14\">%@</span>", self)

        guard let data = modifiedFont.data(using: .unicode) else {
            return nil
        }

        return try? NSMutableAttributedString(
            data: data,
            options: [.documentType: NSMutableAttributedString.DocumentType.html],
            documentAttributes: nil
        )
    }

    func shortenID() -> String {
        (self.components(separatedBy: "-").last ?? "").uppercased()
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func maskPhone() -> String {
    return String(self.enumerated().map { index, char in
        return [self.count - 2, self.count - 1].contains(index) ?
       char : "*"
       })
    }
}

extension Date {
    func toString( dateFormat format: String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

}
