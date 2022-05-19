<p align="center">
    <img width="150px" src="https://user-images.githubusercontent.com/13732623/63229908-7d8a8100-c1d3-11e9-955e-31aff33d07e1.png">
</p>

# @calvinckho/capacitor-share-extension

<img src="https://img.shields.io/npm/v/calvinckho/capacitor-share-extension?style=flat-square" />

This Capacitor Plugin provides native capabilities to retrieve media files sent via iOS Share Extension and Android Send Intent events

## Installation
```
npm i git+ssh://git@github.com/calvinckho/capacitor-share-extension
```


## Capacitor 3 Usage
```ts
import { ShareExtension } from 'capacitor-share-extension';

if (this.platform.is('cordova') && Capacitor.isPluginAvailable('ShareExtension')) {
    window.addEventListener('sendIntentReceived',  () => {
        this.checkIntent();
    });
    this.checkIntent();
}

async checkIntent() {
    try {
        const result: any = await ShareExtension.checkSendIntentReceived();
        if (result && result.type) {
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

