//
//  String+Utils.swift
//  Morty
//
//  Created by Ezequiel Becerra on 19/02/2026.
//

import Foundation

extension String {
    func truncated(to maxLength: Int) -> String {
        guard count > maxLength else { return self }
        return String(prefix(maxLength)).appending("…")
    }
}
