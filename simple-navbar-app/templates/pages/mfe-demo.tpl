<div class="page-header">
    <h1><i class="fas fa-rocket"></i> Micro-Frontend Demo</h1>
    <p class="page-subtitle">Experience the power of Module Federation with React integration</p>
</div>

<div class="mfe-demo-section">
    <div class="mfe-intro">
        <h2>🚀 What is Module Federation?</h2>
        <p>Module Federation is a revolutionary approach to building scalable web applications by allowing multiple independent applications to work together seamlessly.</p>
        
        <div class="mfe-benefits">
            <div class="benefit-card">
                <i class="fas fa-puzzle-piece"></i>
                <h3>Independent Development</h3>
                <p>Teams can develop and deploy micro-frontends independently</p>
            </div>
            <div class="benefit-card">
                <i class="fas fa-sync-alt"></i>
                <h3>Runtime Integration</h3>
                <p>Applications are composed at runtime, not build time</p>
            </div>
            <div class="benefit-card">
                <i class="fas fa-expand-arrows-alt"></i>
                <h3>Technology Agnostic</h3>
                <p>Mix different frameworks and technologies in one application</p>
            </div>
        </div>
    </div>

    <div class="mfe-demo-container">
        <div class="demo-controls">
            <h3>🎮 Interactive Demo</h3>
            <p>Click the button below to dynamically load a React micro-frontend:</p>
            <button id="load-mfe-btn" class="btn btn-primary">
                <i class="fas fa-play"></i>
                Load React MFE
            </button>
            <button id="clear-mfe-btn" class="btn btn-secondary" style="display: none;">
                <i class="fas fa-times"></i>
                Clear MFE
            </button>
        </div>

        <div id="mfe-container" class="mfe-iframe-container">
            <div class="mfe-placeholder">
                <i class="fas fa-rocket fa-3x"></i>
                <h3>Ready to Launch!</h3>
                <p>Click "Load React MFE" to see Module Federation in action</p>
                <div class="tech-stack">
                    <span class="tech-badge">TypeScript</span>
                    <span class="tech-badge">React</span>
                    <span class="tech-badge">Webpack 5</span>
                    <span class="tech-badge">Module Federation</span>
                </div>
            </div>
        </div>
    </div>

    <div class="architecture-section">
        <h2>🏗️ Architecture Overview</h2>
        <div class="architecture-diagram">
            <div class="arch-component host">
                <i class="fas fa-server"></i>
                <h4>Host Application</h4>
                <p>Vanilla TS/JS</p>
                <small>Port: 3001</small>
            </div>
            <div class="arch-arrow">→</div>
            <div class="arch-component remote">
                <i class="fab fa-react"></i>
                <h4>React Remote</h4>
                <p>Task Manager</p>
                <small>Port: 3002</small>
            </div>
            <div class="arch-arrow">→</div>
            <div class="arch-component php">
                <i class="fab fa-php"></i>
                <h4>PHP Integration</h4>
                <p>Smarty Templates</p>
                <small>Port: 8000</small>
            </div>
        </div>
    </div>

    <div class="features-showcase">
        <h2>✨ Key Features Demonstrated</h2>
        <div class="features-list">
            <div class="feature-item">
                <i class="fas fa-bolt"></i>
                <div>
                    <h4>Dynamic Loading</h4>
                    <p>React components loaded on-demand without page refresh</p>
                </div>
            </div>
            <div class="feature-item">
                <i class="fas fa-share-alt"></i>
                <div>
                    <h4>Shared Dependencies</h4>
                    <p>React and React-DOM shared between host and remote</p>
                </div>
            </div>
            <div class="feature-item">
                <i class="fas fa-mobile-alt"></i>
                <div>
                    <h4>Responsive Design</h4>
                    <p>Works seamlessly across all device sizes</p>
                </div>
            </div>
            <div class="feature-item">
                <i class="fas fa-code"></i>
                <div>
                    <h4>TypeScript Support</h4>
                    <p>Full TypeScript integration with type safety</p>
                </div>
            </div>
        </div>
    </div>

    <div class="getting-started">
        <h2>🚀 Getting Started</h2>
        <div class="steps-container">
            <div class="step">
                <div class="step-number">1</div>
                <div class="step-content">
                    <h4>Install Dependencies</h4>
                    <code>cd mfe-integration/host && yarn install</code>
                    <code>cd mfe-integration/react-remote && yarn install</code>
                </div>
            </div>
            <div class="step">
                <div class="step-number">2</div>
                <div class="step-content">
                    <h4>Start React Remote</h4>
                    <code>cd mfe-integration/react-remote && yarn start</code>
                    <small>Runs on http://localhost:3002</small>
                </div>
            </div>
            <div class="step">
                <div class="step-number">3</div>
                <div class="step-content">
                    <h4>Start Host Application</h4>
                    <code>cd mfe-integration/host && yarn start</code>
                    <small>Runs on http://localhost:3001</small>
                </div>
            </div>
            <div class="step">
                <div class="step-number">4</div>
                <div class="step-content">
                    <h4>Load MFE Demo</h4>
                    <p>Click the "Load React MFE" button above to see it in action!</p>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const loadBtn = document.getElementById('load-mfe-btn');
    const clearBtn = document.getElementById('clear-mfe-btn');
    const container = document.getElementById('mfe-container');
    
    let mfeLoaded = false;
    
    loadBtn.addEventListener('click', function() {
        if (mfeLoaded) return;
        
        // Show loading state
        container.innerHTML = `
            <div class="mfe-loading">
                <i class="fas fa-spinner fa-spin fa-2x"></i>
                <h3>Loading MFE Host...</h3>
                <p>Connecting to http://localhost:3001</p>
            </div>
        `;
        
        // Create iframe to load the MFE host
        setTimeout(() => {
            const iframe = document.createElement('iframe');
            iframe.src = 'http://localhost:3001';
            iframe.style.width = '100%';
            iframe.style.height = '600px';
            iframe.style.border = 'none';
            iframe.style.borderRadius = '10px';
            iframe.style.boxShadow = '0 5px 15px rgba(0,0,0,0.1)';
            
            iframe.onload = function() {
                mfeLoaded = true;
                loadBtn.style.display = 'none';
                clearBtn.style.display = 'inline-block';
            };
            
            iframe.onerror = function() {
                container.innerHTML = `
                    <div class="mfe-error">
                        <i class="fas fa-exclamation-triangle fa-2x"></i>
                        <h3>Failed to Load MFE</h3>
                        <p>Make sure the MFE host is running on port 3001</p>
                        <small>Run: cd mfe-integration/host && yarn start</small>
                    </div>
                `;
            };
            
            container.innerHTML = '';
            container.appendChild(iframe);
        }, 1000);
    });
    
    clearBtn.addEventListener('click', function() {
        container.innerHTML = `
            <div class="mfe-placeholder">
                <i class="fas fa-rocket fa-3x"></i>
                <h3>MFE Cleared!</h3>
                <p>Click "Load React MFE" to load it again</p>
                <div class="tech-stack">
                    <span class="tech-badge">TypeScript</span>
                    <span class="tech-badge">React</span>
                    <span class="tech-badge">Webpack 5</span>
                    <span class="tech-badge">Module Federation</span>
                </div>
            </div>
        `;
        mfeLoaded = false;
        loadBtn.style.display = 'inline-block';
        clearBtn.style.display = 'none';
    });
});
</script>
