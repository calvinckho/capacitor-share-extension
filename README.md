<p align="center">
    <img width="150px" src="https://user-images.githubusercontent.com/13732623/63229908-7d8a8100-c1d3-11e9-955e-31aff33d07e1.png">
</p>

# @calvinckho/capacitor-share-extension

<img src="https://img.shields.io/npm/v/calvinckho/capacitor-share-extension?style=flat-square" />

This package demonstrates how to add share extension to native deployments for Restvo, a Ionic app.

## Installation
```
npm i git+ssh://git@github.com/calvinckho/capacitor-share-extension#capacitor-3
```


## Capacitor 3 Usage
```ts
import { ShareExtension } from 'capacitor-share-extension';

try {
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
        await ShareExtension.clearNativeUserDefaults();
    } catch (err) {
        console.log(err);
    }
} catch(err) {
    // handle method rejection when permission is not granted
}

```

