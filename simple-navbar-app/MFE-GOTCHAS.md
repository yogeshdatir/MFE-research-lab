# ⚠️ **MFE Limitations & Gotchas**

Critical limitations, common pitfalls, and production considerations for micro-frontend architecture.

---

## **🚨 Critical Limitations**

### **1. Browser Compatibility**

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

### **2. Network Dependencies**

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

### **3. Shared Dependency Hell**

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

---

## **🐛 Common Gotchas**

### **1. CORS Issues in Development**

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

### **2. Memory Leaks**

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

### **3. CSS Conflicts**

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

### **4. State Management Conflicts**

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

---

## **🔧 Performance Gotchas**

### **1. Bundle Size Explosion**

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

### **2. Loading Waterfalls**

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

### **3. Caching Issues**

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

---

## **🏗️ Architecture Gotchas**

### **1. Circular Dependencies**

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

### **2. Version Drift**

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

### **3. Testing Complexity**

```javascript
// ❌ Hard to test integrated behavior
// Unit tests pass for each MFE
// Integration fails in production

// ✅ Contract testing + E2E testing
// 1. Contract tests ensure MFE interfaces don't break
// 2. E2E tests verify full integration
// 3. Staging environment with all MFEs deployed
```

---

## **🔒 Security Gotchas**

### **1. Code Injection Risks**

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

### **2. CSP (Content Security Policy) Issues**

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

---

## **🚀 Production Gotchas**

### **1. Deployment Coordination**

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

### **2. Monitoring & Debugging**

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

---

## **💡 Best Practices to Avoid Gotchas**

### **1. Start Simple**

```javascript
// Don't try to share everything immediately
// Start with one MFE, learn the patterns, then scale
```

### **2. Establish Contracts**

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

### **3. Plan for Failure**

```javascript
// Every MFE should have:
// - Fallback UI
// - Timeout handling
// - Retry logic
// - Error boundaries
```

### **4. Monitor Everything**

```javascript
// Track:
// - Load times
// - Error rates
// - Version compatibility
// - User impact when MFEs fail
```

---

## **🎯 When NOT to Use MFEs**

### **❌ Don't Use MFEs If:**

- **Small team** (< 5 developers) - overhead not worth it
- **Simple application** - traditional SPA is simpler
- **Tight coupling required** - shared state everywhere
- **Performance critical** - every millisecond matters
- **Limited browser support** - need IE support

### **✅ Use MFEs When:**

- **Multiple teams** - independent development needed
- **Large application** - different domains/features
- **Technology diversity** - different React versions/frameworks
- **Independent deployment** - teams deploy separately
- **Gradual migration** - modernizing legacy apps

---

## **🔧 Mitigation Strategies**

### **For Browser Compatibility**

```javascript
// Feature detection and graceful fallback
if (!window.fetch || !window.Promise || !window.WeakMap) {
  // Load polyfills or show fallback UI
  loadPolyfills().then(() => initMFEs());
} else {
  initMFEs();
}
```

### **For Network Issues**

```javascript
// Implement retry logic with exponential backoff
class RobustMFELoader {
  async loadWithRetry(url, maxRetries = 3) {
    for (let i = 0; i < maxRetries; i++) {
      try {
        return await this.loadMFE(url);
      } catch (error) {
        if (i === maxRetries - 1) throw error;
        await this.delay(Math.pow(2, i) * 1000); // Exponential backoff
      }
    }
  }
}
```

### **For Version Conflicts**

```javascript
// Strict version management
shared: {
  react: {
    singleton: true,
    strictVersion: true, // Fail if versions don't match exactly
    requiredVersion: '18.2.0'
  }
}
```

### **For Memory Leaks**

```javascript
// Automatic cleanup on page unload
window.addEventListener('beforeunload', () => {
  window.smartyMFEHost.cleanupAllMFEs();
});

// Periodic cleanup check
setInterval(() => {
  window.smartyMFEHost.checkForOrphanedMFEs();
}, 30000);
```

---

## **📊 Performance Monitoring**

### **Key Metrics to Track**

```javascript
// MFE Performance Metrics
const metrics = {
  loadTime: performance.now() - startTime,
  bundleSize: response.headers.get('content-length'),
  errorRate: failedLoads / totalLoads,
  cacheHitRate: cachedLoads / totalLoads,
  memoryUsage: performance.memory?.usedJSHeapSize,
};

// Send to analytics
analytics.track('mfe.performance', metrics);
```

### **Performance Budgets**

```javascript
// Set performance budgets
const PERFORMANCE_BUDGETS = {
  maxLoadTime: 2000, // 2 seconds
  maxBundleSize: 500 * 1024, // 500KB
  maxMemoryIncrease: 10 * 1024 * 1024, // 10MB
  maxErrorRate: 0.01, // 1%
};

// Alert if budgets exceeded
if (metrics.loadTime > PERFORMANCE_BUDGETS.maxLoadTime) {
  alert('MFE load time budget exceeded!');
}
```

---

**Remember: MFEs are powerful but complex. Start simple, understand the gotchas, and scale gradually!** ⚠️

For implementation guidance, see [Step-by-Step Guide](./MFE-STEP-BY-STEP.md).
For creating a POC, see [POC Creation Guide](./MFE-POC-GUIDE.md).
