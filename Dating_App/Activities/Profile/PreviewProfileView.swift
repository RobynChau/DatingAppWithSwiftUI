//
//  PreviewProfileView.swift
//  Dating_App
//
//  Created by Robyn Chau on 04/04/2022.
//

import SwiftUI

struct PreviewProfileView: View {
    @ObservedObject var viewModel = ViewModel()
    
    @State private var showingMore = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Group {
                        if let coverImage = viewModel.currentUser.coverImage {
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
                            Text("\(viewModel.currentUser.name), \(viewModel.currentUser.age)")
                                .font(.title.bold())
                            HStack(alignment: .lastTextBaseline, spacing: 3) {
                                Text(viewModel.currentUser.genderIdentity)
                                    .font(.title3)
                                    .foregroundColor(.secondary)
                                Text(viewModel.currentUser.showingGender ? "" : "(not visible)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Text(viewModel.currentUser.intro ?? "")
                                .font(.title2)
                                .foregroundColor(.secondary)
                        }

                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(viewModel.currentUser.informationList.indices, id: \.self) { index in
                                if index < 4 {
                                    if let info = viewModel.currentUser.informationList[index] {
                                        Label(info.0, systemImage: info.1)
                                    }
                                }
                            }
                            if viewModel.currentUser.informationList.count >= 4 {
                                Section {
                                    if showingMore {
                                        ForEach(viewModel.currentUser.informationList.indices, id: \.self) { index in
                                            if index >= 4 {
                                                if let info = viewModel.currentUser.informationList[index] {
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
                            ForEach(viewModel.currentUser.additionalImages.indices, id: \.self) { index in
                                if let image = viewModel.currentUser.additionalImages[index] {
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
        PreviewProfileView()
    }
}
