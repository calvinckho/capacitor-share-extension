import XCTest
import Capacitor
@testable import CapacitorShareExtension

class ShareExtensionTests: XCTestCase {

    func testStoreSharesStateAcrossReferences() {
        // The host app's AppDelegate writes share items into the store and the
        // plugin reads them back out, so both must see the same instance.
        let writer = ShareStore.store
        let reader = ShareStore.store

        writer.shareItems = []
        writer.processed = false

        var item = JSObject()
        item["title"] = "shared"
        writer.shareItems.append(item)
        writer.processed = true

        XCTAssertIdentical(writer, reader)
        XCTAssertEqual(reader.shareItems.count, 1)
        XCTAssertEqual(reader.shareItems.first?["title"] as? String, "shared")
        XCTAssertTrue(reader.processed)
    }

    func testPluginExposesItsBridgedMethods() {
        let plugin = ShareExtension()

        XCTAssertEqual(plugin.jsName, "ShareExtension")
        XCTAssertEqual(plugin.identifier, "ShareExtension")
        XCTAssertEqual(
            Set(plugin.pluginMethods.map { $0.name }),
            ["checkSendIntentReceived", "finish", "saveDataToKeychain", "clearKeychainData"]
        )
    }
}
