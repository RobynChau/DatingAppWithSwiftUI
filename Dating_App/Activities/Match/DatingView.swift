//
//  DatingView.swift
//  Dating_App
//
//  Created by Robyn Chau on 07/04/2022.
//

import SwiftUI

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = Double(total - position)
        return self.offset(x: 0, y: offset * 3)
    }
}

struct DatingView: View {
    @ObservedObject var allUsers: Users

    var body: some View {
        ZStack {
            VStack {
                ZStack(alignment: .bottom) {
                    ForEach(0..<allUsers.users.count, id: \.self) { index in
                        UserCardView(user: allUsers.users[index]) {
                            withAnimation {
                                removeCard(at: index)
                            }
                        }
                        .stacked(at: index, in: allUsers.users.count)
                    }
                }
            }
        }
    }
    func removeCard(at index: Int) {
        allUsers.users.remove(at: index)
    }
}

struct DatingView_Previews: PreviewProvider {
    static var previews: some View {
        DatingView(allUsers: Users.init())
    }
}
