# ACarousel

A carousel view for SwiftUI

[中文文档](README.zh-CN.md)

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

## Table of Contents

  - [Requirements](#requirements)
  - [Install](#install)
  - [Usage](#usage)
  - [Example](#example)
  - [Maintainers](#maintainers)
  - [Contributing](#contributing)
  - [License](#license)


## Requirements

- iOS 13.0+ / macOS 10.15+ / tvOS 13.0+
- Xcode 11.0+
- Swift 5.1+


## Install

### Swift Package Manager

Open `Xcode`, go to `File -> Swift Packages -> Add Package Dependency` and enter `https://github.com/JWAutumn/ACarousel`

You can also add `ACarousel` as a dependency to your `Package.swift`:
```swift
dependencies: [
  .package(url: "https://github.com/JWAutumn/ACarousel", from: "0.2.0")
]
```

### Manually

[Download](https://github.com/JWAutumn/ACarousel/archive/main.zip) and open the project, drag the `ACarousel.swift` file into your own project.

## Usage

- Basic use: The parameters of `ACarousel` have default values, so you can simply pass in the data source and eat it ~
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
or:
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
- Customize configuration: You can configure the corresponding parameters to customize the display style according to your needs.
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


## Example
[Download](https://github.com/JWAutumn/ACarousel/archive/main.zip) and open `ACarouselDemo -> ACarouselDemo.xcodeproj`, run and view.

## Maintainers

[@JWAutumn](https://github.com/JWAutumn).


## Contributing

Feel free to dive in! [Open an issue](https://github.com/JWAutumn/ACarousel/issues/new) or submit PRs.


## License

[MIT](LICENSE) © JWAutumn
