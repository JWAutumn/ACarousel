# ACarousel

`SwiftUI` 旋转木马效果

[English Version](README.md) | [详细解析](https://juejin.cn/post/6898258968775245837)

<p align="center">
<img src='https://img.shields.io/badge/Swift-5.1-green?style=flat'>
<img src='https://img.shields.io/badge/platform-iOS%20%7C%20macOS-lightgray.svg?style=flat'>
<img src='https://img.shields.io/badge/SMP-Supported-orange?style=flat'>
<img src='https://img.shields.io/github/license/JWAutumn/ACarousel'>
</p>

<p align="center">
<img src='Resource/iPhoneDemo.gif' width='260'>&nbsp&nbsp&nbsp
<img src='Resource/MacDemo.gif' width='350'>
</p>

## 内容列表

  - [要求](#要求)
  - [安装](#安装)
  - [使用说明](#使用说明)
  - [示例](#示例)
  - [维护者](#维护者)
  - [如何贡献](#如何贡献)
  - [使用许可](#使用许可)


## 要求

- iOS 13.0+ / macOS 10.15+ / tvOS 13.0+
- Xcode 11.0+
- Swift 5.1+


## 安装

### Swift Package Manager

打开 `Xcode`， 选择 `File -> Swift Packages -> Add Package Dependency`，输入 `https://github.com/JWAutumn/ACarousel`

也可以将 `ACarousel` 作为依赖添加项到你的 `Package.swift` 中:
```swift
dependencies: [
  .package(url: "https://github.com/JWAutumn/ACarousel", from: "0.2.0")
]
```

### 手动安装

[下载](https://github.com/JWAutumn/ACarousel/archive/main.zip)并打开项目，把 `ACarousel.swift` 文件拖入到你自己的项目当中。

当然，你也可以根据特定需求修改代码。


## 使用说明

 - 基础使用：`ACarousel` 的参数有默认值，你只需要简单的传入数据源即可食用~
```swift
struct Item: Identifiable {
    let id = UUID()
    let image: Image
}

let roles = ["Luffy", "Zoro", "Sanji", "Nami", "Usopp", "Chopper", "Robin", "Franky", "Brook"]

struct ContentView: View {
    
    let items: [Item] = roles.map { Item(image: Image($0)) }
    
    var body: some View {
        ACarousel(items) { item in
            item.image
                .resizable()
                .scaledToFill()
                .frame(height: 300)
                .cornerRadius(30)
        }
        .frame(height: 300)
    }
}
```

或者:

```swift
...
var body: some View {
    ACarousel(roles, id: \.self) { name in
        Image(name)
            .resizable()
            .scaledToFill()
            .frame(height: 300)
            .cornerRadius(30)
    }
    .frame(height: 300)
}
...
```

- 自定义参数：根据自身需求，你可以修改相应的参数来自定义显示样式。
```swift
 /// ...

struct ContentView: View {
    
    let items: [Item] = roles.map { Item(image: Image($0)) }
    
    var body: some View {
        ACarousel(items,
                  spacing: 10,
                  headspace: 10,
                  sidesScaling: 0.7,
                  isWrap: true,
                  autoScroll: .active(2)) { item in
            item.image
                .resizable()
                .scaledToFill()
                .frame(height: 300)
                .cornerRadius(30)
        }
        .frame(height: 300)
    }
}
```


## 示例

[下载](https://github.com/JWAutumn/ACarousel/archive/main.zip)项目，打开 `ACarouselDemo -> ACarouselDemo.xcodeproj` 运行并查看


## 维护者

[@JWAutumn](https://github.com/JWAutumn)。

## 如何贡献

非常欢迎你的加入！[提一个 Issue](https://github.com/JWAutumn/ACarousel/issues/new) 或者提交一个 Pull Request。



## 使用许可

[MIT](LICENSE) © JWAutumn
