// For data transmission 

using System;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace KinectViz { 
    public partial class MainWindow: Window {
        private UdpClient udpServer;
        private const int Port = 8888; 

        public MainWindow() {
            InitializeComponent();
            StartListening();
        }

        private void StartListening() {
            udpServer = new UdpClient(Port);
            Task.Run(() => {
                while (true) {
                    var remoteEP = new IPEndPoint(IPAddress.Any, Port);
                    var data = udpServer.Receive(ref remoteEP);
                    string message = Encoding.UTF8.GetString(data);
                    
                    // Logic
                    Dispatcher.Invoke(() => HandleIncomingData(message));
                }
            });
        }

        private void HandleIncomingData(string data) {
            [cite_start]// To Add Trigonometry logic here [cite: 275]
            [cite_start]// To Update SkeletonCanvas here 
            Console.WriteLine($"Received: {data}");
        }
    }
}
