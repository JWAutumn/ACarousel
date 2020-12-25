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
class ACarouselViewModel<Data, ID>: ObservableObject where Data : RandomAccessCollection, ID : Hashable {
    
    
    /// The index of the currently active subview.
    @Published var activeItem: Int = 0 {
        willSet {
            if isWrap {
                _activeIndex.wrappedValue = newValue - 1
            } else {
                _activeIndex.wrappedValue = newValue
            }
        }
    }
    
    /// Offset x of the view drag.
    @Published var dragOffset: CGFloat = .zero
    
    /// Is animation when view is in offset
    var isAnimationOffset = false
    
    /// Define listen to the timer
    /// Ignores listen while dragging. and listen again after the drag is over
    var isTimerActive = true
    
    /// Counting of time
    /// work when `isTimerActive` is true
    /// Toggles the active subviewview and resets if the count is the same as
    /// the duration of the auto scroll. Otherwise, increment one
    var timing: TimeInterval = 0
    
    /// size of GeometryProxy
    var viewSize: CGSize = .zero {
        didSet {
            print(viewSize)
        }
    }
    
    var timer: TimePublisher?
    
    @Binding
    private var activeIndex: Int
    
    private let _data: Data
    private let _dataId: KeyPath<Data.Element, ID>
    private let _spacing: CGFloat
    private let _headspace: CGFloat
    private let _isWrap: Bool
    private let _sidesScaling: CGFloat
    private let _autoScroll: AutoScroll
    
    init(_ data: Data,
         id: KeyPath<Data.Element, ID>,
         activeIndex: Binding<Int> = .constant(0),
         spacing: CGFloat = 10,
         headspace: CGFloat = 10,
         sidesScaling: CGFloat = 0.8,
         isWrap: Bool = false,
         autoScroll: AutoScroll = .inactive) {
        
        self._data = data
        self._dataId = id
        self._spacing = spacing
        self._headspace = headspace
        self._isWrap = isWrap
        self._sidesScaling = sidesScaling
        self._autoScroll = autoScroll
        
        if data.count > 0 && isWrap {
            activeItem = activeIndex.wrappedValue + 1
        } else {
            activeItem = activeIndex.wrappedValue
        }
        self._activeIndex = activeIndex
        
        if self.autoScroll.isActive {
            timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        }
    }
}


extension ACarouselViewModel where ID == Data.Element.ID, Data.Element : Identifiable {
    
    convenience init(_ data: Data,
                     spacing: CGFloat = 10,
                     activeIndex: Binding<Int>,
                     headspace: CGFloat = 10,
                     sidesScaling: CGFloat = 0.8,
                     isWrap: Bool = false,
                     autoScroll: AutoScroll = .inactive) {
        self.init(data,
                  id: \Data.Element.id,
                  activeIndex: activeIndex,
                  spacing: spacing,
                  headspace: headspace,
                  sidesScaling: sidesScaling,
                  isWrap: isWrap,
                  autoScroll: autoScroll)
    }
}


extension ACarouselViewModel {
    
    var data: Data {
        guard _data.count != 0 else {
            return _data
        }
        guard _data.count > 1 else {
            return _data
        }
        guard isWrap else {
            return _data
        }
        return [_data.last!] + _data + [_data.first!] as! Data
    }
    
    var spacing: CGFloat {
        return _spacing
    }
    
    var headspace: CGFloat {
        return _headspace
    }
    
    var sidesScaling: CGFloat {
        return max(min(_sidesScaling, 1), 0)
    }
    
    var isWrap: Bool {
        return _data.count > 1 ? _isWrap : false
    }
    
    var autoScroll: AutoScroll {
        guard _data.count > 1 else { return .inactive }
        guard case let .active(t) = _autoScroll else { return _autoScroll }
        return t > 0 ? _autoScroll : .defaultActive
    }
    
    var offsetAnimation: Animation? {
//        guard isWrap else {
//            return .spring()
//        }
//
//        return (activeItem == 1 || activeItem == data.count - 2) ? .none : .spring()
        return isAnimationOffset ? .spring() : .none
    }
    
    var defaultPadding: CGFloat {
        return (headspace + spacing)
    }
    
    /// with of subview
    func itemWidth(_ proxy: GeometryProxy) -> CGFloat {
        proxy.size.width - defaultPadding * 2
    }
    
    func itemSize(_ proxy: GeometryProxy) -> CGFloat {
        itemWidth(proxy) + spacing
    }
}


extension ACarouselViewModel where ID == Data.Element.ID, Data.Element : Identifiable {
    func itemScale(_ item: Data.Element) -> CGFloat {
        guard activeItem < data.count else {
            return 0
        }
        return _dataId == \Data.Element.id ? 1 : sidesScaling
    }
}

extension ACarouselViewModel {
    
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
        isAnimationOffset = true
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

// MARK: - Offset Method
extension ACarouselViewModel {
    
    func offsetValue(_ proxy: GeometryProxy) -> CGFloat {
        let activeOffset = CGFloat(activeItem) * itemSize(proxy)
        let value = defaultPadding - activeOffset + dragOffset
        return value
    }
    
    func offsetChanged(_ newOffset: CGFloat, proxy: GeometryProxy) {
        isAnimationOffset = true
        guard isWrap else {
            return
        }
        let minOffset = defaultPadding
        let maxOffset = (defaultPadding - CGFloat(data.count - 1) * itemSize(proxy))
        if newOffset == minOffset {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.activeItem = self.data.count - 2
                self.isAnimationOffset = false
            }
        } else if newOffset == maxOffset {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.activeItem = 1
                self.isAnimationOffset = false
            }
        }
    }
}

// MARK: - Drag Method
extension ACarouselViewModel {
    func dragGesture(_ proxy: GeometryProxy) -> some Gesture {
        DragGesture()
            .onChanged { self.dragChanged($0, proxy: proxy) }
            .onEnded { [self] in dragEnded($0, proxy: proxy) }
    }
    
    func dragChanged(_ value: DragGesture.Value, proxy: GeometryProxy) {
        
        /// Defines the maximum value of the drag
        /// Avoid dragging more than the values of multiple subviews at the end of the drag,
        /// and still only one subview is toggled
        var offset: CGFloat = itemSize(proxy)
        if value.translation.width > 0 {
            offset = min(offset, value.translation.width)
        } else {
            offset = max(-offset, value.translation.width)
        }
        
        dragChanged(offset)
    }
    
    func dragEnded(_ value: DragGesture.Value, proxy: GeometryProxy) {
        dragEnded()
        
        /// Defines the drag threshold
        /// At the end of the drag, if the drag value exceeds the drag threshold,
        /// the active view will be toggled
        /// default is one third of subview
        let dragThreshold: CGFloat = itemWidth(proxy) / 3
        
        var activeItem = self.activeItem
        
        if value.translation.width > dragThreshold {
            activeItem -= 1
        }
        if value.translation.width < -dragThreshold {
            activeItem += 1
        }
        self.activeItem = max(0, min(activeItem, data.count - 1))
    }
}
