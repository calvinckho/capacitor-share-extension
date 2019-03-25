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

        let defaults = UserDefaults(suiteName: "group.com.restvo.app");
        defaults?.set(data, forKey: key);

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
        let x = defaults?.double(forKey: key)
        print(x)

        call.resolve([
           "success": true
        ])
    }
}
