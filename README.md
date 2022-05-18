<p align="center">
    <img width="150px" src="https://user-images.githubusercontent.com/13732623/63229908-7d8a8100-c1d3-11e9-955e-31aff33d07e1.png">
</p>

# @calvinckho/capacitor-share-extension

<img src="https://img.shields.io/npm/v/calvinckho/capacitor-share-extension?style=flat-square" />

This package supports share extension that requires storing and clearing the auth token in the iOS keychain.

## Installation
```
npm i git+ssh://git@github.com/calvinckho/capacitor-share-extension#capacitor-3
```


## Capacitor 3 Usage
```ts
import { ShareExtension } from 'capacitor-share-extension';

try {
    // android methods
    window.addEventListener("sendIntentReceived", async () => {
        try {
            const result: any = await ShareExtension.checkSendIntentReceived();
            if (result) {
                console.log('SendIntent received');
                console.log(JSON.stringify(result));
            }
            if (result.url) {
                let resultUrl = decodeURIComponent(result.url);
                Filesystem.readFile({path: resultUrl})
                    .then((content) => {
                        console.log(content.data);
                    })
                    .catch((err) => console.error(err));
            }
        } catch (err) {
            console.log(err);
        }
    })
    
    // iOS methods
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
} catch(err) {
    // handle method rejection when permission is not granted
}

```

