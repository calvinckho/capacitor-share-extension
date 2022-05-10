import { registerPlugin } from '@capacitor/core';

import type { ShareExtensionPlugin } from './definitions';

const ShareExtension = registerPlugin<ShareExtensionPlugin>('ShareExtension', {
    web: () => import('./web').then(m => new m.ShareExtensionWeb()),
});

export * from './definitions';
export { ShareExtension };
