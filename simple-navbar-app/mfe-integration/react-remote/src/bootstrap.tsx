import React from 'react';
import { createRoot } from 'react-dom/client';

// Import the ReactRemoteApp component directly
import { ReactRemoteApp } from './App';

// For standalone development
const initStandaloneApp = () => {
  const container = document.getElementById('root');
  if (container) {
    const root = createRoot(container);
    root.render(<ReactRemoteApp />);
    console.log('✅ React Remote App mounted in standalone mode');
  } else {
    console.error('❌ Root container not found for standalone React app');
  }
};

// Ensure DOM is ready before mounting
if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initStandaloneApp);
} else {
  initStandaloneApp();
}
