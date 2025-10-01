<div class="hero-section">
    <div class="hero-content">
        <h1><i class="fas fa-share-alt"></i> Micro-Frontend Component Sharing Demo</h1>
        <p class="hero-subtitle">Demonstrating cross-MFE component sharing with webpack Module Federation</p>
        <div class="hero-buttons">
            <a href="?page=tasks" class="btn btn-primary">Task Manager MFE</a>
            <a href="?page=dashboard" class="btn btn-secondary">Dashboard with Shared Components</a>
        </div>
    </div>
</div>

<div class="features-section">
    <h2>🎯 Component Sharing Architecture</h2>
    <div class="features-grid">
        <div class="feature-card">
            <i class="fas fa-tasks"></i>
            <h3>Task Manager MFE</h3>
            <p>Exposes TaskCard component via Module Federation</p>
            <code style="font-size: 12px;">exposes: { './TaskCard': './src/components/TaskCard.tsx' }</code>
        </div>
        <div class="feature-card">
            <i class="fas fa-tachometer-alt"></i>
            <h3>Dashboard MFE</h3>
            <p>Imports and reuses TaskCard from Task Manager</p>
            <code style="font-size: 12px;">import { TaskCard } from 'taskManager/TaskCard'</code>
        </div>
        <div class="feature-card">
            <i class="fas fa-puzzle-piece"></i>
            <h3>Runtime Sharing</h3>
            <p>Components shared at runtime, not build time</p>
            <code style="font-size: 12px;">Webpack Module Federation orchestrates sharing</code>
        </div>
    </div>
    
    <div class="demo-steps" style="margin-top: 2rem; padding: 1.5rem; background: #f8f9fa; border-radius: 10px;">
        <h3>🚀 Try the Demo</h3>
        <ol style="text-align: left; max-width: 600px; margin: 0 auto;">
            <li><strong>Visit Task Manager:</strong> See the original TaskCard component</li>
            <li><strong>Visit Dashboard:</strong> See the same TaskCard imported and reused</li>
            <li><strong>Notice:</strong> Same styling, behavior, but different data</li>
        </ol>
    </div>
</div>
