# 🔄 **Micro-Frontend Component Sharing Demo**

A complete demonstration of cross-MFE component sharing using PHP Smarty, webpack Module Federation, and React micro-frontends.

## 🎯 **What This Demo Shows**

This project demonstrates **enterprise-grade micro-frontend architecture** with:

- ✅ **Cross-MFE Component Sharing** - Components shared between different micro-frontends at runtime
- ✅ **Webpack Module Federation** - Industry-standard MFE orchestration
- ✅ **PHP Smarty Integration** - Legacy application hosting modern MFEs
- ✅ **TypeScript Support** - Full type safety across MFE boundaries
- ✅ **Clean Architecture** - Simplified, production-ready setup

## 🏗️ **Architecture Overview**

```
PHP Smarty Application (Host - Port 8000)
├── Integrated Webpack MFE Host
│   ├── Orchestrates component sharing
│   └── Manages shared dependencies (React, ReactDOM)
├── Task Manager MFE (Port 3002)
│   ├── Exposes: TaskCard component
│   └── Original task management functionality
└── Dashboard MFE (Port 3003)
    ├── Imports: TaskCard from Task Manager
    └── Demonstrates component reuse
```

## 🚀 **Quick Start**

### **Option 1: Automated Setup (Recommended)**

```bash
cd simple-navbar-app
./demo-setup.sh
```

This script will:

- Install all dependencies
- Build the webpack host
- Start all MFE services
- Start the PHP server
- Open the demo in your browser

### **Option 2: Manual Setup**

```bash
# 1. Build the webpack host
cd webpack-mfe-host
yarn install && ./build.sh

# 2. Start MFE services
cd ../mfe-integration
./start-all.sh

# 3. Start PHP server (in another terminal)
cd ..
php -S localhost:8000

# 4. Visit http://localhost:8000
```

## 🎯 **Demo Instructions**

1. **Visit**: http://localhost:8000
2. **Home Page**: Overview of the component sharing architecture
3. **Task Manager**: See the original TaskCard component in action
4. **Dashboard**: See the same TaskCard component imported and reused

## 📋 **Key Features Demonstrated**

### **🔄 Component Sharing**

- **TaskCard** component is defined in Task Manager MFE
- **Dashboard** MFE imports and reuses TaskCard
- **Same styling and behavior** across both MFEs
- **Runtime sharing** - no build-time coupling

### **🏗️ Enterprise Architecture**

- **Module Federation** - Webpack 5's native MFE solution
- **Shared Dependencies** - React/ReactDOM shared across MFEs
- **Type Safety** - Full TypeScript support
- **Error Boundaries** - Graceful fallback handling

### **🎨 Clean Integration**

- **No Port 3001** - Webpack host integrated directly into Smarty
- **Simplified Navigation** - Only essential demo pages
- **Clear Documentation** - Comprehensive guides and examples

## 📁 **Project Structure**

```
simple-navbar-app/
├── index.php                          # Main Smarty application
├── templates/                         # Smarty templates
│   ├── layout.tpl                    # Main layout with navigation
│   └── pages/                        # Page templates
│       ├── home.tpl                  # Demo overview
│       ├── tasks.tpl                 # Task Manager MFE page
│       └── dashboard.tpl             # Dashboard MFE page
├── webpack-mfe-host/                  # Webpack Module Federation host
│   ├── src/mfe-orchestrator.ts      # Main orchestration logic
│   ├── webpack.config.js            # Module Federation config
│   └── dist/                        # Built files (copied to public/)
├── mfe-integration/                   # MFE applications
│   ├── react-remote/                # Task Manager MFE (port 3002)
│   │   └── src/components/TaskCard.tsx  # Shared component
│   ├── dashboard-mfe/               # Dashboard MFE (port 3003)
│   │   └── src/App.tsx             # Imports TaskCard
│   └── start-all.sh                # Start all MFEs
└── public/                          # Static assets
    └── webpack-mfe-host/           # Built webpack host files
```

## 🔧 **Technical Details**

### **Module Federation Configuration**

**Task Manager MFE (Exposes)**:

```javascript
exposes: {
  './App': './src/App.tsx',
  './TaskCard': './src/components/TaskCard.tsx'
}
```

**Dashboard MFE (Consumes)**:

```javascript
remotes: {
  taskManager: 'react_task_manager@http://localhost:3002/remoteEntry.js';
}
```

**Webpack Host (Orchestrates)**:

```javascript
remotes: {
  taskManager: 'react_task_manager@http://localhost:3002/remoteEntry.js',
  dashboard: 'react_dashboard@http://localhost:3003/remoteEntry.js'
}
```

### **Component Import Example**

```typescript
// In Dashboard MFE
import { TaskCard } from 'taskManager/TaskCard';

// Use the shared component
<TaskCard task={task} onToggle={handleToggle} onDelete={handleDelete} />;
```

## 📚 **Documentation**

- **[Webpack Host Implementation](./WEBPACK-HOST-IMPLEMENTATION.md)** - Complete implementation details
- **[Component Sharing Demo](./COMPONENT-SHARING-DEMO.md)** - Cross-MFE component sharing guide
- **[MFE Theory](./MFE-THEORY.md)** - Theoretical background
- **[POC Plan](./MFE-POC-PLAN.md)** - Project planning and estimates

## 🎯 **Benefits Demonstrated**

### **For Development Teams**

- **Independent Development** - Teams can work on MFEs independently
- **Component Reuse** - Share components across team boundaries
- **Technology Flexibility** - Different MFEs can use different tech stacks
- **Deployment Independence** - Deploy MFEs separately

### **For Enterprise Architecture**

- **Legacy Integration** - Modern MFEs in legacy applications (PHP Smarty)
- **Gradual Migration** - Incrementally modernize applications
- **Scalable Architecture** - Add new MFEs without affecting existing ones
- **Performance Optimization** - Shared dependencies and code splitting

## 🚀 **Next Steps**

1. **Explore the Demo** - Run the setup and explore all pages
2. **Modify Components** - Try changing TaskCard and see it update in both MFEs
3. **Add New MFEs** - Create additional micro-frontends
4. **Implement in Production** - Adapt the patterns for your use case

## 🎉 **Success Metrics**

This demo successfully shows:

- ✅ **Cross-MFE component sharing** working in production
- ✅ **Webpack Module Federation** integrated with PHP Smarty
- ✅ **Clean, maintainable architecture** with comprehensive documentation
- ✅ **Enterprise-ready patterns** suitable for large-scale applications

---

**Ready to explore micro-frontend component sharing? Run `./demo-setup.sh` and start the journey!** 🚀
