import React, { useState, useEffect } from 'react';

// Import the shared TaskCard component from Task Manager MFE
// @ts-ignore - Module Federation type will be resolved at runtime
import { TaskCard } from 'taskManager/TaskCard';

// Define the Task interface (should match the one in TaskCard)
interface Task {
  id: number;
  text: string;
  completed: boolean;
  priority?: 'low' | 'medium' | 'high';
}

export const DashboardApp: React.FC = () => {
  const [sampleTasks, setSampleTasks] = useState<Task[]>([
    {
      id: 1,
      text: 'Review shared components demo',
      completed: false,
      priority: 'high',
    },
    {
      id: 2,
      text: 'Test cross-MFE communication',
      completed: true,
      priority: 'medium',
    },
    {
      id: 3,
      text: 'Document component sharing patterns',
      completed: false,
      priority: 'low',
    },
  ]);

  const handleToggleTask = (id: number) => {
    setSampleTasks((tasks) =>
      tasks.map((task) =>
        task.id === id ? { ...task, completed: !task.completed } : task
      )
    );
  };

  const handleDeleteTask = (id: number) => {
    setSampleTasks((tasks) => tasks.filter((task) => task.id !== id));
  };

  return (
    <div
      style={{
        padding: '20px',
        fontFamily:
          '-apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif',
        maxWidth: '800px',
        margin: '0 auto',
      }}
    >
      test
      <div
        style={{
          background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
          color: 'white',
          padding: '20px',
          borderRadius: '12px',
          marginBottom: '20px',
          textAlign: 'center',
        }}
      >
        <h1 style={{ margin: '0 0 10px 0', fontSize: '2rem' }}>
          🎯 Dashboard MFE
        </h1>
        <p style={{ margin: 0, opacity: 0.9 }}>
          Demonstrating cross-MFE component sharing with Module Federation
        </p>
      </div>
      <div
        style={{
          background: '#f8f9fa',
          padding: '20px',
          borderRadius: '8px',
          marginBottom: '20px',
          border: '2px dashed #28a745',
        }}
      >
        <h2 style={{ color: '#28a745', marginTop: 0 }}>
          ✨ Shared Component Demo
        </h2>
        <p style={{ color: '#6c757d', marginBottom: '16px' }}>
          The TaskCard components below are imported from the{' '}
          <strong>Task Manager MFE</strong>
          running on port 3002. This demonstrates true cross-MFE component
          sharing!
        </p>

        <div
          style={{
            background: 'white',
            padding: '16px',
            borderRadius: '6px',
            border: '1px solid #dee2e6',
          }}
        >
          <h3 style={{ marginTop: 0, color: '#495057' }}>
            Sample Tasks (using shared TaskCard)
          </h3>
          {sampleTasks.map((task) => (
            <TaskCard
              key={task.id}
              task={task}
              onToggle={handleToggleTask}
              onDelete={handleDeleteTask}
              showActions={true}
            />
          ))}
        </div>
      </div>
      <div
        style={{
          background: '#e9ecef',
          padding: '16px',
          borderRadius: '6px',
          fontSize: '14px',
          color: '#6c757d',
        }}
      >
        <h4 style={{ marginTop: 0, color: '#495057' }}>
          🔧 Technical Details:
        </h4>
        <ul style={{ marginBottom: 0, paddingLeft: '20px' }}>
          <li>
            <strong>Dashboard MFE</strong>: Running on port 3003
          </li>
          <li>
            <strong>Task Manager MFE</strong>: Running on port 3002 (source of
            TaskCard)
          </li>
          <li>
            <strong>Component Import</strong>:{' '}
            <code>import {`{ TaskCard }`} from 'taskManager/TaskCard'</code>
          </li>
          <li>
            <strong>Shared Dependencies</strong>: React and ReactDOM are shared
            between MFEs
          </li>
          <li>
            <strong>Type Safety</strong>: Full TypeScript support for shared
            components
          </li>
        </ul>
      </div>
    </div>
  );
};

// Mount function for Module Federation
const mount = (element: HTMLElement) => {
  const React = require('react');
  const ReactDOM = require('react-dom/client');
  const root = ReactDOM.createRoot(element);
  root.render(React.createElement(DashboardApp));
};

export default mount;
