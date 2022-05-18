import { WebPlugin } from '@capacitor/core';
import { ShareExtensionPlugin } from './definitions';

export class ShareExtensionWeb extends WebPlugin implements ShareExtensionPlugin {
  constructor() {
    super({
      name: 'ShareExtension',
      platforms: ['web']
    });
  }

  async checkSendIntentReceived(): Promise<{ title: string }> {
    return {title: null};
  }

  finish(): void {
  }

  async saveDataToKeychain(options: { key: string, data: any }): Promise<string> {
    console.log('save', options);
    return 'not implemented yet for web';
  }

  async clearKeychainData(options: { key: string }): Promise<any> {
    console.log('clear completed', options);
    return
  }
}

const ShareExtension = new ShareExtensionWeb();

export { ShareExtension };
