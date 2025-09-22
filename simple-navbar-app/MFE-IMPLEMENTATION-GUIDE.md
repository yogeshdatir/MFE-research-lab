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
