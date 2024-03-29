#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(ShareExtension, "ShareExtension",
           CAP_PLUGIN_METHOD(checkSendIntentReceived, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(finish, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(saveDataToKeychain, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(clearKeychainData, CAPPluginReturnPromise);
)
