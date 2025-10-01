import { MFEConfig, MFERegistry, LoadedMFE } from './types';

/**
 * Webpack Module Federation Host Orchestrator
 * Replaces the custom mfe-loader.js with enterprise-grade MFE management
 */
export class WebpackMFEHost {
  private loadedRemotes: Map<string, LoadedMFE> = new Map();
  private remoteConfigs: MFERegistry = {
    taskManager: {
      name: 'react_task_manager',
      url: 'http://localhost:3002/remoteEntry.js',
      module: './App',
      containerId: 'task-manager-container',
      scope: 'taskManager',
    },
    dashboard: {
      name: 'react_dashboard',
      url: 'http://localhost:3003/remoteEntry.js',
      module: './App',
      containerId: 'dashboard-container',
      scope: 'dashboard',
    },
    // Add more remotes here as you build them
    // userProfile: {
    //   name: 'react_user_profile',
    //   url: 'http://localhost:3004/remoteEntry.js',
    //   module: './App',
    //   containerId: 'user-profile-container',
    //   scope: 'userProfile'
    // }
  };

  constructor() {
    this.init();
  }

  private init(): void {
    console.log('🚀 Webpack MFE Host initialized');

    // Auto-load MFEs based on containers present on page
    this.autoLoadMFEs();

    // Expose global functions for manual loading
    (window as any).loadMFE = this.loadMFE.bind(this);
    (window as any).unloadMFE = this.unloadMFE.bind(this);
    (window as any).webpackMFEHost = this;
  }

  /**
   * Automatically load MFEs if their containers exist on the page
   */
  private autoLoadMFEs(): void {
    Object.keys(this.remoteConfigs).forEach((remoteName) => {
      const config = this.remoteConfigs[remoteName];
      const container = document.getElementById(config.containerId);

      if (container) {
        console.log(`📦 Auto-loading MFE: ${remoteName}`);
        this.loadMFE(remoteName);
      }
    });
  }

  /**
   * Load a specific MFE using Module Federation
   * @param remoteName - Name of the remote to load
   * @param containerId - Optional custom container ID
   */
  public async loadMFE(
    remoteName: string,
    containerId?: string
  ): Promise<boolean> {
    const config = this.remoteConfigs[remoteName];
    if (!config) {
      console.error(`❌ Unknown remote: ${remoteName}`);
      return false;
    }

    const targetContainerId = containerId || config.containerId;
    const container = document.getElementById(targetContainerId);

    if (!container) {
      console.error(`❌ Container not found: ${targetContainerId}`);
      return false;
    }

    // Check if already loaded
    if (this.loadedRemotes.has(remoteName)) {
      console.log(`⚠️ MFE ${remoteName} already loaded`);
      return true;
    }

    try {
      this.showLoading(container, `Loading ${remoteName}...`);

      // First, ensure the remote script is loaded
      await this.loadRemoteScript(config.name, config.url);

      // Then load the remote module using Module Federation
      const remoteModule = await this.importRemoteModule(
        config.scope || remoteName,
        config.module
      );

      if (remoteModule && remoteModule.default) {
        // Clear loading and mount component
        container.innerHTML = '';

        // Create mount point
        const mountPoint = document.createElement('div');
        mountPoint.id = `${remoteName}-mount`;
        container.appendChild(mountPoint);

        // Mount the React component
        remoteModule.default(mountPoint);

        // Track loaded remote
        this.loadedRemotes.set(remoteName, {
          config,
          container: targetContainerId,
          mountPoint,
        });

        console.log(`✅ MFE ${remoteName} loaded successfully`);
        return true;
      } else {
        throw new Error('Invalid remote module structure');
      }
    } catch (error) {
      console.error(`❌ Failed to load MFE ${remoteName}:`, error);
      this.showError(
        container,
        `Failed to load ${remoteName}`,
        (error as Error).message
      );
      return false;
    }
  }

  /**
   * Unload a specific MFE
   * @param remoteName - Name of the remote to unload
   */
  public unloadMFE(remoteName: string): void {
    const loadedRemote = this.loadedRemotes.get(remoteName);
    if (!loadedRemote) {
      console.log(`⚠️ MFE ${remoteName} is not loaded`);
      return;
    }

    const container = document.getElementById(loadedRemote.container);
    if (container) {
      container.innerHTML = `
        <div class="mfe-placeholder">
          <i class="fas fa-cube"></i>
          <h3>${remoteName} Unloaded</h3>
          <p>Click to reload this micro-frontend</p>
          <button onclick="loadMFE('${remoteName}')" class="btn btn-primary">
            Reload ${remoteName}
          </button>
        </div>
      `;
    }

    this.loadedRemotes.delete(remoteName);
    console.log(`🗑️ MFE ${remoteName} unloaded`);
  }

  /**
   * Load remote script dynamically
   * @param remoteName - Name of the remote
   * @param remoteUrl - URL to the remote entry
   */
  private async loadRemoteScript(
    remoteName: string,
    remoteUrl: string
  ): Promise<void> {
    return new Promise((resolve, reject) => {
      // Check if already loaded
      if ((window as any)[remoteName]) {
        resolve();
        return;
      }

      const script = document.createElement('script');
      script.src = remoteUrl;
      script.type = 'text/javascript';
      script.async = true;

      script.onload = () => {
        console.log(`📥 Remote script loaded: ${remoteName}`);
        resolve();
      };

      script.onerror = () => {
        reject(new Error(`Failed to load remote script: ${remoteUrl}`));
      };

      document.head.appendChild(script);
    });
  }

  /**
   * Import module from remote using Module Federation
   * @param scope - Remote scope name
   * @param module - Module path (should start with ./)
   */
  private async importRemoteModule(
    scope: string,
    module: string
  ): Promise<any> {
    try {
      console.log(`🔗 Importing module: ${module} from ${scope}`);

      // Initialize sharing scope if needed
      if (typeof __webpack_init_sharing__ !== 'undefined') {
        await __webpack_init_sharing__('default');
      }

      // Get the container from the window object
      // The container name should match the 'name' field in the remote's webpack config
      const containerName =
        scope === 'taskManager'
          ? 'react_task_manager'
          : scope === 'dashboard'
          ? 'react_dashboard'
          : scope;
      const container = (window as any)[containerName];
      if (!container) {
        throw new Error(
          `Remote container ${containerName} not found on window object. Available: ${Object.keys(
            window
          )
            .filter((k) => k.includes('react') || k.includes('task'))
            .join(', ')}`
        );
      }

      // Initialize the container with shared scope
      if (typeof container.init === 'function') {
        await container.init(__webpack_share_scopes__.default);
      }

      // Get the module factory
      const factory = await container.get(module);
      if (!factory) {
        throw new Error(`Module ${module} not found in remote ${scope}`);
      }

      // Execute the factory to get the module
      const remoteModule = factory();
      return remoteModule;
    } catch (error) {
      throw new Error(
        `Failed to import module ${module} from ${scope}: ${
          (error as Error).message
        }`
      );
    }
  }

  /**
   * Show loading state in container
   * @param container - Container element
   * @param message - Loading message
   */
  private showLoading(
    container: HTMLElement,
    message: string = 'Loading...'
  ): void {
    container.innerHTML = `
      <div class="mfe-loading">
        <i class="fas fa-spinner fa-spin fa-2x"></i>
        <h3>${message}</h3>
        <p>Please wait while we load the micro-frontend</p>
      </div>
    `;
  }

  /**
   * Show error state in container
   * @param container - Container element
   * @param title - Error title
   * @param message - Error message
   */
  private showError(
    container: HTMLElement,
    title: string,
    message: string
  ): void {
    container.innerHTML = `
      <div class="mfe-error">
        <i class="fas fa-exclamation-triangle fa-2x"></i>
        <h3>${title}</h3>
        <p>${message}</p>
        <div class="mfe-error-actions">
          <button onclick="location.reload()" class="btn btn-secondary">
            <i class="fas fa-redo"></i> Reload Page
          </button>
        </div>
      </div>
    `;
  }

  /**
   * Add a new remote configuration dynamically
   * @param name - Remote name
   * @param config - Remote configuration
   */
  public addRemote(name: string, config: MFEConfig): void {
    this.remoteConfigs[name] = config;
    console.log(`➕ Added remote configuration: ${name}`);
  }

  /**
   * Get list of available remotes
   */
  public getAvailableRemotes(): string[] {
    return Object.keys(this.remoteConfigs);
  }

  /**
   * Get list of loaded remotes
   */
  public getLoadedRemotes(): string[] {
    return Array.from(this.loadedRemotes.keys());
  }

  /**
   * Get remote configuration
   * @param remoteName - Name of the remote
   */
  public getRemoteConfig(remoteName: string): MFEConfig | undefined {
    return this.remoteConfigs[remoteName];
  }

  /**
   * Update remote configuration
   * @param remoteName - Name of the remote
   * @param config - Updated configuration
   */
  public updateRemoteConfig(
    remoteName: string,
    config: Partial<MFEConfig>
  ): void {
    if (this.remoteConfigs[remoteName]) {
      this.remoteConfigs[remoteName] = {
        ...this.remoteConfigs[remoteName],
        ...config,
      };
      console.log(`🔄 Updated remote configuration: ${remoteName}`);
    }
  }
}
