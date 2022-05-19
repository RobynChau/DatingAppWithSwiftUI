//
//  RangeSlider.swift
//  Dating_App
//
//  Created by Robyn Chau on 16/05/2022.
//

import SwiftUI

struct RangeSlider: View {
    @State var width: CGFloat = 0
    @State var width1: CGFloat = UIScreen.main.bounds.width - 110
    var totalWidth = UIScreen.main.bounds.width - 110
    var body: some View {
        VStack {
            HStack {
                Text("\(width)")
                Spacer()
                Text("\(width1)")
            }
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.black.opacity(0.2))
                    .frame(height: 6)

                Rectangle()
                    .fill(.primary)
                    .frame(width: self.width1 - self.width ,height: 8)
                    .offset(x: self.width + 20)

                HStack(spacing: 0) {
                    Circle()
                        .fill(.black)
                        .frame(width: 20, height: 20)
                        .offset(x: self.width)
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    if value.location.x >= 0 && value.location.x <= self.width1 {
                                        self.width = value.location.x
                                    }
                                })
                        )

                    Circle()
                        .fill(.black)
                        .frame(width: 20, height: 20)
                        .offset(x: self.width1)
                        .gesture(
                            DragGesture()
                                .onChanged({ value in
                                    if value.location.x <= self.totalWidth && value.location.x >= self.width {
                                        self.width1 = value.location.x
                                    }
                                })
                        )
                }
            }
        }
    }
}

struct RangeSlider_Previews: PreviewProvider {
    static var previews: some View {
        RangeSlider()
    }
}
