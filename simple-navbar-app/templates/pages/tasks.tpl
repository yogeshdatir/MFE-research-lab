<div class="page-header">
    <h1><i class="fas fa-tasks"></i> Task Manager</h1>
    <p class="page-subtitle">Manage your tasks with our React-powered micro-frontend</p>
</div>

<div class="tasks-page-content">
    <div class="mfe-info-banner">
        <div class="info-content">
            <h3>🚀 Powered by Micro-Frontend Architecture</h3>
            <p>This task manager is a <strong>React micro-frontend</strong> loaded dynamically into this Smarty page. It demonstrates how you can extend your PHP application with modern React components.</p>
            <div class="tech-badges">
                <span class="tech-badge">React 18</span>
                <span class="tech-badge">Module Federation</span>
                <span class="tech-badge">TypeScript</span>
                <span class="tech-badge">Smarty Integration</span>
            </div>
        </div>
    </div>

    <!-- This container will automatically load the React Task Manager -->
    <div id="task-manager-container" class="mfe-container">
        <div class="mfe-loading">
            <i class="fas fa-spinner fa-spin fa-2x"></i>
            <h3>Loading Task Manager...</h3>
            <p>Please wait while we load the React micro-frontend</p>
        </div>
    </div>

    <div class="mfe-controls">
        <h3>🎮 MFE Controls</h3>
        <div class="control-buttons">
            <button onclick="loadMFE('taskManager')" class="btn btn-primary">
                <i class="fas fa-play"></i>
                Reload Task Manager
            </button>
            <button onclick="unloadMFE('taskManager')" class="btn btn-secondary">
                <i class="fas fa-stop"></i>
                Unload Task Manager
            </button>
        </div>
        <p class="control-info">
            Use these controls to manually reload or unload the micro-frontend. 
            The Task Manager will auto-load when you visit this page.
        </p>
    </div>

    <div class="integration-details">
        <h3>🔧 How This Works</h3>
        <div class="details-grid">
            <div class="detail-card">
                <i class="fas fa-server"></i>
                <h4>Smarty Host</h4>
                <p>This PHP page serves as the host, providing the layout and navigation while dynamically loading React components.</p>
            </div>
            <div class="detail-card">
                <i class="fab fa-react"></i>
                <h4>React Remote</h4>
                <p>The Task Manager runs as an independent React application that can be developed and deployed separately.</p>
            </div>
            <div class="detail-card">
                <i class="fas fa-plug"></i>
                <h4>Runtime Integration</h4>
                <p>Components are loaded at runtime using Module Federation, allowing for true micro-frontend architecture.</p>
            </div>
        </div>
    </div>

    <div class="benefits-section">
        <h3>✨ Benefits of This Approach</h3>
        <div class="benefits-list">
            <div class="benefit-item">
                <i class="fas fa-users"></i>
                <div>
                    <h4>Team Independence</h4>
                    <p>Different teams can work on PHP and React parts independently</p>
                </div>
            </div>
            <div class="benefit-item">
                <i class="fas fa-rocket"></i>
                <div>
                    <h4>Gradual Migration</h4>
                    <p>Modernize your PHP app piece by piece without full rewrites</p>
                </div>
            </div>
            <div class="benefit-item">
                <i class="fas fa-puzzle-piece"></i>
                <div>
                    <h4>Technology Mix</h4>
                    <p>Use the best tool for each job - PHP for backend, React for interactive UIs</p>
                </div>
            </div>
            <div class="benefit-item">
                <i class="fas fa-sync-alt"></i>
                <div>
                    <h4>Independent Deployment</h4>
                    <p>Deploy React components without touching the main PHP application</p>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
/* Tasks page specific styles */
.tasks-page-content {
    padding: 20px 0;
}

.mfe-info-banner {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    color: white;
    padding: 30px;
    border-radius: 10px;
    margin-bottom: 30px;
    text-align: center;
}

.info-content h3 {
    margin-bottom: 15px;
    font-size: 1.5rem;
}

.tech-badges {
    margin-top: 20px;
    display: flex;
    justify-content: center;
    gap: 10px;
    flex-wrap: wrap;
}

.tech-badge {
    background: rgba(255,255,255,0.2);
    padding: 5px 12px;
    border-radius: 15px;
    font-size: 0.8rem;
    font-weight: 500;
}

.mfe-container {
    background: white;
    border-radius: 10px;
    box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    margin-bottom: 30px;
    min-height: 500px;
    overflow: hidden;
}

.mfe-controls {
    background: #f8f9fa;
    padding: 30px;
    border-radius: 10px;
    text-align: center;
    margin-bottom: 30px;
}

.control-buttons {
    margin: 20px 0;
    display: flex;
    gap: 15px;
    justify-content: center;
    flex-wrap: wrap;
}

.control-info {
    color: #666;
    font-size: 0.9rem;
    margin-top: 15px;
}

.integration-details {
    margin-bottom: 30px;
}

.integration-details h3 {
    color: #333;
    text-align: center;
    margin-bottom: 30px;
}

.details-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
    gap: 20px;
}

.detail-card {
    background: white;
    padding: 30px 20px;
    border-radius: 10px;
    box-shadow: 0 5px 15px rgba(0,0,0,0.1);
    text-align: center;
    transition: transform 0.3s ease;
}

.detail-card:hover {
    transform: translateY(-5px);
}

.detail-card i {
    font-size: 2.5rem;
    color: #667eea;
    margin-bottom: 15px;
}

.detail-card h4 {
    color: #333;
    margin-bottom: 10px;
}

.benefits-section h3 {
    color: #333;
    text-align: center;
    margin-bottom: 30px;
}

.benefits-list {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
    gap: 20px;
}

.benefit-item {
    display: flex;
    align-items: flex-start;
    gap: 15px;
    padding: 20px;
    background: white;
    border-radius: 10px;
    box-shadow: 0 5px 15px rgba(0,0,0,0.1);
}

.benefit-item i {
    font-size: 1.5rem;
    color: #667eea;
    margin-top: 5px;
}

.benefit-item h4 {
    color: #333;
    margin-bottom: 5px;
}

.benefit-item p {
    color: #666;
    font-size: 0.9rem;
}

@media (max-width: 768px) {
    .control-buttons {
        flex-direction: column;
        align-items: center;
    }
    
    .details-grid {
        grid-template-columns: 1fr;
    }
    
    .benefits-list {
        grid-template-columns: 1fr;
    }
    
    .benefit-item {
        flex-direction: column;
        text-align: center;
    }
}
</style>
