//
//  ContentView.swift
//  ACarouselDemo macOS
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
    
    let items: [Item] = roles.map { Item(image: Image($0)) }
    
    @State var spacing: CGFloat = 10
    @State var headspace: CGFloat = 10
    @State var sidesScaling: CGFloat = 0.8
    @State var isWrap: Bool = false
    @State var autoScroll: Bool = false
    @State var time: TimeInterval = 1
    
    var body: some View {
        VStack {
            Spacer().frame(height: 30)
            ACarousel(items,
                      index: .constant(2),
                      spacing: spacing,
                      headspace: headspace,
                      sidesScaling: sidesScaling,
                      isWrap: isWrap,
                      autoScroll: autoScroll ? .active(time) : .inactive) {  item in
                item.image
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




