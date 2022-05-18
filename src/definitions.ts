export interface Intent {
    title?: string;
    description?: string;
    type?: string;
    url?: string;
    additionalItems?: any;
}

export interface ShareExtensionPlugin {
    checkSendIntentReceived(): Promise<Intent>;
    finish(): void;
    saveDataToKeychain(options: { key: string, data: any }): Promise<string>;
    clearKeychainData(options: { key: string }): Promise<any>;
}
