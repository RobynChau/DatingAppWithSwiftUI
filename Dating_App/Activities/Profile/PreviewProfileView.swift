//
//  PreviewProfileView.swift
//  Dating_App
//
//  Created by Robyn Chau on 04/04/2022.
//

import SwiftUI

struct PreviewProfileView: View {
    let user: User
    @State private var showingMore = false
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Group {
                        if let coverImage = user.coverImage {
                            coverImage
                                .resizable()
                                .frame(width: 400, height: 300)
                        } else {
                            RoundedRectangle(cornerRadius: 5)
                                .frame(maxWidth: 400, maxHeight: 300)
                        }
                    }
                    VStack(alignment: .leading, spacing: 0) {
                        Group {
                            Text("\(user.name), \(user.age)")
                                .font(.title.bold())
                            HStack(alignment: .lastTextBaseline, spacing: 3) {
                                Text(user.gender)
                                    .font(.title3)
                                    .foregroundColor(.secondary)
                                Text(user.showingGender ? "" : "(not visible)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Text(user.intro ?? "")
                                .font(.title2)
                                .foregroundColor(.secondary)
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(user.informationList.indices) { index in
                                if index < 4 {
                                    if let info = user.informationList[index] {
                                        Label(info.0, systemImage: info.1)
                                    }
                                }
                            }
                            if user.informationList.count >= 4 {
                                Section {
                                    if showingMore {
                                        ForEach(user.informationList.indices) { index in
                                            if index >= 4 {
                                                if let info = user.informationList[index] {
                                                    Label(info.0, systemImage: info.1)
                                                }
                                            }
                                        }
                                    }
                                    Button(showingMore ? "Show Less..." : "Show More...") {
                                        withAnimation(.default) { showingMore.toggle() }
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 5)

                        VStack {
                            ForEach(user.additionalImages.indices) { index in
                                if let image = user.additionalImages[index] {
                                    image
                                        .resizable()
                                        .frame(width: 400, height: 300)
                                    }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Profile Preview")
        }
    }

}

struct PreviewProfileView_Previews: PreviewProvider {
    static var previews: some View {
        PreviewProfileView(user: User.example)
    }
}
