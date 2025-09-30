# ⚡ **MFE Step-by-Step Implementation Guide**

Build a complete micro-frontend architecture with PHP Smarty and React in 30 minutes.

---

## **📋 Implementation Checklist**

- [ ] **Step 1**: PHP Smarty Base Application (5 min)
- [ ] **Step 2**: MFE Loader (JavaScript) (10 min)
- [ ] **Step 3**: React Remote Setup (5 min)
- [ ] **Step 4**: Module Federation Config (5 min)
- [ ] **Step 5**: Bootstrap Pattern (3 min)
- [ ] **Step 6**: Smarty Integration (2 min)
- [ ] **Step 7**: Testing & Validation (5 min)

**Total Time: ~30 minutes**

---

## **Step 1: PHP Smarty Base Application**

### **Directory Structure**

```bash
mkdir my-mfe-app/{templates,templates_c,cache,config,public/{css,js}}
mkdir my-mfe-app/templates/pages
```

### **index.php Setup**

```php
<?php
require_once 'path/to/smarty/libs/Smarty.class.php';

$smarty = new Smarty\Smarty();
$smarty->setTemplateDir(__DIR__ . '/templates/');
$smarty->setCompileDir(__DIR__ . '/templates_c/');
$smarty->setCacheDir(__DIR__ . '/cache/');
$smarty->setConfigDir(__DIR__ . '/config/');

// Routing system
$page = isset($_GET['page']) ? $_GET['page'] : 'home';
$valid_pages = ['home', 'about', 'tasks', 'dashboard'];

if (!in_array($page, $valid_pages)) {
    $page = 'home';
}

// Menu structure
$menu_items = [
    'home' => ['title' => 'Home', 'url' => '?page=home'],
    'about' => ['title' => 'About', 'url' => '?page=about'],
    'tasks' => ['title' => 'Tasks', 'url' => '?page=tasks'],
    'dashboard' => ['title' => 'Dashboard', 'url' => '?page=dashboard']
];

$smarty->assign('current_page', $page);
$smarty->assign('menu_items', $menu_items);
$smarty->display('layout.tpl');
?>
```

### **Main Layout Template**

```smarty
{* templates/layout.tpl *}
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MFE App - {$current_page|capitalize}</title>
    <link rel="stylesheet" href="public/css/style.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <nav class="navbar">
        <div class="nav-container">
            <div class="nav-logo">
                <a href="?page=home">MFE App</a>
            </div>
            <ul class="nav-menu">
                {foreach from=$menu_items key=page_key item=menu_item}
                    <li class="nav-item">
                        <a href="{$menu_item.url}"
                           class="nav-link {if $current_page == $page_key}active{/if}">
                            {$menu_item.title}
                        </a>
                    </li>
                {/foreach}
            </ul>
        </div>
    </nav>

    <main class="main-content">
        <div class="container">
            {include file="pages/{$current_page}.tpl"}
        </div>
    </main>

    <script src="public/js/mfe-loader.js"></script>
</body>
</html>
```

---

## **Step 2: MFE Loader (JavaScript)**

### **public/js/mfe-loader.js**

```javascript
/**
 * Smarty MFE Host - Module Federation Loader
 */
class SmartyMFEHost {
  constructor() {
    this.loadedRemotes = new Map();
    this.remoteConfigs = {
      taskManager: {
        name: 'react_task_manager',
        url: 'http://localhost:3002/remoteEntry.js',
        module: './App',
        containerId: 'task-manager-container',
      },
      dashboard: {
        name: 'react_dashboard',
        url: 'http://localhost:3003/remoteEntry.js',
        module: './Dashboard',
        containerId: 'dashboard-container',
      },
      // Add more remotes as needed
    };

    this.init();
  }

  init() {
    console.log('🚀 Smarty MFE Host initialized');
    this.autoLoadMFEs();

    // Expose global functions
    window.loadMFE = this.loadMFE.bind(this);
    window.unloadMFE = this.unloadMFE.bind(this);
  }

  /**
   * Auto-load MFEs if containers exist
   */
  autoLoadMFEs() {
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
   * Load specific MFE
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

    if (this.loadedRemotes.has(remoteName)) {
      console.log(`⚠️ MFE ${remoteName} already loaded`);
      return true;
    }

    try {
      this.showLoading(container, `Loading ${remoteName}...`);

      await this.loadRemoteModule(config.name, config.url);
      const remoteModule = await this.importRemoteModule(
        config.name,
        config.module
      );

      if (remoteModule && remoteModule.default) {
        container.innerHTML = '';
        const mountPoint = document.createElement('div');
        mountPoint.id = `${remoteName}-mount`;
        container.appendChild(mountPoint);

        remoteModule.default(mountPoint);

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
      this.showError(container, `Failed to load ${remoteName}`, error.message);
      return false;
    }
  }

  /**
   * Load remote module script
   */
  async loadRemoteModule(remoteName, remoteUrl) {
    return new Promise((resolve, reject) => {
      if (window[remoteName]) {
        resolve();
        return;
      }

      const script = document.createElement('script');
      script.src = remoteUrl;
      script.type = 'text/javascript';
      script.async = true;

      script.onload = () => resolve();
      script.onerror = () => reject(new Error(`Failed to load: ${remoteUrl}`));

      document.head.appendChild(script);
    });
  }

  /**
   * Import module from remote
   */
  async importRemoteModule(remoteName, modulePath) {
    if (!window[remoteName]) {
      throw new Error(`Remote ${remoteName} not loaded`);
    }

    const container = window[remoteName];
    const factory = await container.get(modulePath);
    return factory();
  }

  /**
   * Show loading state
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
   * Show error state
   */
  showError(container, title, message) {
    container.innerHTML = `
      <div class="mfe-error">
        <i class="fas fa-exclamation-triangle fa-2x"></i>
        <h3>${title}</h3>
        <p>${message}</p>
        <button onclick="location.reload()" class="btn btn-secondary">
          <i class="fas fa-redo"></i> Reload Page
        </button>
      </div>
    `;
  }
}

// Initialize when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
  window.smartyMFEHost = new SmartyMFEHost();
});
```

---

## **Step 3: React Remote Setup**

### **Directory Structure**

```bash
mkdir react-remote/{src,public}
cd react-remote
```

### **package.json**

```json
{
  "name": "react-remote",
  "version": "1.0.0",
  "scripts": {
    "start": "webpack serve --config webpack.config.js",
    "build": "webpack --config webpack.config.js --mode production"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "@babel/core": "^7.22.0",
    "@babel/preset-react": "^7.22.0",
    "@babel/preset-typescript": "^7.22.0",
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "babel-loader": "^9.1.0",
    "css-loader": "^6.8.0",
    "html-webpack-plugin": "^5.5.0",
    "style-loader": "^3.3.0",
    "typescript": "^5.0.0",
    "webpack": "^5.88.0",
    "webpack-cli": "^5.1.0",
    "webpack-dev-server": "^4.15.0"
  }
}
```

---

## **Step 4: Module Federation Config**

### **webpack.config.js**

```javascript
const HtmlWebpackPlugin = require('html-webpack-plugin');
const ModuleFederationPlugin = require('webpack/lib/container/ModuleFederationPlugin');

module.exports = {
  mode: 'development',
  entry: './src/index.tsx',
  devServer: {
    port: 3002,
    headers: {
      'Access-Control-Allow-Origin': '*',
    },
  },
  resolve: {
    extensions: ['.ts', '.tsx', '.js', '.jsx'],
  },
  module: {
    rules: [
      {
        test: /\.(ts|tsx)$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: ['@babel/preset-react', '@babel/preset-typescript'],
          },
        },
      },
      {
        test: /\.css$/,
        use: ['style-loader', 'css-loader'],
      },
    ],
  },
  plugins: [
    new ModuleFederationPlugin({
      name: 'react_task_manager',
      filename: 'remoteEntry.js',
      exposes: {
        './App': './src/App.tsx',
      },
      shared: {
        react: {
          singleton: true,
          requiredVersion: '^18.0.0',
        },
        'react-dom': {
          singleton: true,
          requiredVersion: '^18.0.0',
        },
      },
    }),
    new HtmlWebpackPlugin({
      template: './public/index.html',
    }),
  ],
};
```

---

## **Step 5: Bootstrap Pattern**

### **src/index.tsx**

```typescript
// Bootstrap file to handle shared module loading
import('./bootstrap');
```

### **src/bootstrap.tsx**

```typescript
import React from 'react';
import { createRoot } from 'react-dom/client';
import { ReactRemoteApp } from './App';

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
```

### **src/App.tsx**

```typescript
import React, { useState } from 'react';
import './App.css';

export const ReactRemoteApp: React.FC = () => {
  const [count, setCount] = useState(0);

  return (
    <div className="react-remote-app">
      <div className="app-header">
        <h2>⚛️ React Remote Micro-Frontend</h2>
        <p>A simple React component loaded via Module Federation</p>
      </div>

      <div className="app-content">
        <h3>Counter: {count}</h3>
        <button onClick={() => setCount(count + 1)}>Increment</button>
        <button onClick={() => setCount(count - 1)}>Decrement</button>
      </div>
    </div>
  );
};

// Export for Module Federation
const mount = (element: HTMLElement) => {
  const React = require('react');
  const ReactDOM = require('react-dom/client');

  const root = ReactDOM.createRoot(element);
  root.render(React.createElement(ReactRemoteApp));
};

export default mount;
```

### **public/index.html**

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>React Remote MFE</title>
  </head>
  <body>
    <div id="root"></div>
  </body>
</html>
```

---

## **Step 6: Smarty Integration**

### **Page with MFE Container**

```smarty
{* templates/pages/tasks.tpl *}
<div class="page-header">
    <h1><i class="fas fa-tasks"></i> Task Manager</h1>
    <p>Manage your tasks with our React micro-frontend</p>
</div>

<!-- This container will auto-load the React Task Manager -->
<div id="task-manager-container" class="mfe-container">
    <div class="mfe-loading">
        <i class="fas fa-spinner fa-spin fa-2x"></i>
        <h3>Loading Task Manager...</h3>
        <p>Please wait while we load the React micro-frontend</p>
    </div>
</div>

<div class="mfe-controls">
    <button onclick="loadMFE('taskManager')" class="btn btn-primary">
        <i class="fas fa-play"></i> Reload MFE
    </button>
    <button onclick="unloadMFE('taskManager')" class="btn btn-secondary">
        <i class="fas fa-stop"></i> Unload MFE
    </button>
</div>
```

### **CSS for MFE States**

```css
/* public/css/style.css */
.mfe-loading,
.mfe-error {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  padding: 60px 20px;
  text-align: center;
  min-height: 300px;
}

.mfe-loading i {
  color: #667eea;
  margin-bottom: 20px;
  animation: spin 1s linear infinite;
}

.mfe-error i {
  color: #ff6b6b;
  margin-bottom: 20px;
}

.mfe-container {
  border: 1px solid #e9ecef;
  border-radius: 10px;
  overflow: hidden;
  background: white;
  margin: 20px 0;
}

@keyframes spin {
  from {
    transform: rotate(0deg);
  }
  to {
    transform: rotate(360deg);
  }
}
```

---

## **Step 7: Testing & Validation**

### **Test Checklist**

#### **Standalone React App**

- [ ] Visit `http://localhost:3002`
- [ ] React app loads without errors
- [ ] All functionality works
- [ ] Console shows no federation errors

#### **Integrated Mode**

- [ ] Visit `http://localhost:8000?page=tasks`
- [ ] MFE auto-loads into container
- [ ] React component renders correctly
- [ ] Manual controls work (reload/unload)

#### **Error Handling**

- [ ] Stop React server, test error states
- [ ] Invalid container IDs handled gracefully
- [ ] Loading states display correctly

### **Start Servers**

```bash
# Terminal 1: Start React Remote
cd react-remote
yarn install
yarn start

# Terminal 2: Start PHP Server
cd my-mfe-app
php -S localhost:8000
```

### **Validation Steps**

1. **Test Standalone**: Visit `http://localhost:3002`
2. **Test Integrated**: Visit `http://localhost:8000?page=tasks`
3. **Test Error Handling**: Stop React server, reload page
4. **Test Multiple MFEs**: Add another remote and container

---

## **🎯 Quick Automation Script**

### **setup.sh**

```bash
#!/bin/bash

echo "🚀 Setting up MFE Demo"

# Install React dependencies
echo "📦 Installing React dependencies..."
cd react-remote && yarn install && cd ..

# Start React Remote
echo "🚀 Starting React Remote (port 3002)..."
cd react-remote
yarn start > ../logs/react-remote.log 2>&1 &
REACT_PID=$!
cd ..

# Start PHP Server
echo "🚀 Starting PHP Server (port 8000)..."
php -S localhost:8000 > logs/php-server.log 2>&1 &
PHP_PID=$!

echo ""
echo "✅ Demo is ready!"
echo "📱 Visit: http://localhost:8000"
echo "🛑 Stop with: kill $PHP_PID $REACT_PID"
echo ""
```

---

## **🚀 Next Steps**

1. **Add Real Functionality** - Replace counter with actual features
2. **Implement Error Boundaries** - Graceful failure handling
3. **Add State Management** - Redux, Zustand for complex apps
4. **Setup Production** - Review [gotchas and limitations](./MFE-GOTCHAS.md)
5. **Scale Architecture** - Add more micro-frontends
6. **Create POC** - Integrate with your main app using [POC guide](./MFE-POC-GUIDE.md)

**Congratulations! You've built a complete micro-frontend architecture!** 🎉

For production considerations and common pitfalls, see [MFE Gotchas & Limitations](./MFE-GOTCHAS.md).
