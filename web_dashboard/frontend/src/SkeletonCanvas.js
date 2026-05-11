import React, { useEffect, useRef, useState } from 'react';
import io from 'socket.io-client';

const socket = io('http://localhost:4000');

const SkeletonCanvas = () => {
  const canvasRef = useRef(null);
  const [points, setPoints] = useState({ ex: 0, ey: 0, wx: 0, wy: 0 });

  useEffect(() => {
    socket.on('pose-data', (data) => {
      // Logic to parse the string format you used in your UDP tests [cite: 44]
      // Format example: "E:0.5,0.2|W:0.5,0.8"
      try {
        const parts = data.split('|');
        const elbow = parts[0].split(':')[1].split(',');
        const wrist = parts[1].split(':')[1].split(',');
        setPoints({
          ex: parseFloat(elbow[0]), ey: parseFloat(elbow[1]),
          wx: parseFloat(wrist[0]), wy: parseFloat(wrist[1])
        });
      } catch (e) { console.error("Parsing error", e); }
    });
  }, []);

  useEffect(() => {
    const ctx = canvasRef.current.getContext('2d');
    const { width, height } = canvasRef.current;
    ctx.clearRect(0, 0, width, height);

    // Draw Line (Elbow to Wrist)
    ctx.strokeStyle = '#00ffcc';
    ctx.lineWidth = 8;
    ctx.beginPath();
    ctx.moveTo(points.ex * width, points.ey * height);
    ctx.lineTo(points.wx * width, points.wy * height);
    ctx.stroke();

    // Draw Joints
    ctx.fillStyle = 'red';
    ctx.beginPath();
    ctx.arc(points.ex * width, points.ey * height, 10, 0, Math.PI * 2);
    ctx.arc(points.wx * width, points.wy * height, 10, 0, Math.PI * 2);
    ctx.fill();
  }, [points]);

  return <canvas ref={canvasRef} width={600} height={400} style={{ border: '2px solid #333', borderRadius: '10px' }} />;
};

export default SkeletonCanvas;
