# Layer Explosion (SwiftUI)

This is a SwiftUI library that adds a pseudo-3d effect to your views, imitating the View Debugger for Xcode and UIKit.

## How to use

### Parallax gestures
To create a "parallax context" you use `.parallaxTouchGesture()` as a view modifier. This works like other gestures, getting drag gestures withing the view bounds, but it also makes that view a parallax layer which means it will also be rotated on the gesture.

```swift
var body: some View {
    VStack {
        Text("Child View").padding()
    }
    .parallaxTouchGesture() // Dragging within this view will rotate it
}
```

Additionally, you can use `.parallaxMotionGesture()` to control the effect using the device's rotation.

```swift
var body: some View {
    VStack {
        Text("Child View").padding()
    }
    .parallaxMotionGesture(strength: 0.2) // Dragging within this view will rotate it
}
```

To control how sensitive the effect is, you can call the modifiers with `strength: <Double>`, `1` being the normal sensitivity. This works for both gesture modifiers.

### Parallax Layer
After using `parallaxTouchGesture`, you can add `.parallaxLayer()` to any child view, which separates a view from it's parent. That also moves the view along the "z-axis", but because of the way it's rendered it actually doesn't change size on the screen.

```swift
var body: some View {
    VStack {
        VStack {
            Text("Nested Layer")
                .padding()
                .parallaxLayer() // This is the 3rd layer
        }
        .padding()
        .parallaxLayer() // This would be the 2nd layer (after the one from gesture)
    }
    .parallaxTouchGesture(strength: 0.2)
}
```

In the case of `ZStack` you need to separate the views some other way, because nesting alone doesn't tell you how the views are rendered. So you can add a `zIndex: <Int>` parameter to the call; that sets a relative layer separation between sibling views.

```swift
var body: some View {
    ZStack {
        Color.blue // Background
            .parallaxLayer(zIndex: 0) // This is the same as `.parallaxLayer()`
            
        Text("Content") // Foreground
            .padding()
            .parallaxLayer(zIndex: 1) // This would mean `Text` is a child of `Color.blue`
    }
    .parallaxTouchGesture(strength: 0.2)
}
```

## Current Problems

A few. I'll update this section later. 
