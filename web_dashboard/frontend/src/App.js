import React from 'react';
import SkeletonCanvas from './SkeletonCanvas';

function App() {
  return (
    <div style={{ backgroundColor: '#121212', minHeight: '100vh', color: 'white', textAlign: 'center' }}>
      <h1>KINETICOACH Live Dashboard</h1>
      <p>Real-time Biometric Stream (Port 8888)</p>
      <SkeletonCanvas />
    </div>
  );
}

export default App;
