//
//  Bundle+Content.swift
//  Morty
//
//  Created by Ezequiel Becerra on 05/06/2021.
//

import Foundation

extension Bundle {
    func content<T: Decodable>(fromFileName name: String) throws -> T? {
        guard let url = self.url(forResource: name, withExtension: "json") else {
            return nil
        }

        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder.standard()
        return try decoder.decode(T.self, from: data)
    }
}
