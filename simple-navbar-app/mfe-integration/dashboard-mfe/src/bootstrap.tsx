import React from 'react';
import { createRoot } from 'react-dom/client';
import { DashboardApp } from './App';

const initStandaloneApp = () => {
  const container = document.getElementById('root');
  if (container) {
    const root = createRoot(container);
    root.render(<DashboardApp />);
    console.log('✅ Dashboard MFE mounted in standalone mode');
  } else {
    console.error('❌ Root container not found for standalone Dashboard app');
  }
};

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', initStandaloneApp);
} else {
  initStandaloneApp();
}
