Table Tennis Trainer

Overview:

The Table Tennis Trainer is a cross-platform motion tracking system designed to capture and visualize human body movement in real time using an iPhone camera. The system leverages Apple ARKit for body tracking, transmits joint coordinate data via UDP, and renders the motion on a Windows WPF dashboard.

The long-term goal of this project is to provide an accessible and low-cost training tool that allows users to analyze their swing mechanics and eventually receive performance feedback, such as accuracy scoring.

Problem Statement:

Recreational and developing table tennis players often lack access to affordable tools that provide real-time feedback on their swing technique. Existing solutions are either expensive or require specialized hardware.

This project addresses that gap by using:

  - A standard iPhone camera
  - Real-time motion tracking
  - Cross-platform visualization

Features:

  - Real-time body tracking using ARKit
  - Extraction of wrist and elbow joint coordinates
  - UDP-based data transmission (Port 8888)
  - Windows dashboard visualization (red dot representation)
  - Live logging and debugging output
  - Basic C++ backend for player data management

In Progress / Planned:

  - Swing accuracy calculation system
  - Full UI redesign for dashboard
  - Direct integration between backend and motion data
  - Multi-joint tracking and advanced motion analytics
    
System Architecture
          iPhone (Swift + ARKit)
              ↓
          Joint Coordinate Extraction (Wrist, Elbow)
              ↓
          UDP Transmission (Port 8888)
              ↓
          Windows Dashboard (C# WPF)
              ↓
          Real-time Visualization (Red Dot)
               ↓
          C++ Backend (Terminal)
              ↓
          Player Data Management + CSV Storage (in Progress)
          
Technologies Used:

Layer	                 Technology
Motion Tracking	       Swift, ARKit
Networking	           UDP (Apple Network Framework)
Dashboard	             C#, WPF, XAML
Backend	               C++
Storage	               CSV


Setup Instructions:

1. Clone Repository
git clone <https://github.com/Prakhar211005/KINETICOACH.git>
cd TableTennisTrainer

2. iPhone Setup (Swift + ARKit)
Requirements:

  - macOS with Xcode installed
  - ARKit-compatible iPhone (tested on iPhone 16 Plus)
  - Same Wi-Fi network as Windows machine
Steps:

  - Open the .xcodeproj file in Xcode
  - Connect your iPhone via USB
  - Select your device as the run target
  - Locate the UDP sender file (e.g., MotionTransmitter.swift)
  - Update the IP address:
      let host = NWEndpoint.Host("YOUR_WINDOWS_IP")
      let port = NWEndpoint.Port(integerLiteral: 8888)
  - Run the app on your iPhone
  - Allow camera permissions when prompted
3. Windows Dashboard Setup (WPF)
Requirements:

  - Windows machine
  - Visual Studio (2022 or newer)
  - .NET framework installed

Steps:

  - Open the .sln file in Visual Studio
  - Build the solution
  - Run the application

Expected Behavior:

  - Black background canvas appears
  - Red dot appears (test or live data)
  - Console logs show incoming UDP data

4. C++ Backend Setup
Requirements:

  C++ compiler (g++, Visual Studio, or CLion)

Compile & Run:
  g++ main.cpp -o trainer
  ./trainer
  
Features:

  - Player login system
  - Unique ID + password validation
  - CSV-based data storage
  - Menu-driven interface


Networking Configuration
Important Requirements:

  - iPhone and Windows must be on the same network
  - UDP port 8888 must be available

Find Windows IP Address:
  - ipconfig

Look for:

  - IPv4 Address
  - Allow UDP Port (Windows Firewall)

  - Run Command Prompt as Administrator:

    netsh advfirewall firewall add rule name="UDP 8888" dir=in action=allow protocol=UDP localport=8888


Data Format

Data sent from iPhone:

Wrist:0.23,0.41 (example)
Elbow:0.12,0.35 (example)

Format Explanation:

  - JointName:x,y
  - Coordinates are normalized values between -1 and 1

Testing Instructions
Manual Testing:
  - Stand ~6 feet from the camera
  - Ensure the full body is visible
  - Move your arm
  - Observe red dot movement

Debug Verification

Swift Console:

  Sent: Wrist:0.23,0.41 (example)

WPF Console:

  RAW RECEIVED: Wrist:0.23,0.41 (example)

If both appear → system is working

Known Issues:

  - Joint tracking becomes unstable during fast motion
  - Requires manual IP configuration
  - UDP packets may occasionally drop
  - UI is minimal and not fully designed
  - No accuracy calculation implemented yet

Troubleshooting
No Data on Windows:

  - Check IP address in Swift
  - Ensure same Wi-Fi network
  - Verify firewall settings
  - Restart WPF application

No Red Dot:

  - Check if logs show RAW RECEIVED
  - Ensure correct data format (Wrist:x,y)
  - Confirm Canvas is rendering correctly

Project Structure

TableTennisTrainer/
│
├── iOS-App/           # Swift + ARKit code
├── WPF-Dashboard/     # C# + XAML UI
├── Cpp-Backend/       # Terminal-based system
├── players.csv        # Data storage
└── README.md

Team

Prakhar Sahu — Systems & Hardware Lead

ARKit integration
UDP communication
System architecture

Dion Chen — UI/UX & Quality Lead

WPF dashboard
UI rendering
Testing and validation

Future Work:

  - Implement swing accuracy calculation
  - Improve dashboard UI/UX
  - Add multi-joint tracking
  - Automate network configuration
  - Integrate backend with live motion data

References:

  - Apple Inc. (2025). ARKit  Body Tracking Configuration. https://developer.apple.com/documentation/arkit/arbodytrackingconfiguration 

  - Apple Inc. (2025). Network Framework. Sending and Receiving Data. https://developer.apple.com/documentation/network 

  - Microsoft. (2025). Windows Presentation Foundation (WPF) Overview. https://learn.microsoft.com/en-us/dotnet/desktop/wpf/ 

  - Microsoft. (2025). UdpClient Class .NET Documentation. https://learn.microsoft.com/en-us/dotnet/api/system.net.sockets.udpclient 

  - ISO. (2005). ISO/IEC 14882: Programming Languages C++. International Organization for Standardization. 

  - RFC 768. (1980). User Datagram Protocol (UDP). Retrieved from https://datatracker.ietf.org/doc/html/rfc768 

Note:

This project is a prototype system demonstrating the feasibility of real-time motion tracking and visualization using consumer hardware. Further development is required to achieve production-level performance and usability.
