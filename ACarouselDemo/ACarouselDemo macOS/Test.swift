//
//  Test.swift
//  ACarouselDemo macOS
//
//  Created by 帝云科技 on 2020/11/17.
//

import SwiftUI
import ACarousel

struct Test: View {
    var body: some View {
        VStack {
            Image("Zoro")
                .resizable()
                .scaledToFill()
                .frame(height: 100)
                .clipped()
            
            ACarousel(Array(repeating: Item(image: Image("Zoro")), count: 3)) { _ in
                Color.red
            }
            .frame(width: 300, height: 300, alignment: .center)
        }
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
