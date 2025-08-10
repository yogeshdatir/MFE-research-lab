// import React from 'react';
// import { createRoot } from 'react-dom/client';
// import App from './App';

// const container = document.getElementById('root');
// const root = createRoot(container);
// root.render(<App />);

import React from 'react';
import { createRoot } from 'react-dom/client';
import App from './App';

export function mount(elId) {
  const el = document.getElementById(elId);
  if (el) {
    const root = createRoot(el);
    root.render(<App />);
  } else {
    console.error('Mount element not found:', elId);
  }
}
