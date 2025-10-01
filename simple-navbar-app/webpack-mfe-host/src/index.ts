import { WebpackMFEHost } from './mfe-orchestrator';
import './styles.css';

/**
 * Webpack Module Federation Host Entry Point
 * Initializes the MFE orchestrator when DOM is ready
 */

// Initialize when DOM is ready
const initMFEHost = (): void => {
  const mfeHost = new WebpackMFEHost();
  console.log('🎯 Webpack MFE Host ready for Smarty integration');
};

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initMFEHost);
} else {
  initMFEHost();
}

// Export for module systems
export { WebpackMFEHost };
