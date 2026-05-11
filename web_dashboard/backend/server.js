const dgram = require('dgram');
const io = require('socket.io')(4000, {
  cors: { origin: "*" }
});

const udpSocket = dgram.createSocket('udp4');

udpSocket.on('message', (msg) => {
  const data = msg.toString();
  console.log("Receiving Pose:", data);
  io.emit('pose-data', data); // Push to React
});

udpSocket.bind(8888, () => {
  console.log("UDP Bridge active on Port 8888");
});
