# WheelScroll
SwiftUI ScrollView with custom transitions for **iOS 17**.

<p align="center">
    <img src="https://github.com/leekurg/WheelScroll/assets/105886145/49bca53b-d218-4eee-96ef-300f5f9a55aa" width="300">
</p>

### Overview
`WheelScroll` created to demonstrate new cool features of `SwiftUI` for iOS 17. To simulate this parallax transition I used new powerful `ScrollView`'s API for content transitions `scrollTransition()`.

### Install
To install as package with `SPM`: in **Xcode** tap «**File → Add packages…**», paste `https://github.com/leekurg/WheelScroll` is search field the URL of this page and press «**Add package**».

### Usage
```
var body: some View {
    WheelScroll(axis: .vertical, contentSpacing: 10) {
        ForEach(0...10, id: \.self) { index in
            Card()
        }
    }
}
```
