import { WebPlugin } from '@capacitor/core';
import { ShareExtensionPlugin } from './definitions';

export class ShareExtensionWeb extends WebPlugin implements ShareExtensionPlugin {
  constructor() {
    super({
      name: 'ShareExtension',
      platforms: ['web']
    });
  }

  async saveDataToNativeUserDefaults(options: { key: string, data: any }): Promise<{key: string, data: any}> {
    console.log('save', options);
    return options;
  }

  async loadDataFromNativeUserDefaults(options: { key: string }): Promise<{key: string}> {
      console.log('load', options);
      return options;
  }
}

const ShareExtension = new ShareExtensionWeb();

export { ShareExtension };
