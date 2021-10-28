//
//  NSAttributedString.swift
//  Morty
//
//  Created by Ezequiel Becerra on 25/10/2021.
//

import Foundation
import AppKit

extension String {

    func attributed(leadingSymbol symbolName: String) -> NSAttributedString {
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = NSImage(systemSymbolName: symbolName, accessibilityDescription: nil)

        let attributed = NSMutableAttributedString()
        attributed.append(NSAttributedString(attachment: imageAttachment))
        attributed.append(NSAttributedString(string: " \(self)"))

        return attributed
    }
}
