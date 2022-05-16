//
//  PurchaseButton.swift
//  Portfolio
//
//  Created by Robyn Chau on 25/03/2022.
//

import SwiftUI

struct PurchaseButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(minWidth: 200, minHeight: 44)
            .foregroundColor(.white)
            .background(.blue)
            .clipShape(Capsule())
            .opacity(configuration.isPressed ? 0.5 : 1)
    }
}
