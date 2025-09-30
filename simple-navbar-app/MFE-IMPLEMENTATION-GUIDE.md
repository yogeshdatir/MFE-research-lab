# 🚀 **Micro-Frontend Architecture Implementation Guide**

A complete guide to implementing Module Federation with PHP Smarty as the host and React micro-frontends.

## **📋 Implementation Checklist**

- [ ] **Step 1**: PHP Smarty Base Application
- [ ] **Step 2**: MFE Loader (JavaScript)
- [ ] **Step 3**: React Remote Setup
- [ ] **Step 4**: Module Federation Config
- [ ] **Step 5**: Bootstrap Pattern
- [ ] **Step 6**: Smarty Integration
- [ ] **Step 7**: Automation Scripts
- [ ] **Step 8**: Testing & Validation

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

### **🧠 Theoretical Foundation - The MFE Orchestrator**

#### **What is the MFE Loader?**

The MFE Loader is a **JavaScript orchestrator** that acts as the "conductor" of your micro-frontend symphony. Think of it as a smart dispatcher that:

1. **Discovers** what micro-frontends are needed on each page
2. **Fetches** the required remote applications dynamically
3. **Mounts** them into designated containers
4. **Manages** their lifecycle (loading, errors, cleanup)

#### **Core Concepts**

```
┌─────────────────────────────────────────────────────────────┐
│                    MFE LOADER ARCHITECTURE                  │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐     │
│  │   Smarty    │    │ MFE Loader  │    │   Remote    │     │
│  │    Host     │◄──►│ Orchestrator│◄──►│    Apps     │     │
│  │             │    │             │    │             │     │
│  └─────────────┘    └─────────────┘    └─────────────┘     │
│         │                   │                   │          │
│    Provides           Manages Runtime      Independent      │
│   Containers           Federation          React Apps      │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

#### **The Magic: Runtime Module Federation**

```javascript
// Traditional Approach (Static)
import TaskManager from './TaskManager'; // ❌ Compile-time dependency

// MFE Approach (Dynamic)
const TaskManager = await loadRemote('taskManager'); // ✅ Runtime loading
```

#### **Key Architectural Principles**

##### **1. Declarative Integration**

```smarty
{* Just add a container - MFE auto-loads! *}
<div id="task-manager-container"></div>
<!-- The loader scans for this ID and loads the corresponding MFE -->
```

##### **2. Configuration-Driven**

```javascript
// Single source of truth for all remotes
const remoteConfigs = {
  taskManager: {
    name: 'react_task_manager', // Webpack container name
    url: 'http://localhost:3002/remoteEntry.js', // Where to fetch from
    module: './App', // What module to import
    containerId: 'task-manager-container', // Where to mount
  },
};
```

##### **3. Fault Tolerance**

```
Remote App Down? ──► Show Error State ──► Main App Continues
Network Issue?  ──► Show Loading State ──► Retry Available
Wrong Config?   ──► Log Error ──────────► Graceful Degradation
```

#### **The Loading Lifecycle**

```
Page Load
    │
    ▼
┌─────────────────┐
│ 1. DOM Scan     │ ──► Look for container IDs
└─────────────────┘
    │
    ▼
┌─────────────────┐
│ 2. Match Config │ ──► Find corresponding remote
└─────────────────┘
    │
    ▼
┌─────────────────┐
│ 3. Fetch Remote │ ──► Load remoteEntry.js
└─────────────────┘
    │
    ▼
┌─────────────────┐
│ 4. Import Module│ ──► Get exposed component
└─────────────────┘
    │
    ▼
┌─────────────────┐
│ 5. Mount App    │ ──► Render in container
└─────────────────┘
```

#### **Why This Architecture Works**

##### **🔄 Runtime Composition**

- Apps are composed at **runtime**, not build time
- Each MFE is an **independent deployment**
- Host app doesn't need to know about MFE internals

##### **🎯 Smart Discovery**

- Loader **automatically detects** what MFEs are needed
- No manual initialization required
- **Lazy loading** - only loads what's on the page

##### **🛡️ Isolation & Safety**

- Each MFE runs in its **own context**
- Failed MFEs don't crash the main app
- **Independent versioning** and dependencies

##### **📦 Shared Dependencies**

- React, ReactDOM shared across all MFEs
- **Optimized loading** - no duplicate libraries
- **Version management** handled by Module Federation

#### **POC Implementation Strategy**

##### **Phase 1: Proof of Concept (1-2 days)**

```javascript
// Minimal loader for POC
class SimpleMFELoader {
  async loadTaskManager() {
    const script = document.createElement('script');
    script.src = 'http://localhost:3002/remoteEntry.js';
    document.head.appendChild(script);

    const container = window.react_task_manager;
    const factory = await container.get('./App');
    const TaskManager = factory();

    const element = document.getElementById('task-container');
    TaskManager.default(element);
  }
}
```

##### **Phase 2: Production Ready (3-5 days)**

```javascript
// Full-featured loader with error handling, auto-discovery, etc.
class ProductionMFELoader {
  // Complete implementation with all features
}
```

#### **Team Explanation Points**

##### **For Backend Developers**

- "It's like **include/require** but for JavaScript at runtime"
- "Each MFE is like a **microservice** for the frontend"
- "The loader is like a **reverse proxy** for UI components"

##### **For Frontend Developers**

- "Build React apps **normally**, the loader handles integration"
- "It's **dynamic imports** with automatic discovery"
- "Think **plugin architecture** for web applications"

##### **For DevOps/Management**

- "**Independent deployments** - deploy features without touching main app"
- "**Team autonomy** - each team owns their MFE completely"
- "**Risk reduction** - failed features don't break the entire app"

#### **Real-World Benefits**

##### **Development Speed** ⚡

```
Traditional: Change → Build Entire App → Deploy Everything
MFE:        Change → Build One MFE → Deploy Just That Feature
```

##### **Team Scaling** 👥

```
Traditional: All developers work on same codebase
MFE:        Each team has independent React app
```

##### **Technology Evolution** 🚀

```
Traditional: Stuck with one React version for entire app
MFE:        Each MFE can use different React versions
```

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

## **Step 7: Automation Scripts**

### **demo-setup.sh**

```bash
#!/bin/bash

echo "🚀 Setting up Micro-Frontend Demo"

# Check dependencies
command -v php >/dev/null 2>&1 || { echo "PHP required"; exit 1; }
command -v node >/dev/null 2>&1 || { echo "Node.js required"; exit 1; }
command -v yarn >/dev/null 2>&1 || npm install -g yarn

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

# Create stop script
cat > stop-demo.sh << EOF
#!/bin/bash
echo "🛑 Stopping servers..."
kill $PHP_PID $REACT_PID 2>/dev/null
echo "✅ All servers stopped!"
EOF
chmod +x stop-demo.sh

echo ""
echo "✅ Demo is ready!"
echo "📱 Visit: http://localhost:8000"
echo "🛑 Stop with: ./stop-demo.sh"
echo ""

# Keep running
trap 'kill $PHP_PID $REACT_PID 2>/dev/null; exit 0' INT
wait
```

---

## **Step 8: Testing & Validation**

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

#### **Multiple MFEs**

- [ ] Add second React app on different port
- [ ] Configure in `remoteConfigs`
- [ ] Test both MFEs on same page
- [ ] Verify independent operation

---

## **🎯 Architecture Benefits**

### **For Existing PHP Applications**

- ✅ **Gradual Migration** - Add React components incrementally
- ✅ **Zero Disruption** - Keep existing PHP codebase intact
- ✅ **Team Independence** - PHP and React teams work separately
- ✅ **Technology Choice** - Use best tool for each feature

### **For Scaling**

- ✅ **Independent Deployment** - Deploy React apps without touching PHP
- ✅ **Runtime Composition** - True micro-frontend architecture
- ✅ **Shared Dependencies** - Optimized bundle loading
- ✅ **Error Isolation** - Failed MFEs don't break main app

### **Development Workflow**

- ✅ **Hot Reloading** - React apps update independently
- ✅ **Standalone Testing** - Test MFEs in isolation
- ✅ **Easy Integration** - Just add container divs
- ✅ **Version Management** - Each MFE has its own versioning

---

## **🔄 Adding New Remotes - Dynamic Architecture**

### **The Magic: No Boilerplate Needed!**

This architecture is designed to be **dynamic and extensible**. You don't need to recreate any boilerplate when adding new micro-frontends.

### **Step 1: Add Remote Config (30 seconds)**

Just add one object to the existing `remoteConfigs`:

```javascript
// In public/js/mfe-loader.js - just add to existing remoteConfigs
this.remoteConfigs = {
  taskManager: {
    /* existing */
  },

  // Add new remote - just one object!
  userProfile: {
    name: 'react_user_profile',
    url: 'http://localhost:3003/remoteEntry.js',
    module: './UserProfile',
    containerId: 'user-profile-container',
  },

  // Add another one
  dashboard: {
    name: 'react_dashboard',
    url: 'http://localhost:3004/remoteEntry.js',
    module: './Dashboard',
    containerId: 'dashboard-container',
  },

  // Add as many as you need!
  analytics: {
    name: 'react_analytics',
    url: 'http://localhost:3005/remoteEntry.js',
    module: './Analytics',
    containerId: 'analytics-container',
  },
};
```

### **Step 2: Add Container to Any Page (10 seconds)**

Just add a div with the matching `containerId`:

```smarty
{* Any Smarty template - just add the container *}
<div class="page-content">
    <h1>User Profile</h1>

    <!-- MFE auto-loads when page loads! -->
    <div id="user-profile-container"></div>

    <h2>Analytics Dashboard</h2>
    <div id="analytics-container"></div>
</div>
```

### **Step 3: Create React Remote (Standard React Development)**

```bash
# Create new React app (copy from existing remote)
mkdir react-user-profile && cd react-user-profile

# Copy package.json and webpack.config.js from existing remote
cp ../react-remote/package.json .
cp ../react-remote/webpack.config.js .

# Update webpack config name
# Change: name: 'react_task_manager'
# To:     name: 'react_user_profile'

# Install dependencies
yarn install

# Build your React component normally
# The MFE loader handles everything else!
```

### **Even More Dynamic - Runtime Configuration**

You can add remotes dynamically at runtime:

```javascript
// Add remotes programmatically!
window.smartyMFEHost.addRemote('newFeature', {
  name: 'react_new_feature',
  url: 'http://localhost:3006/remoteEntry.js',
  module: './NewFeature',
  containerId: 'new-feature-container',
});

// Load immediately
window.smartyMFEHost.loadMFE('newFeature');

// Or load into custom container
window.smartyMFEHost.loadMFE('newFeature', 'custom-container-id');
```

### **What You DON'T Need to Recreate**

- ❌ **MFE Loader** - Already handles unlimited remotes
- ❌ **PHP Routing System** - Works for all pages
- ❌ **Smarty Templates** - Just add containers where needed
- ❌ **Loading States** - Auto-handled by the loader
- ❌ **Error Handling** - Built into the system
- ❌ **Manual Controls** - `loadMFE()` works for any remote
- ❌ **Auto-Discovery** - Scans for containers automatically

### **What's Automatically Dynamic**

- ✅ **Auto-Discovery** - Scans page for containers on every page load
- ✅ **Runtime Loading** - Fetches remotes on demand
- ✅ **Error Recovery** - Each remote fails independently
- ✅ **Hot Swapping** - Change remote URLs without restart
- ✅ **Lazy Loading** - Only loads remotes when containers exist
- ✅ **Fault Tolerance** - Failed remotes don't break the app

### **Real Example - Adding 3 New MFEs**

```javascript
// 1. Add all configs at once
this.remoteConfigs = {
  // Existing
  taskManager: {
    /* ... */
  },

  // New ones - just add objects!
  userProfile: {
    name: 'react_user_profile',
    url: 'http://localhost:3003/remoteEntry.js',
    module: './UserProfile',
    containerId: 'user-profile-container',
  },
  chatWidget: {
    name: 'react_chat',
    url: 'http://localhost:3004/remoteEntry.js',
    module: './ChatWidget',
    containerId: 'chat-container',
  },
  dataViz: {
    name: 'react_charts',
    url: 'http://localhost:3005/remoteEntry.js',
    module: './Charts',
    containerId: 'charts-container',
  },
};
```

```smarty
{* 2. Use in any Smarty page *}
<div class="dashboard">
    <div class="user-section">
        <div id="user-profile-container"></div>
    </div>

    <div class="analytics-section">
        <div id="charts-container"></div>
    </div>

    <div class="support-section">
        <div id="chat-container"></div>
    </div>
</div>

{* All 3 MFEs auto-load when page loads! *}
```

### **Benefits of This Dynamic Architecture**

- 🚀 **Instant Integration** - New remotes work immediately
- 🔄 **Hot Swappable** - Change remote URLs without restart
- 📦 **Lazy Loading** - Only loads remotes when containers exist
- 🛡️ **Fault Tolerant** - Failed remotes don't break the app
- 🎯 **Zero Config** - Auto-discovery handles everything
- 👥 **Team Independence** - Each team builds their React app
- 🔧 **Easy Debugging** - Each MFE can be tested standalone
- 📈 **Infinite Scaling** - Add unlimited micro-frontends

### **The MFE Orchestrator**

The MFE loader acts as a **micro-frontend orchestrator** that:

1. **Scans** every page for containers automatically
2. **Matches** containers to remote configurations
3. **Loads** remotes dynamically at runtime
4. **Handles** all complexity (loading, errors, mounting)
5. **Provides** manual controls for testing/debugging
6. **Recovers** gracefully from failures

**You just focus on building React components - the infrastructure handles everything else!** 🚀

---

## **🎯 Creating POC in Main App - Practical Guide**

### **POC Strategy: Start Small, Prove Concept**

#### **Step 1: Minimal POC (Day 1)**

##### **Goal**: Prove that Module Federation works in your main app

```javascript
// Create: public/js/simple-mfe-poc.js
class SimpleMFEPOC {
  async loadRemoteComponent() {
    try {
      // 1. Load the remote entry script
      await this.loadScript('http://localhost:3002/remoteEntry.js');

      // 2. Get the remote container
      const container = window.react_task_manager;

      // 3. Import the exposed module
      const factory = await container.get('./App');
      const RemoteApp = factory();

      // 4. Mount it
      const element = document.getElementById('poc-container');
      RemoteApp.default(element);

      console.log('✅ POC Success: Remote loaded!');
    } catch (error) {
      console.error('❌ POC Failed:', error);
    }
  }

  loadScript(src) {
    return new Promise((resolve, reject) => {
      const script = document.createElement('script');
      script.src = src;
      script.onload = resolve;
      script.onerror = reject;
      document.head.appendChild(script);
    });
  }
}

// Initialize POC
window.mfePOC = new SimpleMFEPOC();
```

##### **Add to Any Existing Page**

```php
// In your main app's template/page
<div class="poc-section">
    <h2>MFE POC Test</h2>
    <div id="poc-container" style="border: 2px solid blue; padding: 20px;">
        <p>Remote component will load here...</p>
    </div>
    <button onclick="window.mfePOC.loadRemoteComponent()">
        Load Remote Component
    </button>
</div>

<script src="public/js/simple-mfe-poc.js"></script>
```

#### **Step 2: Integration POC (Day 2)**

##### **Goal**: Show how MFEs integrate with existing app state/data

```javascript
// Enhanced POC with data passing
class IntegratedMFEPOC {
  constructor() {
    this.appData = {
      userId: 123,
      theme: 'dark',
      permissions: ['read', 'write'],
    };
  }

  async loadRemoteWithData() {
    try {
      await this.loadScript('http://localhost:3002/remoteEntry.js');
      const container = window.react_task_manager;
      const factory = await container.get('./App');
      const RemoteApp = factory();

      const element = document.getElementById('integrated-container');

      // Pass main app data to MFE
      RemoteApp.default(element, {
        initialData: this.appData,
        onUpdate: (data) => {
          console.log('MFE updated data:', data);
          this.handleMFEUpdate(data);
        },
      });
    } catch (error) {
      console.error('Integration POC failed:', error);
    }
  }

  handleMFEUpdate(data) {
    // Handle data updates from MFE
    console.log('Main app received update from MFE:', data);
    // Update main app state, send to backend, etc.
  }
}
```

#### **Step 3: Production-Like POC (Day 3-5)**

##### **Goal**: Demonstrate production readiness with error handling

```javascript
// Production-ready POC
class ProductionMFEPOC {
  constructor() {
    this.remotes = new Map();
    this.config = {
      taskManager: {
        url: 'http://localhost:3002/remoteEntry.js',
        container: 'react_task_manager',
        module: './App',
        fallback: '<p>Task Manager unavailable</p>',
      },
    };
  }

  async loadMFE(name, targetElement) {
    const config = this.config[name];
    if (!config) {
      throw new Error(`Unknown MFE: ${name}`);
    }

    try {
      // Show loading state
      targetElement.innerHTML = '<div class="loading">Loading...</div>';

      // Load with timeout
      await Promise.race([
        this.loadRemoteModule(config),
        this.timeout(5000), // 5 second timeout
      ]);

      // Mount the MFE
      const RemoteApp = this.remotes.get(name);
      targetElement.innerHTML = '';
      RemoteApp.default(targetElement);

      console.log(`✅ ${name} loaded successfully`);
    } catch (error) {
      console.error(`❌ Failed to load ${name}:`, error);

      // Show fallback UI
      targetElement.innerHTML = config.fallback;
    }
  }

  async loadRemoteModule(config) {
    if (this.remotes.has(config.container)) {
      return this.remotes.get(config.container);
    }

    await this.loadScript(config.url);
    const container = window[config.container];
    const factory = await container.get(config.module);
    const RemoteApp = factory();

    this.remotes.set(config.container, RemoteApp);
    return RemoteApp;
  }

  timeout(ms) {
    return new Promise((_, reject) =>
      setTimeout(() => reject(new Error('Timeout')), ms)
    );
  }
}
```

### **POC Integration with Existing Main App**

#### **Scenario 1: Legacy PHP Application**

```php
// existing-page.php
<?php
// Your existing PHP logic
$userData = getUserData($userId);
$permissions = getUserPermissions($userId);
?>

<div class="existing-content">
    <!-- Your existing HTML/PHP content -->
    <h1>Welcome <?= $userData['name'] ?></h1>

    <!-- NEW: MFE Integration Point -->
    <div class="mfe-section">
        <h2>Enhanced Features (React MFE)</h2>
        <div id="task-manager-mfe"
             data-user-id="<?= $userData['id'] ?>"
             data-permissions="<?= json_encode($permissions) ?>">
            <div class="mfe-placeholder">
                <p>Loading enhanced task manager...</p>
                <button onclick="loadTaskManager()">Load Now</button>
            </div>
        </div>
    </div>
</div>

<script>
function loadTaskManager() {
    const container = document.getElementById('task-manager-mfe');
    const userId = container.dataset.userId;
    const permissions = JSON.parse(container.dataset.permissions);

    // Load MFE with context from PHP
    window.mfePOC.loadMFE('taskManager', container, {
        userId: userId,
        permissions: permissions,
        apiEndpoint: '/api/tasks'
    });
}
</script>
```

#### **Scenario 2: WordPress/CMS Integration**

```php
// WordPress shortcode example
function mfe_task_manager_shortcode($atts) {
    $atts = shortcode_atts([
        'user_id' => get_current_user_id(),
        'height' => '400px'
    ], $atts);

    return sprintf(
        '<div id="wp-task-manager"
              data-user-id="%s"
              style="height: %s; border: 1px solid #ccc;">
            <div class="wp-mfe-loading">Loading Task Manager...</div>
         </div>
         <script>
            document.addEventListener("DOMContentLoaded", function() {
                if (window.mfePOC) {
                    window.mfePOC.loadMFE("taskManager",
                        document.getElementById("wp-task-manager"));
                }
            });
         </script>',
        esc_attr($atts['user_id']),
        esc_attr($atts['height'])
    );
}
add_shortcode('task_manager', 'mfe_task_manager_shortcode');
```

#### **Scenario 3: E-commerce Integration**

```javascript
// Product page MFE integration
class EcommerceMFEPOC {
  loadProductReviews(productId) {
    const container = document.getElementById('product-reviews');

    // Load reviews MFE with product context
    this.loadMFE('productReviews', container, {
      productId: productId,
      apiKey: window.shopConfig.apiKey,
      theme: window.shopConfig.theme,
    });
  }

  loadRecommendations(userId, productId) {
    const container = document.getElementById('recommendations');

    // Load ML-powered recommendations MFE
    this.loadMFE('recommendations', container, {
      userId: userId,
      currentProduct: productId,
      algorithm: 'collaborative-filtering',
    });
  }
}
```

### **POC Success Metrics**

#### **Technical Validation**

- [ ] Remote loads without errors
- [ ] React component renders correctly
- [ ] Data passes between main app and MFE
- [ ] Error states handle gracefully
- [ ] Performance is acceptable (<2s load time)

#### **Business Validation**

- [ ] Feature works as expected
- [ ] User experience is seamless
- [ ] No impact on existing functionality
- [ ] Team can develop independently

#### **Scalability Validation**

- [ ] Multiple MFEs can coexist
- [ ] Easy to add new MFEs
- [ ] Configuration is maintainable
- [ ] Deployment is independent

### **POC Presentation Template**

#### **Executive Summary**

```
✅ PROOF OF CONCEPT SUCCESSFUL

🎯 Goal: Integrate React micro-frontends into existing PHP application
📊 Result: 100% functional with zero impact on existing code
⚡ Performance: <2s load time, lazy loading
🛡️ Safety: Isolated failures, graceful degradation
👥 Team Impact: Independent development and deployment
```

#### **Technical Demo Script**

```
1. Show existing PHP page working normally
2. Click "Load MFE" button
3. Watch React component load dynamically
4. Demonstrate data flow between PHP and React
5. Simulate MFE server down (error handling)
6. Show multiple MFEs on same page
7. Demonstrate independent deployment
```

#### **Next Steps Recommendation**

```
Phase 1 (Week 1-2): Implement production MFE loader
Phase 2 (Week 3-4): Migrate first feature to MFE
Phase 3 (Month 2): Scale to multiple MFEs
Phase 4 (Month 3+): Full micro-frontend architecture
```

---

## **⚠️ Limitations & Gotchas - What You Need to Know**

### **🚨 Critical Limitations**

#### **1. Browser Compatibility**

```javascript
// Module Federation requires modern browsers
// ❌ Internet Explorer (any version)
// ❌ Safari < 11.1
// ❌ Chrome < 63
// ❌ Firefox < 67

// Check before loading MFEs
if (!window.fetch || !window.Promise) {
  console.error('Browser too old for Module Federation');
  // Show fallback UI
}
```

#### **2. Network Dependencies**

```
Single Point of Failure:
┌─────────────────┐    ┌─────────────────┐
│   Main App      │    │   Remote MFE    │
│   (localhost:8000) │◄──┤ (localhost:3002)│
└─────────────────┘    └─────────────────┘
                              │
                         If this goes down,
                         feature breaks!
```

**Mitigation Strategy:**

```javascript
// Always have fallbacks
const config = {
  taskManager: {
    url: 'http://localhost:3002/remoteEntry.js',
    fallback: '<div>Task Manager temporarily unavailable</div>',
    timeout: 5000, // Don't wait forever
    retries: 2, // Try again on failure
  },
};
```

#### **3. Shared Dependency Hell**

```javascript
// ❌ Version conflicts can break everything
// Main App uses React 18.2.0
// MFE A uses React 18.1.0
// MFE B uses React 17.0.0

// Webpack tries to resolve but may fail
shared: {
  react: {
    singleton: true, // Only one version allowed
    requiredVersion: '^18.0.0' // Strict version requirement
  }
}

// If versions don't match → Runtime errors!
```

### **🐛 Common Gotchas**

#### **1. CORS Issues in Development**

```javascript
// ❌ This will fail in production
const config = {
  url: 'http://localhost:3002/remoteEntry.js' // Different origin!
};

// ✅ Solutions:
// Option 1: Same domain in production
const config = {
  url: window.location.hostname === 'localhost'
    ? 'http://localhost:3002/remoteEntry.js'
    : '/mfe/task-manager/remoteEntry.js' // Same origin
};

// Option 2: Proper CORS headers
// In your MFE webpack config:
devServer: {
  headers: {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, PATCH, OPTIONS',
    'Access-Control-Allow-Headers': 'X-Requested-With, content-type, Authorization'
  }
}
```

#### **2. Memory Leaks**

```javascript
// ❌ MFEs don't clean up properly
class BadMFELoader {
  async loadMFE(name) {
    // Loads MFE but never cleans up
    // Event listeners, timers, subscriptions remain
    const RemoteApp = await this.getRemote(name);
    RemoteApp.mount(container);
    // No cleanup when navigating away!
  }
}

// ✅ Proper cleanup
class GoodMFELoader {
  loadedMFEs = new Map();

  async loadMFE(name) {
    const RemoteApp = await this.getRemote(name);
    const unmount = RemoteApp.mount(container);

    // Store cleanup function
    this.loadedMFEs.set(name, { unmount });
  }

  unloadMFE(name) {
    const mfe = this.loadedMFEs.get(name);
    if (mfe && mfe.unmount) {
      mfe.unmount(); // Clean up properly
    }
    this.loadedMFEs.delete(name);
  }
}

// In your React MFE, always provide cleanup:
const mount = (element) => {
  const root = ReactDOM.createRoot(element);
  root.render(<App />);

  // Return cleanup function
  return () => {
    root.unmount();
    // Clean up any global listeners, timers, etc.
  };
};
```

#### **3. CSS Conflicts**

```css
/* ❌ Global styles in MFEs can break main app */
/* In your React MFE: */
.button {
  background: red !important; /* Affects ALL buttons! */
}

/* ✅ Scope your MFE styles */
.react-task-manager .button {
  background: red;
}

/* Or use CSS modules/styled-components */
import styles from './Button.module.css';
// Automatically scoped
```

#### **4. State Management Conflicts**

```javascript
// ❌ Multiple Redux stores can conflict
// Main app has Redux store
// MFE also creates Redux store
// Both try to use window.__REDUX_DEVTOOLS_EXTENSION__

// ✅ Coordinate state management
// Option 1: Share store from main app
const mount = (element, { store }) => {
  return ReactDOM.render(
    <Provider store={store}>
      <App />
    </Provider>,
    element
  );
};

// Option 2: Use different state solutions
// Main app: Redux
// MFE: Zustand/Context (no conflicts)
```

### **🔧 Performance Gotchas**

#### **1. Bundle Size Explosion**

```javascript
// ❌ Each MFE bundles everything
// Task Manager MFE: 2MB (includes React, lodash, etc.)
// User Profile MFE: 1.8MB (includes React, moment, etc.)
// Dashboard MFE: 2.5MB (includes React, charts, etc.)
// Total: 6.3MB for 3 MFEs!

// ✅ Proper sharing configuration
shared: {
  react: { singleton: true },
  'react-dom': { singleton: true },
  lodash: { singleton: true },
  moment: { singleton: true },
  // Share common libraries
}
// Total: ~800KB shared + 3 small MFEs = 2MB total
```

#### **2. Loading Waterfalls**

```javascript
// ❌ Sequential loading
async loadMultipleMFEs() {
  await this.loadMFE('taskManager');    // 2s
  await this.loadMFE('userProfile');    // 2s
  await this.loadMFE('dashboard');      // 2s
  // Total: 6 seconds!
}

// ✅ Parallel loading
async loadMultipleMFEs() {
  await Promise.all([
    this.loadMFE('taskManager'),
    this.loadMFE('userProfile'),
    this.loadMFE('dashboard')
  ]);
  // Total: 2 seconds!
}
```

#### **3. Caching Issues**

```javascript
// ❌ No caching strategy
// Every page load fetches remoteEntry.js again

// ✅ Implement caching
class CachedMFELoader {
  scriptCache = new Map();

  async loadScript(url) {
    if (this.scriptCache.has(url)) {
      return this.scriptCache.get(url);
    }

    const promise = new Promise((resolve, reject) => {
      const script = document.createElement('script');
      script.src = url;
      script.onload = resolve;
      script.onerror = reject;
      document.head.appendChild(script);
    });

    this.scriptCache.set(url, promise);
    return promise;
  }
}
```

### **🏗️ Architecture Gotchas**

#### **1. Circular Dependencies**

```javascript
// ❌ MFE A imports from MFE B, MFE B imports from MFE A
// This breaks Module Federation!

// Host App
//    ├── MFE A (imports MFE B)
//    └── MFE B (imports MFE A) ← Circular!

// ✅ Use shared libraries or host-provided utilities
// Host App
//    ├── Shared Utils
//    ├── MFE A (uses shared utils)
//    └── MFE B (uses shared utils)
```

#### **2. Version Drift**

```javascript
// ❌ MFEs developed independently drift apart
// Main App: Uses API v2
// MFE A: Still uses API v1
// MFE B: Already on API v3
// Result: Inconsistent behavior!

// ✅ Establish contracts and versioning
interface MFEContract {
  apiVersion: string;
  requiredProps: string[];
  events: string[];
}

const taskManagerContract: MFEContract = {
  apiVersion: '2.0',
  requiredProps: ['userId', 'permissions'],
  events: ['task.created', 'task.updated'],
};
```

#### **3. Testing Complexity**

```javascript
// ❌ Hard to test integrated behavior
// Unit tests pass for each MFE
// Integration fails in production

// ✅ Contract testing + E2E testing
// 1. Contract tests ensure MFE interfaces don't break
// 2. E2E tests verify full integration
// 3. Staging environment with all MFEs deployed
```

### **🔒 Security Gotchas**

#### **1. Code Injection Risks**

```javascript
// ❌ Loading arbitrary remote code
const userProvidedUrl = params.get('mfeUrl');
await this.loadMFE(userProvidedUrl); // DANGEROUS!

// ✅ Whitelist allowed remotes
const ALLOWED_REMOTES = {
  'task-manager': 'https://trusted-domain.com/task-manager/remoteEntry.js',
  'user-profile': 'https://trusted-domain.com/user-profile/remoteEntry.js',
};

if (!ALLOWED_REMOTES[mfeName]) {
  throw new Error('Unauthorized MFE');
}
```

#### **2. CSP (Content Security Policy) Issues**

```html
<!-- ❌ Strict CSP blocks dynamic script loading -->
<meta http-equiv="Content-Security-Policy" content="script-src 'self'" />
<!-- Blocks MFE loading! -->

<!-- ✅ Allow MFE domains -->
<meta
  http-equiv="Content-Security-Policy"
  content="script-src 'self' https://mfe-domain.com"
/>
```

### **🚀 Production Gotchas**

#### **1. Deployment Coordination**

```bash
# ❌ Deploy MFE without updating host
# Host expects MFE API v2
# New MFE only provides API v3
# Result: Runtime errors!

# ✅ Backward compatibility or coordinated deployment
# Option 1: MFE supports both v2 and v3
# Option 2: Deploy host first, then MFE
# Option 3: Feature flags for gradual rollout
```

#### **2. Monitoring & Debugging**

```javascript
// ❌ Hard to debug distributed MFEs
// Error occurs in MFE but logged in main app
// Which version of which MFE caused the issue?

// ✅ Proper error tracking
class MFELoader {
  async loadMFE(name) {
    try {
      const mfe = await this.loadRemote(name);

      // Track successful loads
      analytics.track('mfe.loaded', {
        name,
        version: mfe.version,
        loadTime: performance.now(),
      });
    } catch (error) {
      // Track failures with context
      analytics.track('mfe.failed', {
        name,
        error: error.message,
        userAgent: navigator.userAgent,
        timestamp: Date.now(),
      });
    }
  }
}
```

### **💡 Best Practices to Avoid Gotchas**

#### **1. Start Simple**

```javascript
// Don't try to share everything immediately
// Start with one MFE, learn the patterns, then scale
```

#### **2. Establish Contracts**

```typescript
// Define clear interfaces between host and MFEs
interface MFEProps {
  userId: string;
  theme: 'light' | 'dark';
  onUpdate?: (data: any) => void;
}

interface MFEExports {
  mount: (element: HTMLElement, props: MFEProps) => () => void;
  version: string;
}
```

#### **3. Plan for Failure**

```javascript
// Every MFE should have:
// - Fallback UI
// - Timeout handling
// - Retry logic
// - Error boundaries
```

#### **4. Monitor Everything**

```javascript
// Track:
// - Load times
// - Error rates
// - Version compatibility
// - User impact when MFEs fail
```

### **🎯 When NOT to Use MFEs**

#### **❌ Don't Use MFEs If:**

- **Small team** (< 5 developers) - overhead not worth it
- **Simple application** - traditional SPA is simpler
- **Tight coupling required** - shared state everywhere
- **Performance critical** - every millisecond matters
- **Limited browser support** - need IE support

#### **✅ Use MFEs When:**

- **Multiple teams** - independent development needed
- **Large application** - different domains/features
- **Technology diversity** - different React versions/frameworks
- **Independent deployment** - teams deploy separately
- **Gradual migration** - modernizing legacy apps

---

## **🚀 Next Steps**

1. **Start with Simple MFE** - Counter or hello world component
2. **Add Real Functionality** - Task manager, user profile, etc.
3. **Implement Error Boundaries** - Graceful failure handling
4. **Add State Management** - Redux, Zustand for complex apps
5. **Setup CI/CD** - Automated deployment for each MFE
6. **Monitor Performance** - Bundle size, loading times
7. **Scale Architecture** - Add unlimited remotes as needed

---

## **📚 Resources**

- [Module Federation Documentation](https://webpack.js.org/concepts/module-federation/)
- [Smarty Template Engine](https://www.smarty.net/)
- [React 18 Documentation](https://react.dev/)
- [Micro-Frontend Patterns](https://micro-frontends.org/)

---

**Happy coding! 🚀**
