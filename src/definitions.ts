export interface ShareExtensionPlugin {
    saveDataToKeychain(options: { key: string, data: any }): Promise<string>;
    loadDataFromNativeUserDefaults(options: { key: string }): Promise<{key: string}>;
    clearNativeUserDefaults(): Promise<any>;
}
