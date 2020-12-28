//
//  ContentView.swift
//  ACarouselDemo iOS
//
//  Created by Autumn on 2020/11/16.
//

import SwiftUI
import ACarousel
               
struct Item: Identifiable {
    let id = UUID()
    let image: Image
}

let roles = ["Luffy", "Zoro", "Sanji", "Nami", "Usopp", "Chopper", "Robin", "Franky", "Brook"]

struct ContentView: View {
    
    @State var spacing: CGFloat = 10
    @State var headspace: CGFloat = 10
    @State var sidesScaling: CGFloat = 0.8
    @State var isWrap: Bool = false
    @State var autoScroll: Bool = false
    @State var time: TimeInterval = 1
    @State var currentIndex: Int = 0
    
    var body: some View {
        VStack {
            Text("\(currentIndex + 1)/\(roles.count)")
            Spacer().frame(height: 40)
            ACarousel(roles,
                      id: \.self,
                      index: $currentIndex,
                      spacing: spacing,
                      headspace: headspace,
                      sidesScaling: sidesScaling,
                      isWrap: isWrap,
                      autoScroll: autoScroll ? .active(time) : .inactive) { name in
                Image(name)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 300)
                    .cornerRadius(30)
            }
            .frame(height: 300)
            Spacer()
            
            ControlPanel(spacing: $spacing,
                         headspace: $headspace,
                         sidesScaling: $sidesScaling,
                         isWrap: $isWrap,
                         autoScroll: $autoScroll,
                         duration: $time)
            Spacer()
        }
    }
}

struct ControlPanel: View {
    
    @Binding var spacing: CGFloat
    @Binding var headspace: CGFloat
    @Binding var sidesScaling: CGFloat
    @Binding var isWrap: Bool
    @Binding var autoScroll: Bool
    @Binding var duration: TimeInterval
    
    var body: some View {
        VStack {
            Group {
                HStack {
                    Text("spacing: ").frame(width: 120)
                    Slider(value: $spacing, in: 0...30, minimumValueLabel: Text("0"), maximumValueLabel: Text("30")) { EmptyView() }
                }
                HStack {
                    Text("headspace: ").frame(width: 120)
                    Slider(value: $headspace, in: 0...30, minimumValueLabel: Text("0"), maximumValueLabel: Text("30")) { EmptyView() }
                }
                HStack {
                    Text("sidesScaling: ").frame(width: 120)
                    Slider(value: $sidesScaling, in: 0...1, minimumValueLabel: Text("0"), maximumValueLabel: Text("1")) { EmptyView() }
                }
                HStack {
                    Toggle(isOn: $isWrap, label: {
                        Text("wrap: ").frame(width: 120)
                    })
                }
                VStack {
                    HStack {
                        Toggle(isOn: $autoScroll, label: {
                            Text("autoScroll: ").frame(width: 120)
                        })
                    }
                    if autoScroll {
                        HStack {
                            Text("duration: ").frame(width: 120)
                            Slider(value: $duration, in: 1...10, minimumValueLabel: Text("1"), maximumValueLabel: Text("10")) { EmptyView() }
                        }
                    }
                }
            }
        }
        .padding([.horizontal, .bottom])
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}




