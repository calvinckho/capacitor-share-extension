declare global {
  interface PluginRegistry {
    ShareExtension?: ShareExtensionPlugin;
  }
}

export interface ShareExtensionPlugin {
    checkSendIntentReceived(): Promise<Intent>;
    finish(): void;
    saveDataToKeychain(options: { key: string, data: any }): Promise<string>;
    clearKeychainData(options: { key: string }): Promise<any>;
}

export interface Intent {
    title?: string;
    description?: string;
    type?: string;
    url?: string;
    webPath?: string;
    additionalItems?: any;
}
