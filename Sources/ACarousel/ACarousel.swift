/**
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import SwiftUI
import Combine

@available(iOS 13.0, OSX 10.15, *)
typealias TimePublisher = Publishers.Autoconnect<Timer.TimerPublisher>


@available(iOS 13.0, OSX 10.15, *)
public struct ACarousel<Data, Content> : View where Data : RandomAccessCollection, Content : View, Data.Element : Identifiable {
    
//    public enum AutoScroll {
//        case inactive
//        case active(TimeInterval)
//    }
    
//    private let _data: [Data.Element]
//    private let _spacing: CGFloat
//    private let _headspace: CGFloat
//    private let _isWrap: Bool
//    private let _sidesScaling: CGFloat
//    private let _autoScroll: AutoScroll
    private let content: (Data.Element) -> Content
    
//    private var timer: TimePublisher? = nil
    
//    @ObservedObject private var aState = AState()
    @ObservedObject private var aState: ACarouselViewModel<Data, Data.Element.ID>
    
    public var body: some View {
        GeometryReader { proxy -> AnyView in
            aState.viewSize = proxy.size
            return AnyView(generateContent(proxy: proxy))
        }.clipped()
    }
    
    private func generateContent(proxy: GeometryProxy) -> some View {
        HStack(spacing: aState.spacing) {
            ForEach(aState.data) {
                content($0)
                    .frame(width: aState.itemWidth(proxy))
                    .scaleEffect(x: 1, y: aState.itemScale($0), anchor: .center)
            }
        }
        .frame(width: proxy.size.width, height: proxy.size.height, alignment: .leading)
        .offset(x: aState.offsetValue(proxy))
        .gesture(aState.dragGesture(proxy))
        .animation(aState.offsetAnimation)
        .onReceive(timer: aState.timer, perform: receiveTimer)
        .onReceiveAppLifeCycle { aState.isTimerActive = $0 }
        .onReceive(aState.$activeItem) { _ in
            aState.offsetChanged(aState.offsetValue(proxy), proxy: proxy)
        }
    }
    
}


// MARK: - Initializers
@available(iOS 13.0, OSX 10.15, *)
extension ACarousel {
    
    /// Creates an instance that uniquely identifies and creates views across
    /// updates based on the identity of the underlying data.
    ///
    /// - Parameters:
    ///   - data: The identified data that the ``ACarousel`` instance uses to
    ///     create views dynamically.
    ///   - spacing: The distance between adjacent subviews, default is 10.
    ///   - headspace: The width of the exposed side subviews, default is 10
    ///   - sidesScaling: The scale of the subviews on both sides, limits 0...1,
    ///      default is 0.8.
    ///   - isWrap: Define views to scroll through in a loop, default is false.
    ///   - autoScroll: A enum that define view to scroll automatically. See
    ///     ``ACarousel.AutoScroll``. default is `inactive`.
    ///   - content: The view builder that creates views dynamically.
    public init(_ data: Data, spacing: CGFloat = 10, activeIndex: Binding<Int>, headspace: CGFloat = 10, sidesScaling: CGFloat = 0.8, isWrap: Bool = false, autoScroll: AutoScroll = .inactive,
                @ViewBuilder content: @escaping (Data.Element) -> Content) {
        
        self.aState = ACarouselViewModel(data, spacing: spacing, activeIndex: activeIndex, headspace: headspace, sidesScaling: sidesScaling, isWrap: isWrap, autoScroll: autoScroll)
        self.content = content
        
//        self._data = data.map { $0 }
//        self._spacing = spacing
//        self._headspace = headspace
//        self._isWrap = isWrap
//        self._sidesScaling = sidesScaling
//        self._autoScroll = autoScroll
//        self.content = content
//
//        if !self.isWrap {
//            aState = AState(activeItem: 0)
//        }
//        if self.autoScroll.isActive {
//            timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
//        }
    }
}

/**
// MARK: - Private value
@available(iOS 13.0, OSX 10.15, *)
extension ACarousel {
    
    private var data: [Data.Element] {
        guard _data.count != 0 else {
            return _data
        }
        guard _data.count > 1 else {
            return _data
        }
        guard isWrap else {
            return _data
        }
        return [_data.last!] + _data + [_data.first!]
    }
    
    private var spacing: CGFloat {
        return _spacing
    }
    
    private var headspace: CGFloat {
        return _headspace
    }
    
    private var sidesScaling: CGFloat {
        return max(min(_sidesScaling, 1), 0)
    }
    
    private var isWrap: Bool {
        return _data.count > 1 ? _isWrap : false
    }
    
    private var autoScroll: AutoScroll {
        guard _data.count > 1 else { return .inactive }
        guard case let .active(t) = _autoScroll else { return _autoScroll }
        return t > 0 ? _autoScroll : .defaultActive
    }
    
    private var offsetAnimation: Animation? {
        return aState.animation ? .spring() : .none
    }
    
    private var defaultPadding: CGFloat {
        return (headspace + spacing)
    }
    
    /// with of subview
    private func itemWidth(_ proxy: GeometryProxy) -> CGFloat {
        proxy.size.width - defaultPadding * 2
    }
    
    private func itemSize(_ proxy: GeometryProxy) -> CGFloat {
        itemWidth(proxy) + spacing
    }
    
    private func itemScale(_ item: Data.Element) -> CGFloat {
        guard aState.activeItem < data.count else {
            return 0
        }
        return AnyHashable(data[aState.activeItem].id) == AnyHashable(item.id) ? 1 : sidesScaling
    }
    
}
 */

/**
// MARK: - Offset Method
@available(iOS 13.0, OSX 10.15, *)
extension ACarousel {
    
    private func offsetValue(_ proxy: GeometryProxy) -> CGFloat {
        let activeOffset = CGFloat(aState.activeItem) * aState.itemSize(proxy)
        let value = aState.defaultPadding - activeOffset + aState.dragOffset
        return value
    }
    
    private func offsetChanged(_ newOffset: CGFloat, proxy: GeometryProxy) {
        aState.isAnimationOffset = true
        guard aState.isWrap else {
            return
        }
        let minOffset = aState.defaultPadding
        let maxOffset = (aState.defaultPadding - CGFloat(aState.data.count - 1) * aState.itemSize(proxy))
        if newOffset == minOffset {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                aState.activeItem = aState.data.count - 2
                aState.isAnimationOffset = false
            }
        } else if newOffset == maxOffset {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                aState.activeItem = 1
                aState.isAnimationOffset = false
            }
        }
    }
}
 */

/***
// MARK: - Drag Method
@available(iOS 13.0, OSX 10.15, *)
extension ACarousel {
    
    private func dragGesture(_ proxy: GeometryProxy) -> some Gesture {
        DragGesture()
            .onChanged { dragChanged($0, proxy: proxy) }
            .onEnded { dragEnded($0, proxy: proxy) }
    }
    
    private func dragChanged(_ value: DragGesture.Value, proxy: GeometryProxy) {
        
        /// Defines the maximum value of the drag
        /// Avoid dragging more than the values of multiple subviews at the end of the drag,
        /// and still only one subview is toggled
        var offset: CGFloat = aState.itemSize(proxy)
        if value.translation.width > 0 {
            offset = min(offset, value.translation.width)
        } else {
            offset = max(-offset, value.translation.width)
        }
        
        aState.dragChanged(offset)
    }
    
    private func dragEnded(_ value: DragGesture.Value, proxy: GeometryProxy) {
        aState.dragEnded()
        
        /// Defines the drag threshold
        /// At the end of the drag, if the drag value exceeds the drag threshold,
        /// the active view will be toggled
        /// default is one third of subview
        let dragThreshold: CGFloat = aState.itemWidth(proxy) / 3
        
        var activeItem = aState.activeItem
        
        if value.translation.width > dragThreshold {
            activeItem -= 1
        }
        if value.translation.width < -dragThreshold {
            activeItem += 1
        }
        aState.activeItem = max(0, min(activeItem, aState.data.count - 1))
    }
}
 */


// MARK: - App Life Cycle

#if os(macOS)
import AppKit
typealias Application = NSApplication
#else
import UIKit
typealias Application = UIApplication
#endif

/// Monitor and receive application life cycles,
/// inactive or active
@available(iOS 13.0, OSX 10.15, *)
struct AppLifeCycleModifier: ViewModifier {
    
    let active = NotificationCenter.default.publisher(for: Application.didBecomeActiveNotification)
    let inactive = NotificationCenter.default.publisher(for: Application.willResignActiveNotification)
    
    private let action: (Bool) -> ()
    
    init(_ action: @escaping (Bool) -> ()) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content
            .onAppear() /// `onReceive` will not work in the Modifier Without `onAppear`
            .onReceive(active, perform: { _ in
                action(true)
            })
            .onReceive(inactive, perform: { _ in
                action(false)
            })
    }
}

@available(iOS 13.0, OSX 10.15, *)
extension View {
    func onReceiveAppLifeCycle(perform action: @escaping (Bool) -> ()) -> some View {
        self.modifier(AppLifeCycleModifier(action))
    }
}


// MARK: - Receive Timer
@available(iOS 13.0, OSX 10.15, *)
extension View {
    
    func onReceive(timer: TimePublisher?, perform action: @escaping (Timer.TimerPublisher.Output) -> Void) -> some View {
        Group {
            if let timer = timer {
                self.onReceive(timer, perform: { value in
                    action(value)
                })
            } else {
                self
            }
        }
    }
}

@available(iOS 13.0, OSX 10.15, *)
extension ACarousel {
    
    func receiveTimer(_ value: Timer.TimerPublisher.Output) {
        /// Ignores listen when `isTimerActive` is false.
        guard aState.isTimerActive else {
            return
        }
        /// increments of one and compare to the scrolling duration
        aState.activeTiming()
        if aState.timing < aState.autoScroll.interval {
            return
        }
        
        if aState.activeItem == aState.data.count - 1 {
            /// `isWrap` is false.
            /// Revert to the first view after scrolling to the last view
            aState.activeItem = 0
        } else {
            /// `isWrap` is true.
            /// Incremental, calculation of offset by `offsetChanged(_: proxy:)`
            aState.activeItem += 1
        }
        aState.resetTiming()
    }
}

/**
// MARK: - Auto Scroll
@available(iOS 13.0, OSX 10.15, *)
extension ACarousel.AutoScroll {
    
    /// default active
    public static var defaultActive: Self {
        return .active(5)
    }
    
    /// Is the view auto-scrolling
    var isActive: Bool {
        switch self {
        case .active(let t): return t > 0
        case .inactive : return false
        }
    }
    
    /// Duration of automatic scrolling
    var interval: TimeInterval {
        switch self {
        case .active(let t): return t
        case .inactive : return 0
        }
    }
}
 */

/**
// MARK: - State
@available(iOS 13.0, OSX 10.15, *)
final private class AState: ObservableObject {
    
    init(activeItem: Int = 1) {
        self.activeItem = activeItem
    }
    
    /// The index of the currently active subview.
    @Published var activeItem: Int = 1
    
    /// Offset x of the view drag.
    @Published var dragOffset: CGFloat = .zero
    
    
    /// Is animation when view is in offset
    var animation = false
    
    /// Define listen to the timer
    /// Ignores listen while dragging. and listen again after the drag is over
    var isTimerActive = true
    
    /// Counting of time
    /// work when `isTimerActive` is true
    /// Toggles the active subviewview and resets if the count is the same as
    /// the duration of the auto scroll. Otherwise, increment one
    var timing: TimeInterval = 0
    
    /// Action at the end of a view drag
    func dragEnded() {
        dragOffset = .zero
        isTimerActive = true
        resetTiming()
    }
    
    /// Action at the view dragging
    /// - Parameter value: Offset x value of the drag
    func dragChanged(_ value: CGFloat) {
        dragOffset = value
        isTimerActive = false
        animation = true
    }
    
    /// reset counting of time
    func resetTiming() {
        timing = 0
    }
    
    /// Time increments of one
    func activeTiming() {
        timing += 1
    }
}
 */

//@available(iOS 14.0, OSX 11.0, *)
//struct ACarousel_LibraryContent: LibraryContentProvider {
//    let Datas = Array(repeating: _Item(color: .red), count: 3)
//    @LibraryContentBuilder
//    var views: [LibraryItem] {
//        LibraryItem(ACarousel(Datas) { _ in }, title: "ACarousel", category: .control)
//        LibraryItem(ACarousel(Datas, spacing: 10, headspace: 10, sidesScaling: 0.8, isWrap: false, autoScroll: .inactive) { _ in }, title: "ACarousel full parameters", category: .control)
//    }
//
//    struct _Item: Identifiable {
//        let id = UUID()
//        let color: Color
//    }
//}
