// MFE Host Application
class MFEHost {
  private container: HTMLElement;
  private loadButton: HTMLButtonElement;
  private clearButton: HTMLButtonElement;
  private isReactLoaded = false;

  constructor() {
    this.container = document.getElementById(
      'react-remote-container'
    ) as HTMLElement;
    this.loadButton = document.getElementById(
      'loadReactApp'
    ) as HTMLButtonElement;
    this.clearButton = document.getElementById(
      'clearContent'
    ) as HTMLButtonElement;

    this.init();
  }

  private init(): void {
    this.loadButton.addEventListener('click', () => this.loadReactRemote());
    this.clearButton.addEventListener('click', () => this.clearContent());

    console.log('🚀 MFE Host initialized');
  }

  private async loadReactRemote(): Promise<void> {
    if (this.isReactLoaded) {
      console.log('React remote already loaded');
      return;
    }

    try {
      this.showLoading();

      // Dynamic import of the React remote with proper error handling
      const reactRemote = await import('reactRemote/App').catch((error) => {
        console.error('Failed to import React remote:', error);
        throw new Error(
          "React remote not available. Make sure it's running on port 3002."
        );
      });

      // Clear container and mount React app
      this.container.innerHTML = '<div id="react-app-root"></div>';

      // Mount the React component
      const mountElement = document.getElementById('react-app-root');
      if (mountElement && reactRemote.default) {
        reactRemote.default(mountElement);
        this.isReactLoaded = true;
        this.loadButton.textContent = 'React App Loaded ✓';
        this.loadButton.classList.add('active');
        console.log('✅ React remote loaded successfully');
      } else {
        throw new Error('Failed to mount React component');
      }
    } catch (error) {
      console.error('❌ Failed to load React remote:', error);
      this.showError(
        `Failed to load React remote application. ${
          error instanceof Error ? error.message : 'Unknown error'
        }`
      );
    }
  }

  private clearContent(): void {
    this.container.innerHTML = `
      <div class="loading">
        <h3>Content Cleared</h3>
        <p>Click "Load React Remote App" to load the micro-frontend again.</p>
      </div>
    `;
    this.isReactLoaded = false;
    this.loadButton.textContent = 'Load React Remote App';
    this.loadButton.classList.remove('active');
    console.log('🧹 Content cleared');
  }

  private showLoading(): void {
    this.container.innerHTML = `
      <div class="loading">
        <h3>Loading React Remote...</h3>
        <p>Please wait while we fetch the micro-frontend.</p>
      </div>
    `;
  }

  private showError(message: string): void {
    this.container.innerHTML = `
      <div class="error">
        <h3>Error Loading Remote</h3>
        <p>${message}</p>
      </div>
    `;
  }
}

// Initialize the MFE Host when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
  new MFEHost();
});

// Global function to be called from PHP page
(window as any).initMFEHost = () => {
  return new MFEHost();
};

export default MFEHost;
