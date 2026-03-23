// For data transmission 

using System;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;

namespace TableTennisDashboard
{
    public partial class MainWindow : Window
    {
        private UdpClient udpServer;
        private const int Port = 8888;

        public MainWindow()
        {
            InitializeComponent();
            StartListening();
        }

        private void StartListening()
        {
            udpServer = new UdpClient(Port);
            Task.Run(() => {
                while (true)
                {
                    var remoteEP = new IPEndPoint(IPAddress.Any, Port);
                    var data = udpServer.Receive(ref remoteEP);
                    string message = Encoding.UTF8.GetString(data);

                    // Logic
                    Dispatcher.Invoke(() => HandleIncomingData(message));
                }
            });
        }

        private void HandleIncomingData(string data)
        {
            Dispatcher.Invoke(() => {
                System.Diagnostics.Debug.WriteLine("UI Thread is updating!");
                CoordinateDisplay.Text = data;

                try
                {
                    CoordinateDisplay.Text = data; // Show raw text

                    // 1. Split "Elbow:0.5,1.2" into parts
                    string[] mainParts = data.Split(':');
                    if (mainParts.Length < 2) return;

                    string[] coords = mainParts[1].Split(',');
                    float rawX = float.Parse(coords[0]);
                    float rawY = float.Parse(coords[1]);

                    // 2. Map ARKit coordinates to Screen coordinates
                    // ARKit uses small values (meters), so we multiply to see movement
                    double screenX = (rawX * 10000) + (this.ActualWidth / 2);
                    double screenY = (rawY * -10000) + (this.ActualHeight / 2);

                    // 3. Move the dot
                    JointDot.Visibility = Visibility.Visible;
                    Canvas.SetLeft(JointDot, screenX);
                    Canvas.SetTop(JointDot, screenY);
                }
                catch { /* Handle parsing errors if data is malformed */ }
            });
        }
    }
}
