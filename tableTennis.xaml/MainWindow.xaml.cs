using System;
using System.Globalization;
using System.Net;
using System.Net.Sockets;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Media;
using System.Windows.Shapes;

namespace KinectViz
{
    public partial class MainWindow : Window
    {
        private UdpClient? udpServer;
        private const int Port = 8888;
        private bool isListening = true;

        public MainWindow()
        {
            InitializeComponent();

            AddLog("Application started.");

            StartListening();
        }

        private void StartListening()
        {
            try
            {
                udpServer = new UdpClient();

                udpServer.Client.SetSocketOption(
                    SocketOptionLevel.Socket,
                    SocketOptionName.ReuseAddress,
                    true
                );

                udpServer.Client.Bind(new IPEndPoint(IPAddress.Any, Port));

                AddLog("UDP receiver started on port " + Port);

                Task.Run(() =>
                {
                    IPEndPoint remoteEP = new IPEndPoint(IPAddress.Any, 0);

                    while (isListening)
                    {
                        try
                        {
                            byte[] receivedBytes = udpServer.Receive(ref remoteEP);

                            string message = Encoding.UTF8
                                .GetString(receivedBytes)
                                .Trim();

                            Dispatcher.Invoke(() =>
                            {
                                AddLog("RAW RECEIVED: " + message);

                                HandleIncomingData(message);
                            });
                        }
                        catch (ObjectDisposedException)
                        {
                            break;
                        }
                        catch (Exception ex)
                        {
                            Dispatcher.Invoke(() =>
                            {
                                AddLog("UDP receive error: " + ex.Message);
                            });
                        }
                    }
                });
            }
            catch (Exception ex)
            {
                AddLog("Failed to start UDP: " + ex.Message);
            }
        }

        private void HandleIncomingData(string data)
        {
            ReceivedDataText.Text = data;

            try
            {
                string[] mainParts = data.Split(':');

                if (mainParts.Length < 2)
                {
                    AddLog("Invalid format: " + data);
                    return;
                }

                string jointName = mainParts[0].Trim();

                string[] coords = mainParts[1].Split(',');

                if (coords.Length < 2)
                {
                    AddLog("Invalid coordinate format.");
                    return;
                }

                double x = double.Parse(
                    coords[0].Trim(),
                    CultureInfo.InvariantCulture
                );

                double y = double.Parse(
                    coords[1].Trim(),
                    CultureInfo.InvariantCulture
                );

                AddLog("Parsed X=" + x + " Y=" + y);

                if (jointName.Equals("Wrist",
                    StringComparison.OrdinalIgnoreCase))
                {
                    DrawDot(x, y);
                }
            }
            catch (Exception ex)
            {
                AddLog("Parsing error: " + ex.Message);
            }
        }

        private void DrawDot(double x, double y)
        {
            double width = SkeletonCanvas.ActualWidth;
            double height = SkeletonCanvas.ActualHeight;

            if (width <= 0 || height <= 0)
            {
                AddLog("Canvas size invalid.");
                return;
            }

            double canvasX = (x + 1) * width / 2;
            double canvasY = (1 - y) * height / 2;

            canvasX = Math.Max(0,
                Math.Min(width - 30, canvasX));

            canvasY = Math.Max(0,
                Math.Min(height - 30, canvasY));

            SkeletonCanvas.Children.Clear();

            Ellipse dot = new Ellipse
            {
                Width = 30,
                Height = 30,
                Fill = Brushes.Red
            };

            System.Windows.Controls.Canvas.SetLeft(dot, canvasX);
            System.Windows.Controls.Canvas.SetTop(dot, canvasY);

            SkeletonCanvas.Children.Add(dot);

            AddLog("Dot drawn.");
        }

        private void AddLog(string message)
        {
            string time =
                DateTime.Now.ToString("HH:mm:ss");

            LogBox.AppendText(
                "[" + time + "] " +
                message +
                Environment.NewLine
            );

            LogBox.ScrollToEnd();
        }

        protected override void OnClosed(EventArgs e)
        {
            isListening = false;

            udpServer?.Close();
            udpServer?.Dispose();

            base.OnClosed(e);
        }
    }
}
