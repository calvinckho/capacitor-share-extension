declare global {
    interface PluginRegistry {
        ShareExtension?: ShareExtensionPlugin;
    }
}
export interface ShareExtensionPlugin {
    saveDataToKeychain(options: {
        key: string;
        data: any;
    }): Promise<{
        key: string;
        data: any;
    }>;
    loadDataFromNativeUserDefaults(options: {
        key: string;
    }): Promise<{
        key: string;
    }>;
    clearNativeUserDefaults(): Promise<any>;
}
