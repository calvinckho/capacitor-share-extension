<p align="center">
    <img width="150px" src="https://user-images.githubusercontent.com/13732623/63229908-7d8a8100-c1d3-11e9-955e-31aff33d07e1.png">
</p>

# @calvinckho/capacitor-share-extension

<img src="https://img.shields.io/npm/v/capacitor-share-extension?style=flat-square" />

This Capacitor Plugin provides native capabilities to retrieve media files sent via iOS Share Extension and Android Send Intent events

## Compatibility to Capacitor Versions

<table>
  <thead>
    <tr>
      <th>Capacitor</th>
      <th>branch</th>
      <th>npm</th>
      <th>supported</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>
        v6
      </td>
      <td>
        #capacitor-6
      </td>
      <td>
        4.x - 6.x
      </td>
      <td>
        current
      </td>
    </tr>
    <tr>
      <td>
        v5
      </td>
      <td>
        #capacitor-5
      </td>
      <td>
        3.x
      </td>
      <td>
        until May 31, 2024
      </td>
    </tr>
    <tr>
      <td>
        v4
      </td>
      <td>
        #capacitor-4
      </td>
      <td>
        2.x
      </td>
      <td>
        until May 31, 2023
      </td>
    </tr>
    <tr>
      <td>
        v3
      </td>
      <td>
        #capacitor-3
      </td>
      <td>
        1.x
      </td>
      <td>
        until May 31, 2023
      </td>
    </tr>
    <tr>
      <td>
        v2
      </td>
      <td>
        #capacitor-2
      </td>
      <td>
        0.x
      </td>
      <td>
        until May 31, 2023
      </td>
    </tr>
  </tbody>
</table>

## Installation

### Github Branch
```
npm i git+ssh://git@github.com/calvinckho/capacitor-share-extension#[branch-name]]
```

### NPM

```
npm i capacitor-share-extension@[version number]
```

## Usage

Capacitor 3+:
```ts
import { ShareExtension } from 'capacitor-share-extension';
```

```ts
// run this as part of the app launch
if (this.platform.is('cordova') && Capacitor.isPluginAvailable('ShareExtension')) {
    window.addEventListener('sendIntentReceived',  () => {
        this.checkIntent();
    });
    this.checkIntent();
}

async checkIntent() {
    try {
        const result: any = await ShareExtension.checkSendIntentReceived();
        /* sample result::
        { payload: [
            {
                "type":"image%2Fjpg",
                "description":"",
                "title":"IMG_0002.JPG",
                // url contains a full, platform-specific file URL that can be read later using the Filsystem API.
                "url":"file%3A%2F%2F%2FUsers%2Fcalvinho%2FLibrary%2FDeveloper%2FCoreSimulator%2FDevices%2FE4C13502-3A0B-4DF4-98ED-9F31DDF03672%2Fdata%2FContainers%2FShared%2FAppGroup%2FF41DC1F5-54D7-4EC5-9785-5248BAE06588%2FIMG_0002.JPG",
                // webPath returns a path that can be used to set the src attribute of an image for efficient loading and rendering.
                "webPath":"capacitor%3A%2F%2Flocalhost%2F_capacitor_file_%2FUsers%2Fcalvinho%2FLibrary%2FDeveloper%2FCoreSimulator%2FDevices%2FE4C13502-3A0B-4DF4-98ED-9F31DDF03672%2Fdata%2FContainers%2FShared%2FAppGroup%2FF41DC1F5-54D7-4EC5-9785-5248BAE06588%2FIMG_0002.JPG",
            }]
         } 
         */
        if (result && result.payload && result.payload.length) {
            console.log('Intent received: ', JSON.stringify(result));
        }
    } catch (err) {
        console.log(err);
    }
}

// in Android, call finish when done processing the Intent
await ShareExtension.finish()

// iOS keychain methods
try {
    // load an authentication token
    const token = 'token XXYYZZ';
    // use the extension to save the auth token to iOS Keychain
    await ShareExtension.saveDataToKeychain({ key: 'token', data: token });
} catch (err) {
    console.log(err);
}

// when user is about to log out, remove the token from iOS Keychain
try {
    await ShareExtension.clearKeychainData( { key: 'token' });
} catch (err) {
    console.log(err);
}

```

## **Android**

Configure AndroidManifest.xml to allow file types to be received by your main app. See [here](https://developer.mozilla.org/en-US/docs/Web/HTTP/Basics_of_HTTP/MIME_types/Common_types) for a list of available mimeTypes.

```xml
<activity
        android:name="com.myown.app.MainActivity"
        android:label="@string/app_name"
        android:exported="true"
        android:theme="@style/AppTheme.NoActionBar">
    <intent-filter>
        <action android:name="android.intent.action.SEND" />
        <action android:name="android.intent.action.SEND_MULTIPLE" />
        <category android:name="android.intent.category.DEFAULT" />
        <data android:mimeType="text/plain" />
        <data android:mimeType="image/*" />
        <data android:mimeType="application/pdf" />
        <data android:mimeType="application/msword" />
        <data android:mimeType="application/vnd.openxmlformats-officedocument.wordprocessingml.document" />
        <data android:mimeType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" />
        <data android:mimeType="application/vnd.openxmlformats-officedocument.presentationml.presentation" />
    </intent-filter>
</activity>

```

Update your Android main app's /android/app/src/main/java/.../MainActivity.java with these code:
```java
package com.myown.app;
import com.getcapacitor.BridgeActivity;

+import android.content.Intent;
+import android.webkit.ValueCallback;

public class MainActivity extends BridgeActivity {
   @Override
   public void onCreate(Bundle savedInstanceState) {
     super.onCreate(savedInstanceState);
     ...
   }
   
+  @Override
+  protected void onNewIntent(Intent intent) {
+    super.onNewIntent(intent);
+    String action = intent.getAction();
+    String type = intent.getType();
+    if ((Intent.ACTION_SEND.equals(action) || Intent.ACTION_SEND_MULTIPLE.equals(action)) && type != null) {
+      bridge.getActivity().setIntent(intent);
+      bridge.eval("window.dispatchEvent(new Event('sendIntentReceived'))", new ValueCallback<String>() {
+        @Override
+        public void onReceiveValue(String s) {
+        }
+      });
+    }
+  }
}

```


On Android, after having processed the Send Intent in your app, it is a good practice to end the Intent using the finish() method. Not doing
so can lead to app state issues (because you have two instances running) or trigger the same intent again if your app
reloads from idle mode.

```js
ShareExtension.finish();
```

## **iOS**

Create a new "Share Extension" in Xcode ([Creating an App extension](https://developer.apple.com/library/archive/documentation/General/Conceptual/ExtensibilityPG/ExtensionCreation.html#//apple_ref/doc/uid/TP40014214-CH5-SW1))

Set the activation rules in the extension's Info.plist, so that your app will be displayed as an option in the share view. To add more types, see [here](https://developer.apple.com/documentation/uniformtypeidentifiers/system_declared_uniform_type_identifiers).

```
...
<key>NSExtensionAttributes</key>
<dict>
    <key>NSExtensionActivationRule</key>
        <string>SUBQUERY (
              extensionItems,
              $extensionItem,
              SUBQUERY (
                  $extensionItem.attachments,
                  $attachment,
                   ANY $attachment.registeredTypeIdentifiers UTI-CONFORMS-TO "public.image" ||
                           ANY $attachment.registeredTypeIdentifiers UTI-CONFORMS-TO "public.spreadsheet" ||
                           ANY $attachment.registeredTypeIdentifiers UTI-CONFORMS-TO "public.presentation" ||
                           ANY $attachment.registeredTypeIdentifiers UTI-CONFORMS-TO "org.openxmlformats.wordprocessingml.document" ||
                           ANY $attachment.registeredTypeIdentifiers UTI-CONFORMS-TO "com.adobe.pdf" ||
                           ANY $attachment.registeredTypeIdentifiers UTI-CONFORMS-TO "public.png" ||
                           ANY $attachment.registeredTypeIdentifiers UTI-CONFORMS-TO "public.jpeg" ||
                           ANY $attachment.registeredTypeIdentifiers UTI-CONFORMS-TO "public.jpeg-2000" ||
                           ANY $attachment.registeredTypeIdentifiers UTI-CONFORMS-TO "public.plain-text" ||
                           ANY $attachment.registeredTypeIdentifiers UTI-CONFORMS-TO "public.url" ||
                           ANY $attachment.registeredTypeIdentifiers UTI-CONFORMS-TO "com.compuserve.gif"
                ).@count == $extensionItem.attachments.@count
                ).@count == 1
        </string>
</dict>
...            
```
Overwrite ShareViewController.swift with this code. In Target - [This Extension's Name] - Build Settings, set the iOS Deployment Target to iOS 13 or higher, as the syntax in the following code is not compatible with older iOS version.

```swift
import UIKit
import Social
import MobileCoreServices
import Foundation.NSURLSession

class ShareItem {
    public var title: String?
    public var type: String?
    public var url: String?
    public var webPath: String?
}

class ShareViewController:  UIViewController {
    private var shareItems: [ShareItem] = []
    override public func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
       self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        shareItems.removeAll()
        let extensionItem = extensionContext?.inputItems[0] as! NSExtensionItem
        Task {
            try await withThrowingTaskGroup(
                of: ShareItem.self,
                body: { taskGroup in
                    for attachment in extensionItem.attachments! {
                        if attachment.hasItemConformingToTypeIdentifier(kUTTypeURL as String) {
                            taskGroup.addTask {
                                return try await self.handleTypeUrl(attachment)
                            }
                        } else if attachment.hasItemConformingToTypeIdentifier(kUTTypeText as String) {
                            taskGroup.addTask {
                                return try await self.handleTypeText(attachment)
                            }
                        } else if attachment.hasItemConformingToTypeIdentifier(kUTTypeMovie as String) {
                            taskGroup.addTask {
                                return try await self.handleTypeMovie(attachment)
                            }
                        } else if attachment.hasItemConformingToTypeIdentifier(kUTTypeImage as String) {
                            taskGroup.addTask {
                                return try await self.handleTypeImage(attachment)
                            }
                        }
                    }
                    for try await item in taskGroup {
                        self.shareItems.append(item)
                    }
                })
            self.sendData()
        }
    }
    
    private func sendData() {
        let queryItems = shareItems.map {
            [
                URLQueryItem(
                    name: "title",
                    value: $0.title?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""),
                URLQueryItem(name: "description", value: ""),
                URLQueryItem(
                    name: "type",
                    value: $0.type?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""),
                URLQueryItem(
                    name: "url",
                    value: $0.url?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""),
                URLQueryItem(
                    name: "webPath",
                    value: $0.webPath?.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "")
            ]
        }.flatMap({ $0 })
        var urlComps = URLComponents(string: "restvo://;")!
        urlComps.queryItems = queryItems
        openURL(urlComps.url!)
    }
    
    fileprivate func createSharedFileUrl(_ url: URL?) -> String {
        let fileManager = FileManager.default
        print("share url: " + url!.absoluteString)
        let copyFileUrl =
        fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.com.restvo.test")!
            .absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! + url!
            .lastPathComponent.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        try? Data(contentsOf: url!).write(to: URL(string: copyFileUrl)!)
        
        return copyFileUrl
    }
    
    func saveScreenshot(_ image: UIImage) -> String {
        let fileManager = FileManager.default
        
        let copyFileUrl =
        fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.com.restvo.test")!
            .absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        + "/screenshot.png"
        do {
            try image.pngData()?.write(to: URL(string: copyFileUrl)!)
            return copyFileUrl
        } catch {
            print(error.localizedDescription)
            return ""
        }
    }
    
    fileprivate func handleTypeUrl(_ attachment: NSItemProvider)
    async throws -> ShareItem
    {
        let results = try await attachment.loadItem(forTypeIdentifier: kUTTypeURL as String, options: nil)
        let url = results as! URL?
        let shareItem: ShareItem = ShareItem()
        
        if url!.isFileURL {
            shareItem.title = url!.lastPathComponent
            shareItem.type = "application/" + url!.pathExtension.lowercased()
            shareItem.url = createSharedFileUrl(url)
            shareItem.webPath = "capacitor://localhost/_capacitor_file_" + URL(string: shareItem.url ?? "")!.path
        } else {
            shareItem.title = url!.absoluteString
            shareItem.url = url!.absoluteString
            shareItem.webPath = url!.absoluteString
            shareItem.type = "text/plain"
        }
        return shareItem
    }
    
    fileprivate func handleTypeText(_ attachment: NSItemProvider)
    async throws -> ShareItem
    {
        let results = try await attachment.loadItem(forTypeIdentifier: kUTTypeText as String, options: nil)
        let shareItem: ShareItem = ShareItem()
        let text = results as! String
        shareItem.title = text
        shareItem.type = "text/plain"
        return shareItem
    }
    
    fileprivate func handleTypeMovie(_ attachment: NSItemProvider)
    async throws -> ShareItem
    {
        let results = try await attachment.loadItem(forTypeIdentifier: kUTTypeMovie as String, options: nil)
        let shareItem: ShareItem = ShareItem()
        let url = results as! URL?
        shareItem.title = url!.lastPathComponent
        shareItem.type = "video/" + url!.pathExtension.lowercased()
        shareItem.url = createSharedFileUrl(url)
        shareItem.webPath = "capacitor://localhost/_capacitor_file_" + URL(string: shareItem.url ?? "")!.path
        return shareItem
    }
    
    fileprivate func handleTypeImage(_ attachment: NSItemProvider)
    async throws -> ShareItem
    {
        let data = try await attachment.loadItem(forTypeIdentifier: kUTTypeImage as String, options: nil)
        let shareItem: ShareItem = ShareItem()
        switch data {
        case let image as UIImage:
            shareItem.title = "screenshot"
            shareItem.type = "image/png"
            shareItem.url = self.saveScreenshot(image)
            shareItem.webPath = "capacitor://localhost/_capacitor_file_" + URL(string: shareItem.url ?? "")!.path
        case let url as URL:
            shareItem.title = url.lastPathComponent
            shareItem.type = "image/" + url.pathExtension.lowercased()
            shareItem.url = self.createSharedFileUrl(url)
            shareItem.webPath = "capacitor://localhost/_capacitor_file_" + URL(string: shareItem.url ?? "")!.path
        default:
            print("Unexpected image data:", type(of: data))
        }
        return shareItem
    }

    // Older versions of this plugin used a different implementation for openURL. This version
    // works with iOS 18.
    // recommended for example here: https://stackoverflow.com/questions/79002378/ios-18-0-shared-extention-open-app-url-cant-work
    @objc func openURL(_ url: URL) -> Bool {
        var responder: UIResponder? = self
        while responder != nil {
            if let application = responder as? UIApplication {
                application.open(url, options: [:]) { success in
                    if success {
                        print("App opened successfully")
                    } else {
                        print("Failed to open app")
                    }
                }
                return true
            }
            responder = responder?.next
        }
        return false
    }
}

```

The share extension is like a little standalone program. The extension receives the media, and issues an openURL call. In order for your main app to respond to the openURL call, you have to define a URL scheme ([Register Your URL Scheme](https://developer.apple.com/documentation/uikit/inter-process_communication/allowing_apps_and_websites_to_link_to_your_content/defining_a_custom_url_scheme_for_your_app)). The code above calls a URL scheme named "restvo://", so just replace it with your scheme.
To allow sharing of files between the extension and your main app, you need to [create an app group](https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_security_application-groups) which is checked for both your extension and main app. Search and replace "group.com.restvo.test" with your app group's name.

Finally, in your main app's AppDelegate.swift, override the following function. This is the function that is activated when the main app is opened by URL.

```swift
import UIKit
import Capacitor
// ...
import CapacitorShareExtension
// ...

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // ...
    let store = ShareStore.store
    // ...

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
            
        var success = true
        if CAPBridge.handleOpenUrl(url, options) {
            success = ApplicationDelegateProxy.shared.application(app, open: url, options: options)
        }
    
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
              let params = components.queryItems else {
                  return false
              }
        let titles = params.filter { $0.name == "title" }
        let descriptions = params.filter { $0.name == "description" }
        let types = params.filter { $0.name == "type" }
        let urls = params.filter { $0.name == "url" }
        let webPaths = params.filter { $0.name == "webPath" }
    
        store.shareItems.removeAll()
    
        if (titles.count > 0){
            for index in 0...titles.count-1 {
                var shareItem: JSObject = JSObject()
                shareItem["title"] = titles[index].value!
                shareItem["description"] = descriptions[index].value!
                shareItem["type"] = types[index].value!
                shareItem["url"] = urls[index].value!
                shareItem["webPath"] = webPaths[index].value!
                store.shareItems.append(shareItem)
            }
        }
    
        store.processed = false
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name("triggerSendIntent"), object: nil )
    
        return success
    }
    // ...
}
```


