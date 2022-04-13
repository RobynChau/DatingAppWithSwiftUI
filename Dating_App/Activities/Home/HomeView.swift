//
//  HomeView.swift
//  Dating_App
//
//  Created by Robyn Chau on 06/04/2022.
//

import SwiftUI

struct HomeView: View {
    @State var showMenu = false
    @ObservedObject var users: Users
    var body: some View {
        let drag = DragGesture()
            .onEnded {
                if $0.translation.width > 20 {
                    withAnimation {
                        self.showMenu = false
                    }
                }
            }
        return NavigationView {
            GeometryReader { geometry in
                ZStack(alignment: .trailing) {
                    VStack {
                        Text("Hello World")
                        Text("Hello world")
                        Text("Hello world")
                        Text("Hello world")
                        Text("Hello world")
                        Text("Hello world")

                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    //.offset(x: self.showMenu ? -geometry.size.width/2 : 0)
                    .onTapGesture {
                        if showMenu {
                            showMenu.toggle()
                        }
                    }
                    if self.showMenu {
                        MenuView()
                            .frame(width: geometry.size.width / 2.5)
                            .transition(.move(edge: .trailing))
                    }
                }
                .gesture(drag)
            }
            .toolbar {
                Button {
                    withAnimation(.linear) {
                        self.showMenu.toggle()
                    }
                } label: {
                    Label("Side Menu", systemImage: "person.crop.circle")
                        .font(.title2)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(users: Users())
    }
}
