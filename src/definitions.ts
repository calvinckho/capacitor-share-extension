export interface ShareExtensionPlugin {
    saveDataToKeychain(options: { key: string, data: any }): Promise<string>;
    clearKeychainData(options: { key: string }): Promise<any>;
}
