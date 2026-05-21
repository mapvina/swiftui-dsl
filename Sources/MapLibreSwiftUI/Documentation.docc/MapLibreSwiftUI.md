# ``MapVinaSwiftUI``

A SwiftUI framework for Mapvina Native iOS. Provides declarative methods for MapVina inspired by default SwiftUI functionality.

## Overview

```swift
struct MyView: View {
    
    @State var camera: MapViewCamera = .default()

    var body: some View {
        MapView(
            styleURL: URL(string: "https://maps.mapvina.com/styles/v1/streets.json?key=public_key")!,
            camera: $camera
        ) {
            // Declarative overlay features.
        }
        .onTapMapGesture { context in 
            // Handle tap gesture context
        }
    }
}
```

## Topics

### MapView

- ``MapView``

### MapViewCamera

- ``MapViewCamera``
- ``CameraState``
- ``CameraPitch``
- ``CameraChangeReason``

