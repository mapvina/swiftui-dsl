import SnapshotTesting
import XCTest
@testable import MapVinaSwiftUI

final class CameraPreviewTests: XCTestCase {
    func testCameraPreview() {
        assertView {
            CameraDirectManipulationPreview(
                styleURL: URL(string: "https://maps.mapvina.com/styles/v1/streets.json?key=public_key")!
            )
        }
    }
}
