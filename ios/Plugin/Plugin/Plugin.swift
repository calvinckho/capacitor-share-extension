import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitor.ionicframework.com/docs/plugins/ios
 */
@objc(ShareExtension)
public class ShareExtension: CAPPlugin {

    let store = ShareStore.store

    @objc func checkSendIntentReceived(_ call: CAPPluginCall) {
        print("ios checking send intent")
        if !store.processed {
            let firstItem: JSObject? = store.shareItems.first
            let additionalItems: Array<JSObject> = store.shareItems.count > 1 ? Array(store.shareItems[1...]) : []

            call.resolve([
                "title": firstItem?["title"] ?? "",
                "description": firstItem?["description"] ?? "",
                "type": firstItem?["type"] ?? "",
                "url": firstItem?["url"] ?? "",
                "webPath": firstItem?["webPath"] ?? "",
                "additionalItems": additionalItems
            ])
            store.processed = true
        } else {
            call.reject("No processing needed.")
        }
    }

    @objc func finish(_ call: CAPPluginCall) {
        call.resolve();
    }

    public override func load() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(eval), name: Notification.Name("triggerSendIntent"), object: nil)
    }

    @objc open func eval(){
        self.bridge?.eval(js: "window.dispatchEvent(new Event('sendIntentReceived'))");
    }

    @objc func saveDataToKeychain(_ call: CAPPluginCall) {

            guard let key = call.options["key"] as? String else {
                call.reject("Must provide a key")
                return
            }

            guard let data = call.options["data"] else {
                call.reject("Must provide data")
                return
            }

            print("[Share Extension Plugin Native iOS]: saving to keychain... ", key, data);

            if let dataFromString = (data as! String).data(using: String.Encoding.utf8, allowLossyConversion: false) {
                //print(dataFromString)
                // Instantiate a new default keychain query
                let keychainQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                                    kSecAttrService as String: key,
                                                    kSecValueData as String: dataFromString
                ]

                SecItemDelete(keychainQuery as CFDictionary)
                // Add the new keychain item
                let status = SecItemAdd(keychainQuery as CFDictionary, nil)

                if (status != errSecSuccess) {    // Always check the status
                    /*if let err = SecCopyErrorMessageString(status, nil) {
                        print("Write failed: \(err)")
                    }*/
                    print("Write failed")
                } else {
                    print("Write Success")
                }
            } else {
                print("dataFromString failed")
            }
        
        let getquery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecAttrService as String: key,
                                       //kSecAttrAccount as String: "account",
                                       //kSecReturnRef as String: kCFBooleanTrue,
                                       kSecReturnData as String: kCFBooleanTrue,
                                       kSecMatchLimit as String  : kSecMatchLimitOne
        ]
        
        var dataTypeRef :AnyObject?
        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(getquery as CFDictionary, &dataTypeRef)
        
        var contentsOfKeychain: String?
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? Data {
                contentsOfKeychain = String(data: retrievedData, encoding: String.Encoding.utf8)
            } else {
                print("Error converting data. Status code \(status)")
            }
        }
        else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
        }
        call.resolve()
    }

    @objc func clearKeychainData(_ call: CAPPluginCall) {

        guard let key = call.options["key"] as? String else {
            call.reject("Must provide a key")
            return
        }

        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                       kSecAttrService as String: key
        ]
        let status: OSStatus = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess || status == errSecItemNotFound {
            call.resolve()
        } else {
            call.reject("Failed to clear keychain entry for key ", key)
        }
    }
}
