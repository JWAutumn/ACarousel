//
//  SwiftUIView.swift
//  
//
//  Created by csms on 17/04/2023.
//

import SwiftUI

struct PageControl: View {
    var numberOfPages: Int
    
    @Binding var currentPage: Int
    
    var body: some View {
        HStack {
            ForEach(0..<numberOfPages) { index in
                Circle()
                    .frame(width: 8, height: 8)
                    .foregroundColor(index == self.currentPage ? .accentColor : .primary.opacity(0.2))
                    .onTapGesture(perform: { self.currentPage = index })
            }
        }
    }
}


struct PageControl_Previews: PreviewProvider {
    static var previews: some View {
        @State var currentPage: Int = 1
        return PageControl(numberOfPages: 5, currentPage: $currentPage)
    }
}
