//
//  MenuView.swift
//  Dating_App
//
//  Created by Robyn Chau on 13/04/2022.
//

import SwiftUI

struct MenuView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Button {

            } label: {
                Label("Profile", systemImage: "person")
            }
            Button {

            } label: {
                Label("Messages", systemImage: "envelope")
            }
            Button {

            } label: {
                Label("Settings", systemImage: "gear")
            }
            Button {

            } label: {
                Label("About Us", systemImage: "info.circle")
            }
            RectangleView()
            Button {

            } label: {
                Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
            }
            Spacer()
        }
        .padding()
        //.frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial)
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
