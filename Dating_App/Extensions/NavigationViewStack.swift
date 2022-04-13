//
//  NavigationViewStack.swift
//  Dating_App
//
//  Created by Robyn Chau on 07/04/2022.
//

import SwiftUI

extension View {
    @ViewBuilder func onlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone || UIDevice.current.userInterfaceIdiom == .pad {
            self.navigationViewStyle(.stack)
        } else {
            self
        }
    }
}
