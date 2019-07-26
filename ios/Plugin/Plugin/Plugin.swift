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
        //defaults?.set(data, forKey: key); // I can save simple data type with user defaults, but not JSON objects

        let read = UserDefaults(suiteName: "group.com.restvo.app")
        let x = read?.object(forKey: key)

        print("[Share Extension Plugin Native iOS]: reading... ", key);

        call.resolve([
           "success": true
        ])
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
            print(key)
            if let dataFromString = (data as! String).data(using: String.Encoding.utf8, allowLossyConversion: false) {
                        print(dataFromString)
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
                        }
                        else{
                            print("Write Success")
                        }
                    }
            else{
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
        //print(status)
        //print(dataTypeRef)
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? Data {
                contentsOfKeychain = String(data: retrievedData, encoding: String.Encoding.utf8)
            }
            else{
                print("Error converting data. Status code \(status)")
            }
        }
        else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
        }
        print(contentsOfKeychain)
        

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

        UserDefaults.standard.removePersistentDomain(forName: "group.com.restvo.app") // remove user defaults storage
        UserDefaults.standard.synchronize()

        call.resolve([
           "success": true
        ])
    }
}
