export interface ShareExtensionPlugin {
    saveDataToKeychain(options: { key: string, data: any }): Promise<string>;
    clearKeychainData(key: string): Promise<any>;
}
