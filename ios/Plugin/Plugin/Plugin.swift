import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitor.ionicframework.com/docs/plugins/ios
 */
@objc(ShareExtension)
public class ShareExtension: CAPPlugin {
    
    @objc func saveDataToNativeUserDefaults(_ call: CAPPluginCall) {

        guard let key = call.options["key"] as? String else {
            call.reject("Must provide a key")
            return
        }

        guard let data = call.options["data"] else {
            call.reject("Must provide data")
            return
        }

        print("[Share Extension Plugin Native iOS]: saving... ", key, data);

        let defaults = UserDefaults(suiteName: "group.com.restvo.app");
        defaults?.set(data, forKey: key); // I can save simple data type with user defaults, but not JSON objects

        let read = UserDefaults(suiteName: "group.com.restvo.app")
        let x = read?.object(forKey: key)

        print("[Share Extension Plugin Native iOS]: reading... ", key);

        call.resolve([
           "success": true
        ])
    }

    @objc func loadDataFromNativeUserDefaults(_ call: CAPPluginCall) {

        guard let key = call.options["key"] as? String else {
                    call.reject("Must provide a key")
                    return
                }

        let defaults = UserDefaults(suiteName: "group.com.restvo.app")
        let x = defaults?.object(forKey: key)
        print(x) //read back the data to console log

        call.resolve([
           "success": true
        ])
    }

    @objc func clearNativeUserDefaults(_ call: CAPPluginCall) {

        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!) // remove user defaults storage
        UserDefaults.standard.synchronize()

        let read = UserDefaults(suiteName: "group.com.restvo.app") // try to check if the data persists after clear
        let x = read?.object(forKey: "user") // it should return nil

        print("[Share Extension Plugin Native iOS]: clear storage result: ", x!); // print out the test result

        call.resolve([
           "success": true
        ])
    }
}
