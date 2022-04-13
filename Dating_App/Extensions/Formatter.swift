//
//  Formatter.swift
//  Dating_App
//
//  Created by Robyn Chau on 06/04/2022.
//

import Foundation

extension Formatter {
    static let emptyTextField: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        formatter.minusSign = ""
        formatter.zeroSymbol = ""
        return formatter
    }()
}
