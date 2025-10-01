<div class="hero-section">
    <h1>🎯 Dashboard</h1>
    <p>Cross-MFE Component Sharing Demo</p>
</div>

<div class="content-section">
    <div class="info-card">
        <h2>🔄 Component Sharing Demo</h2>
        <p>This Dashboard MFE imports and uses the <strong>TaskCard</strong> component from the Task Manager MFE, demonstrating true cross-MFE component sharing with Module Federation.</p>
        
        <div class="tech-details">
            <h3>Technical Details:</h3>
            <ul>
                <li><strong>Dashboard MFE</strong>: Port 3003</li>
                <li><strong>Task Manager MFE</strong>: Port 3002 (component source)</li>
                <li><strong>Import Statement</strong>: <code>import { TaskCard } from 'taskManager/TaskCard'</code></li>
                <li><strong>Shared Dependencies</strong>: React, ReactDOM</li>
            </ul>
        </div>
    </div>
    
    <!-- Dashboard MFE will auto-load here -->
    <div id="dashboard-container">
        <div class="mfe-placeholder">
            <i class="fas fa-tachometer-alt"></i>
            <h3>Loading Dashboard MFE...</h3>
            <p>The Dashboard micro-frontend will load here automatically</p>
        </div>
    </div>
</div>
