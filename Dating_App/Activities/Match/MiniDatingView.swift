//
//  MiniDatingView.swift
//  Dating_App
//
//  Created by Robyn Chau on 08/05/2022.
//

import SwiftUI

struct MiniDatingView: View {
    @State var user: User
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(uiImage: (user.uiImages.first ?? UIImage(named: "timcook")!) ?? UIImage(named: "timcook")!)
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            VStack(alignment: .leading) {
                Spacer()
                VStack(alignment: .leading) {
                    Text("\(user.name), 21")
                        .font(.title3.bold())
                    Text(user.jobTitle ?? "Cheery Developer")
                        .font(.caption)
                    Text(user.intro ?? "Hello there! Welcome to Cherry")
                }
                .padding(8)
                .foregroundColor(.white)
            }
            .padding()
        }
        .frame(width: cardWidth, height: cardHeight)
    }
    var cardHeight: CGFloat {
        let screenHeight = UIScreen.main.bounds.size.height
        return screenHeight * 0.35
    }
    var cardWidth: CGFloat {
        let screenWidth = UIScreen.main.bounds.size.width
        return screenWidth * 0.8
    }
}

struct MiniDatingView_Previews: PreviewProvider {
    static var previews: some View {
        MiniDatingView(user: User.example)
    }
}
