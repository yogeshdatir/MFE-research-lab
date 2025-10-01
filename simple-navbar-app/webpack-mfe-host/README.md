# 🚀 Webpack Module Federation Host

A webpack-built Module Federation host that replaces the custom MFE loader for enterprise-grade micro-frontend orchestration.

## 📋 Overview

This webpack host provides:

- ✅ **Module Federation Integration** - Native webpack Module Federation support
- ✅ **Cross-MFE Component Sharing** - Share components between micro-frontends
- ✅ **Auto-Discovery** - Automatically loads MFEs based on DOM containers
- ✅ **TypeScript Support** - Full type safety for remote modules
- ✅ **Error Boundaries** - Graceful error handling and fallbacks
- ✅ **Performance Optimization** - Bundle splitting and shared dependencies

## 🏗️ Architecture

```
Smarty Application (Host)
├── webpack-mfe-host/dist/main.js (This bundle)
├── React Task Manager MFE (localhost:3002)
└── Future MFEs (localhost:3003+)
```

## 🚀 Quick Start

### Production Build (Main Usage - Smarty Integration)

```bash
# Install dependencies
yarn install

# Build for production and copy to Smarty
./build.sh
```

### Development Mode (Optional - Standalone Testing)

```bash
# Start development server for testing
yarn start
# or
./dev.sh

# Visit http://localhost:3001 (for testing only)
```

**Note**: The main usage is integrated into Smarty. The standalone dev server is only for testing the webpack host in isolation.

## 📦 Integration with Smarty

The webpack host is automatically integrated with your Smarty application:

1. **Build Process**: Run `./build.sh` to build and copy files
2. **Smarty Template**: Already includes the webpack bundle
3. **Auto-Discovery**: MFEs load automatically when containers are present

### Template Integration

```smarty
<!-- Already included in layout.tpl -->
<script src="public/webpack-mfe-host/main.js"></script>
```

### Container Setup

```smarty
<!-- MFE will auto-load when this container exists -->
<div id="task-manager-container"></div>
```

## 🔧 Configuration

### Adding New MFEs

1. **Update webpack.config.js**:

```javascript
remotes: {
  taskManager: 'react_task_manager@http://localhost:3002/remoteEntry.js',
  userProfile: 'react_user_profile@http://localhost:3003/remoteEntry.js', // Add new remote
}
```

2. **Update src/types.d.ts**:

```typescript
declare module 'userProfile/App' {
  const mount: (element: HTMLElement) => void;
  export default mount;
}
```

3. **Update MFE Registry in src/mfe-orchestrator.ts**:

```typescript
private remoteConfigs: MFERegistry = {
  taskManager: { /* existing config */ },
  userProfile: {
    name: 'react_user_profile',
    url: 'http://localhost:3003/remoteEntry.js',
    module: './App',
    containerId: 'user-profile-container',
    scope: 'userProfile'
  }
};
```

### Dynamic Remote Addition

```javascript
// Add remotes at runtime
window.webpackMFEHost.addRemote('newMFE', {
  name: 'new_mfe',
  url: 'http://localhost:3004/remoteEntry.js',
  module: './App',
  containerId: 'new-mfe-container',
  scope: 'newMFE',
});
```

## 🎯 API Reference

### Global Functions

```javascript
// Load MFE manually
window.loadMFE('taskManager');

// Unload MFE
window.unloadMFE('taskManager');

// Access host instance
window.webpackMFEHost.getAvailableRemotes();
window.webpackMFEHost.getLoadedRemotes();
```

### WebpackMFEHost Class

```typescript
class WebpackMFEHost {
  loadMFE(remoteName: string, containerId?: string): Promise<boolean>;
  unloadMFE(remoteName: string): void;
  addRemote(name: string, config: MFEConfig): void;
  getAvailableRemotes(): string[];
  getLoadedRemotes(): string[];
  getRemoteConfig(remoteName: string): MFEConfig | undefined;
  updateRemoteConfig(remoteName: string, config: Partial<MFEConfig>): void;
}
```

## 🔄 Cross-MFE Component Sharing

### Exposing Components

In your MFE's webpack.config.js:

```javascript
new ModuleFederationPlugin({
  name: 'react_task_manager',
  exposes: {
    './App': './src/App.tsx',
    './TaskList': './src/components/TaskList.tsx',
    './TaskItem': './src/components/TaskItem.tsx',
  },
});
```

### Importing Components

In another MFE:

```typescript
import { TaskList } from 'taskManager/TaskList';
import { TaskItem } from 'taskManager/TaskItem';

const MyComponent = () => (
  <div>
    <TaskList />
    <TaskItem task={task} />
  </div>
);
```

## 🎨 Styling

The webpack host includes built-in styles for:

- Loading states (`mfe-loading`)
- Error states (`mfe-error`)
- Placeholder states (`mfe-placeholder`)
- Responsive design

Custom styles can be added to `src/styles.css`.

## 🐛 Debugging

### Development Tools

```javascript
// Show host information
window.webpackMFEHost.getAvailableRemotes();
window.webpackMFEHost.getLoadedRemotes();

// Check remote configuration
window.webpackMFEHost.getRemoteConfig('taskManager');
```

### Common Issues

1. **MFE Not Loading**: Check console for network errors, verify remote URL
2. **Type Errors**: Update `src/types.d.ts` with correct module declarations
3. **Shared Dependencies**: Ensure React versions match across MFEs

## 📊 Performance

### Bundle Analysis

```bash
# Analyze bundle size
yarn build --analyze

# Check shared dependencies
yarn webpack-bundle-analyzer dist/main.js
```

### Optimization Features

- Code splitting for each MFE
- Shared React/ReactDOM dependencies
- Lazy loading of remote modules
- Optimized chunk loading

## 🔒 Security

- Content Security Policy compatible
- Remote source validation
- Error boundary isolation
- Dependency vulnerability scanning

## 📈 Monitoring

The host provides built-in monitoring for:

- MFE load times
- Error rates
- Bundle sizes
- Network requests

Access via `window.webpackMFEHost` for custom monitoring integration.

## 🚀 Deployment

### Production Checklist

- [ ] Run `yarn build` to create production bundle
- [ ] Copy `dist/*` to `public/webpack-mfe-host/`
- [ ] Verify all remote URLs are accessible
- [ ] Test MFE loading in production environment
- [ ] Monitor performance metrics

### CI/CD Integration

```bash
# In your CI/CD pipeline
cd webpack-mfe-host
yarn install --frozen-lockfile
yarn build
cp -r dist/* ../public/webpack-mfe-host/
```

## 🤝 Contributing

1. Make changes to TypeScript files in `src/`
2. Update type declarations in `src/types.d.ts`
3. Test with `yarn start` (development server)
4. Build with `yarn build`
5. Test integration with Smarty app

## 📚 Related Documentation

- [MFE Theory & Concepts](../MFE-THEORY.md)
- [Step-by-Step Implementation](../MFE-STEP-BY-STEP.md)
- [MFE Gotchas & Limitations](../MFE-GOTCHAS.md)
- [POC Implementation Plan](../MFE-POC-PLAN.md)

---

**This webpack host provides enterprise-grade MFE orchestration with Module Federation's full power!** 🎯
