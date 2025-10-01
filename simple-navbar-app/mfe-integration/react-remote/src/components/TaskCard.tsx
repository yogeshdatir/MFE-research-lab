import React from 'react';

export interface Task {
  id: number;
  text: string;
  completed: boolean;
  priority?: 'low' | 'medium' | 'high';
}

export interface TaskCardProps {
  task: Task;
  onToggle?: (id: number) => void;
  onDelete?: (id: number) => void;
  showActions?: boolean;
}

export const TaskCard: React.FC<TaskCardProps> = ({
  task,
  onToggle,
  onDelete,
  showActions = true,
}) => {
  const getPriorityColor = (priority?: string) => {
    switch (priority) {
      case 'high':
        return '#ff6b6b';
      case 'medium':
        return '#feca57';
      case 'low':
        return '#48dbfb';
      default:
        return '#ddd';
    }
  };

  return (
    <div
      style={{
        border: '1px solid #e1e8ed',
        borderRadius: '8px',
        padding: '16px',
        margin: '8px 0',
        backgroundColor: task.completed ? '#f8f9fa' : 'white',
        boxShadow: '0 2px 4px rgba(0,0,0,0.1)',
        transition: 'all 0.2s ease',
        borderLeft: `4px solid ${getPriorityColor(task.priority)}`,
      }}
    >
      <div
        style={{
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'space-between',
        }}
      >
        <div style={{ display: 'flex', alignItems: 'center', flex: 1 }}>
          {showActions && (
            <input
              type="checkbox"
              checked={task.completed}
              onChange={() => onToggle?.(task.id)}
              style={{ marginRight: '12px', transform: 'scale(1.2)' }}
            />
          )}
          <span
            style={{
              textDecoration: task.completed ? 'line-through' : 'none',
              color: task.completed ? '#6c757d' : '#212529',
              fontSize: '16px',
              fontWeight: task.completed ? 'normal' : '500',
            }}
          >
            {task.text}
          </span>
          {task.priority && (
            <span
              style={{
                marginLeft: '12px',
                padding: '2px 8px',
                borderRadius: '12px',
                fontSize: '12px',
                fontWeight: 'bold',
                color: 'white',
                backgroundColor: getPriorityColor(task.priority),
                textTransform: 'uppercase',
              }}
            >
              {task.priority}
            </span>
          )}
        </div>
        {showActions && (
          <button
            onClick={() => onDelete?.(task.id)}
            style={{
              background: '#dc3545',
              color: 'white',
              border: 'none',
              borderRadius: '4px',
              padding: '6px 12px',
              cursor: 'pointer',
              fontSize: '12px',
              fontWeight: 'bold',
            }}
          >
            Delete
          </button>
        )}
      </div>
    </div>
  );
};

export default TaskCard;
