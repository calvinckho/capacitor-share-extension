import { registerPlugin } from '@capacitor/core';
const ShareExtension = registerPlugin('ShareExtension', {
    web: () => import('./web').then(m => new m.ShareExtensionWeb()),
});
export * from './definitions';
export { ShareExtension };
//# sourceMappingURL=index.js.map