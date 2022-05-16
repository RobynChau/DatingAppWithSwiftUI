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
    static let tag: String? = "Dating"
    @ObservedObject var viewModel = ViewModel()

    var body: some View {
        ZStack {
            VStack {
                ZStack(alignment: .bottom) {
                    ForEach(0..<viewModel.filterUsers.count, id: \.self) { index in
                        UserCardView(user: viewModel.filterUsers[index]) { isCorrect in
                            if isCorrect {
                                viewModel.handledLikeAction(index: index)
                            } else {
                                viewModel.handledPassAction(index: index)
                            }
                            withAnimation {
                                viewModel.removeCard(at: index)
                            }
                        }
                        .stacked(at: index, in: viewModel.allUsers.users.count)
                    }
                }
            }
        }
    }
}

struct DatingView_Previews: PreviewProvider {
    static var previews: some View {
        DatingView()
    }
}
