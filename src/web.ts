import { WebPlugin } from '@capacitor/core';
import { ShareExtensionPlugin } from './definitions';

export class ShareExtensionWeb extends WebPlugin implements ShareExtensionPlugin {
  async checkSendIntentReceived(): ReturnType<ShareExtensionPlugin["checkSendIntentReceived"]> {
    return { payload: [] };
  }

  async clearKeychainData(): ReturnType<ShareExtensionPlugin["clearKeychainData"]> {
    return undefined;
  }

  async finish(): ReturnType<ShareExtensionPlugin["finish"]> {
    return { success: true };
  }

  async saveDataToKeychain(): ReturnType<ShareExtensionPlugin["saveDataToKeychain"]> {
    return "";
  }

}

const ShareExtension = new ShareExtensionWeb();

export { ShareExtension };
