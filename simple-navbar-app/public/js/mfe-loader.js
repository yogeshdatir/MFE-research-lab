/**
 * MFE Loader - Smarty Host for Module Federation
 * Loads React micro-frontends directly into Smarty pages
 */

class SmartyMFEHost {
  constructor() {
    this.loadedRemotes = new Map();
    this.remoteConfigs = {
      taskManager: {
        name: 'react_task_manager',
        url: 'http://localhost:3002/remoteEntry.js',
        module: './App',
        containerId: 'task-manager-container'
      },
      // Add more remotes here as you build them
      // userProfile: {
      //   name: 'react_user_profile',
      //   url: 'http://localhost:3003/remoteEntry.js',
      //   module: './UserProfile',
      //   containerId: 'user-profile-container'
      // }
    };
    
    this.init();
  }

  init() {
    console.log('🚀 Smarty MFE Host initialized');
    
    // Auto-load MFEs based on containers present on page
    this.autoLoadMFEs();
    
    // Expose global functions for manual loading
    window.loadMFE = this.loadMFE.bind(this);
    window.unloadMFE = this.unloadMFE.bind(this);
  }

  /**
   * Automatically load MFEs if their containers exist on the page
   */
  autoLoadMFEs() {
    Object.keys(this.remoteConfigs).forEach(remoteName => {
      const config = this.remoteConfigs[remoteName];
      const container = document.getElementById(config.containerId);
      
      if (container) {
        console.log(`📦 Auto-loading MFE: ${remoteName}`);
        this.loadMFE(remoteName);
      }
    });
  }

  /**
   * Load a specific MFE
   * @param {string} remoteName - Name of the remote to load
   * @param {string} containerId - Optional custom container ID
   */
  async loadMFE(remoteName, containerId = null) {
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
      
      // Load the remote module
      await this.loadRemoteModule(config.name, config.url);
      
      // Import and mount the component
      const remoteModule = await this.importRemoteModule(config.name, config.module);
      
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
          mountPoint
        });
        
        console.log(`✅ MFE ${remoteName} loaded successfully`);
        return true;
      } else {
        throw new Error('Invalid remote module structure');
      }
      
    } catch (error) {
      console.error(`❌ Failed to load MFE ${remoteName}:`, error);
      this.showError(container, `Failed to load ${remoteName}`, error.message);
      return false;
    }
  }

  /**
   * Unload a specific MFE
   * @param {string} remoteName - Name of the remote to unload
   */
  unloadMFE(remoteName) {
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
   * Load remote module script
   * @param {string} remoteName - Name of the remote
   * @param {string} remoteUrl - URL to the remote entry
   */
  async loadRemoteModule(remoteName, remoteUrl) {
    return new Promise((resolve, reject) => {
      // Check if already loaded
      if (window[remoteName]) {
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
   * Import module from loaded remote
   * @param {string} remoteName - Name of the remote
   * @param {string} modulePath - Path to the module
   */
  async importRemoteModule(remoteName, modulePath) {
    if (!window[remoteName]) {
      throw new Error(`Remote ${remoteName} not loaded`);
    }

    try {
      const container = window[remoteName];
      const factory = await container.get(modulePath);
      return factory();
    } catch (error) {
      throw new Error(`Failed to import module ${modulePath} from ${remoteName}: ${error.message}`);
    }
  }

  /**
   * Show loading state in container
   * @param {HTMLElement} container - Container element
   * @param {string} message - Loading message
   */
  showLoading(container, message = 'Loading...') {
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
   * @param {HTMLElement} container - Container element
   * @param {string} title - Error title
   * @param {string} message - Error message
   */
  showError(container, title, message) {
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
   * Add a new remote configuration
   * @param {string} name - Remote name
   * @param {object} config - Remote configuration
   */
  addRemote(name, config) {
    this.remoteConfigs[name] = config;
    console.log(`➕ Added remote configuration: ${name}`);
  }

  /**
   * Get list of available remotes
   */
  getAvailableRemotes() {
    return Object.keys(this.remoteConfigs);
  }

  /**
   * Get list of loaded remotes
   */
  getLoadedRemotes() {
    return Array.from(this.loadedRemotes.keys());
  }
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
  window.smartyMFEHost = new SmartyMFEHost();
});

// Export for module systems
if (typeof module !== 'undefined' && module.exports) {
  module.exports = SmartyMFEHost;
}
