import SwiftUI

struct UserCardView: View {
    let user: User

    var removal: ((_ isCorrect: Bool) -> Void)?

    @State private var offset = CGSize.zero
    @State private var showingImage = false
    @State private var showingSheet = false
    @State private var showingMore = false
    
    var body: some View {
        imageCardView
            .padding([.horizontal, .bottom])
        .sheet(isPresented: $showingSheet) {
            informationCardView

        }
    }

    var imageCardView: some View {
        ZStack(alignment: .bottomLeading) {
            if let coverImageDate = user.images[0] {
                if let coverImage = UIImage(data: coverImageDate) {
                    Image(uiImage: coverImage)
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                        .background(
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .blur(radius: 5)
                                .frame(width: cardWidth + 10, height: cardHeight + 10)
                                .foregroundColor(getBackgroundColor(offset: offset))
                        )
                        .shadow(radius: 10)
                } else {
                    RoundedRectangle(cornerRadius: 25, style: .continuous)
                        .fill(.white.opacity(1 - Double(abs(offset.width / 50))))
                        .background(
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .fill(getBackgroundColor(offset: offset))
                        )
                        .shadow(radius: 10)
                }

            } else {
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(.white.opacity(1 - Double(abs(offset.width / 50))))
                    .background(
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(getBackgroundColor(offset: offset))
                    )
                    .shadow(radius: 10)
            }
            VStack(alignment: .leading) {
                Spacer()
                VStack(alignment: .leading) {
                    Text("\(user.name), \(user.age)")
                        .font(.title3.bold())
                    Text(user.jobTitle ?? "")
                        .font(.caption)
                    Text(user.intro ?? "")
                }
                .padding(8)
                .foregroundColor(.white)
            }
            .padding()
        }
        .padding()
        .frame(width: cardWidth, height: cardHeight)
        .rotationEffect(.degrees(Double(offset.width / 5)))
        .offset(x: offset.width * 5, y: 0)
        .opacity(2 - Double(abs(offset.width / 50)))
        .accessibilityAddTraits(.isButton)
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                }
                .onEnded { _ in
                    if abs(offset.width) > 100 {
                        if offset.width < 0 {
                        }
                        removal?(offset.width > 0)
                    } else {
                        offset = .zero
                    }
                }
        )
        .animation(.spring(), value: offset)
        .onTapGesture {
            showingSheet = true
        }
    }

    var informationCardView: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    VStack(alignment: .leading, spacing: 0) {
                        Group {
                            Text("\(user.name), \(user.age)")
                                .font(.title.bold())
                            HStack(alignment: .lastTextBaseline, spacing: 3) {
                                Text(user.genderIdentity)
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
                            ForEach(user.informationList.indices, id: \.self) { index in
                                if index < 4 {
                                    if let info = user.informationList[index] {
                                        Label(info.0, systemImage: info.1)
                                    }
                                }
                            }
                            if user.informationList.count >= 4 {
                                Section {
                                    if showingMore {
                                        ForEach(user.informationList.indices, id: \.self) { index in
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
                            ForEach(user.additionalImages.indices, id: \.self) { index in
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
        }
    }
    
    func getBackgroundColor(offset: CGSize) -> Color {
        if offset.width > 0 {
            return .green.opacity(0.1)
        } else if offset.width < 0 {
            return .pink.opacity(0.1)
        } else {
            return .white.opacity(0.05)
        }
    }

    var cardHeight: CGFloat {
        let screenHeight = UIScreen.main.bounds.size.height
        return screenHeight * 0.8
    }
    var cardWidth: CGFloat {
        let screenWidth = UIScreen.main.bounds.size.width
        return screenWidth * 0.95
    }
}

struct UserCardView_Previews: PreviewProvider {
    static var previews: some View {
        UserCardView(user: User.example)
    }
}
