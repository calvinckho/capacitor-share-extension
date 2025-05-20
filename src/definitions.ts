export interface ShareExtensionPlugin {
    checkSendIntentReceived(): Promise<{ payload: Intent[] }>;
    finish(): Promise<{ success: boolean }>;
    saveDataToKeychain(options: { key: string, data: any }): Promise<string>;
    clearKeychainData(options: { key: string }): Promise<any>;
}

export interface Intent {
    title?: string;
    description?: string;
    type?: string;
    url?: string;
    webPath?: string;
}
