import React, { useState, useEffect } from 'react';
import './App.css';

// TypeScript declaration for webpack federation
declare const __webpack_share_scopes__: any;

interface Task {
  id: number;
  text: string;
  completed: boolean;
  createdAt: Date;
}

export const ReactRemoteApp: React.FC = () => {
  const [tasks, setTasks] = useState<Task[]>([]);
  const [newTask, setNewTask] = useState('');
  const [filter, setFilter] = useState<'all' | 'active' | 'completed'>('all');

  useEffect(() => {
    // Initialize with some sample tasks
    setTasks([
      {
        id: 1,
        text: 'Welcome to React Remote MFE!',
        completed: false,
        createdAt: new Date(),
      },
      {
        id: 2,
        text: 'This is a micro-frontend',
        completed: true,
        createdAt: new Date(),
      },
      {
        id: 3,
        text: 'Built with Module Federation',
        completed: false,
        createdAt: new Date(),
      },
    ]);
  }, []);

  const addTask = () => {
    if (newTask.trim()) {
      const task: Task = {
        id: Date.now(),
        text: newTask.trim(),
        completed: false,
        createdAt: new Date(),
      };
      setTasks([...tasks, task]);
      setNewTask('');
    }
  };

  const toggleTask = (id: number) => {
    setTasks(
      tasks.map((task) =>
        task.id === id ? { ...task, completed: !task.completed } : task
      )
    );
  };

  const deleteTask = (id: number) => {
    setTasks(tasks.filter((task) => task.id !== id));
  };

  const filteredTasks = tasks.filter((task) => {
    if (filter === 'active') return !task.completed;
    if (filter === 'completed') return task.completed;
    return true;
  });

  const completedCount = tasks.filter((task) => task.completed).length;
  const activeCount = tasks.length - completedCount;

  return (
    <div className="react-remote-app">
      <div className="app-header">
        <h2>⚛️ React Remote Micro-Frontend testing</h2>
        <p>A simple task manager built with React and Module Federation</p>
      </div>

      <div className="task-input">
        <input
          type="text"
          value={newTask}
          onChange={(e) => setNewTask(e.target.value)}
          onKeyPress={(e) => e.key === 'Enter' && addTask()}
          placeholder="Add a new task..."
          className="task-input-field"
        />
        <button onClick={addTask} className="add-btn">
          Add Task
        </button>
      </div>

      <div className="task-filters">
        <button
          className={filter === 'all' ? 'filter-btn active' : 'filter-btn'}
          onClick={() => setFilter('all')}
        >
          All ({tasks.length})
        </button>
        <button
          className={filter === 'active' ? 'filter-btn active' : 'filter-btn'}
          onClick={() => setFilter('active')}
        >
          Active ({activeCount})
        </button>
        <button
          className={
            filter === 'completed' ? 'filter-btn active' : 'filter-btn'
          }
          onClick={() => setFilter('completed')}
        >
          Completed ({completedCount})
        </button>
      </div>

      <div className="task-list">
        {filteredTasks.length === 0 ? (
          <div className="empty-state">
            <p>No tasks found for the current filter.</p>
          </div>
        ) : (
          filteredTasks.map((task) => (
            <div
              key={task.id}
              className={`task-item ${task.completed ? 'completed' : ''}`}
            >
              <div className="task-content">
                <input
                  type="checkbox"
                  checked={task.completed}
                  onChange={() => toggleTask(task.id)}
                  className="task-checkbox"
                />
                <span className="task-text">{task.text}</span>
              </div>
              <div className="task-actions">
                <span className="task-date">
                  {task.createdAt.toLocaleDateString()}
                </span>
                <button
                  onClick={() => deleteTask(task.id)}
                  className="delete-btn"
                  title="Delete task"
                >
                  ×
                </button>
              </div>
            </div>
          ))
        )}
      </div>

      <div className="app-footer">
        <div className="stats">
          <span>Total: {tasks.length}</span>
          <span>Active: {activeCount}</span>
          <span>Completed: {completedCount}</span>
        </div>
        <div className="mfe-info">
          <small>🚀 Loaded via Module Federation</small>
        </div>
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

// Standalone mounting is now handled in bootstrap.tsx
// This keeps the App.tsx clean and focused on the component logic

export default mount;
