// Module Federation remote type declarations

declare module 'taskManager/App' {
  const mount: (element: HTMLElement) => void;
  export default mount;
}

declare module 'userProfile/App' {
  const mount: (element: HTMLElement) => void;
  export default mount;
}

// Add more remote module declarations as needed
// declare module 'remoteName/ModuleName' {
//   const Component: React.ComponentType<any>;
//   export default Component;
// }

// Global webpack types
declare const __webpack_init_sharing__: (scope: string) => Promise<void>;
declare const __webpack_share_scopes__: any;

// MFE Configuration types
export interface MFEConfig {
  name: string;
  url: string;
  module: string;
  containerId: string;
  scope?: string;
}

export interface MFERegistry {
  [key: string]: MFEConfig;
}

export interface LoadedMFE {
  config: MFEConfig;
  container: string;
  mountPoint: HTMLElement;
  unmount?: () => void;
}
