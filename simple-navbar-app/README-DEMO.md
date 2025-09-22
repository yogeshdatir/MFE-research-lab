# 🚀 Micro-Frontend Demo - Easy Setup

This is a complete **Micro-Frontend** demonstration that shows how modern web applications can be built using multiple technologies working together.

## 🎯 What This Demo Shows

- **PHP Smarty** application with responsive navigation
- **React** micro-frontend loaded dynamically
- **Module Federation** for runtime composition
- **TypeScript** for type safety
- **Modern UI** with animations and responsive design

## 🏃‍♂️ Quick Start (For Non-Technical Users)

### Step 1: Download the Project

Make sure you have this entire folder on your computer.

### Step 2: Run the Setup Script

Open Terminal (Mac/Linux) or Command Prompt (Windows) and navigate to this folder, then run:

```bash
./demo-setup.sh
```

**That's it!** The script will:

- ✅ Check if you have the required tools (PHP, Node.js, etc.)
- ✅ Install missing tools automatically
- ✅ Install all project dependencies
- ✅ Start all servers
- ✅ Open the demo in your browser

### Step 3: View the Demo

The demo will automatically open in your browser at:
**http://localhost:8000**

Click on the **"MFE Demo"** menu item to see the micro-frontend in action!

## 🛑 Stopping the Demo

To stop all servers, either:

- Press `Ctrl+C` in the terminal where the script is running
- Or run: `./stop-demo.sh`

## 🔧 What's Running

When the demo is active, you'll have:

| Service          | URL                                 | Description                 |
| ---------------- | ----------------------------------- | --------------------------- |
| **Main App**     | http://localhost:8000               | PHP Smarty application      |
| **MFE Demo**     | http://localhost:8000?page=mfe-demo | Micro-frontend showcase     |
| **Host App**     | http://localhost:3001               | TypeScript host application |
| **React Remote** | http://localhost:3002               | React task manager          |

## 🎮 How to Use the Demo

1. **Navigate the Main App**: Use the navbar to explore different pages
2. **Visit MFE Demo**: Click the "MFE Demo" menu (🚀 rocket icon)
3. **Load React App**: Click "Load React MFE" button to see the magic happen
4. **Interact**: Add tasks, mark them complete, filter them
5. **Responsive**: Try resizing your browser or viewing on mobile

## 🏗️ Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│   PHP Smarty    │    │   Host App       │    │  React Remote   │
│   (Port 8000)   │───▶│   (Port 3001)    │───▶│   (Port 3002)   │
│                 │    │                  │    │                 │
│ • Navigation    │    │ • Module Fed     │    │ • Task Manager  │
│ • Templates     │    │ • TypeScript     │    │ • React 18      │
│ • Routing       │    │ • Dynamic Import │    │ • Components    │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## 🆘 Troubleshooting

### If the script fails:

1. **Check Requirements**: Make sure you have admin/sudo access
2. **Port Conflicts**: The script will ask if you want to stop conflicting processes
3. **Manual Installation**: If auto-install fails, install these manually:
   - **PHP**: https://www.php.net/downloads
   - **Node.js**: https://nodejs.org/
   - **Composer**: https://getcomposer.org/

### If browsers don't open automatically:

Visit these URLs manually:

- Main demo: http://localhost:8000
- MFE demo: http://localhost:8000?page=mfe-demo

### If you see errors:

Check the log files in the `logs/` folder:

- `php-server.log`
- `host-app.log`
- `react-remote.log`

## 🎉 What Makes This Special

This demo showcases **real micro-frontend architecture**:

- ✅ **Independent Development**: Each app can be developed separately
- ✅ **Technology Diversity**: PHP + TypeScript + React working together
- ✅ **Runtime Composition**: Apps are combined at runtime, not build time
- ✅ **Shared Dependencies**: Optimized loading of common libraries
- ✅ **Error Handling**: Graceful fallbacks when remotes fail
- ✅ **Type Safety**: Full TypeScript support across the stack

## 📞 Support

If you need help:

1. Check the troubleshooting section above
2. Look at the log files in the `logs/` folder
3. Make sure all ports (8000, 3001, 3002) are available

---

**Enjoy exploring the future of web development! 🚀**
