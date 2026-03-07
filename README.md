# KINETICOACH
A TABLE TENNIS MOTION ANALYSIS SOFTWARE

Project Vision:
KinetiCoach is a distributed AI system designed to provide real-time biomechanical feedback for table tennis players. By leveraging the A18 chip in the iPhone 16 Plus, the system extracts skeletal motion data and streams it to a desktop hub for performance evaluation.

Technical Architecture:
The project is split into three core modules:
  1. The Sensor
       - Technology: ARKit, RealityKit, Swift.
       - Function: Initializes a 2D body tracking session to isolate skeletal joints.
       - Key Output: Extracts normalized X and Y coordinates of the hitting arm (Shoulder, Elbow, Wrist).
  2. The Network Bridge (Systems)
       - Protocol: UDP (User Datagram Protocol).
       - Function: Streams coordinate packets over a local Wi-Fi connection to minimize latency.
       - Data Format: Joint_Name: X_Coord, Y_Coord (e.g., RightElbow: 0.52, 0.88).
  3. The Processor
       - Technology: C#, .NET, WPF.
       - Logic Engine (M2): Uses vector trigonometry to calculate joint angles and swing speed.
       - WPF Dashboard (M3): Displays a live skeletal overlay and performance metrics like form score and consistency.
    
 Setup Guide:
   1. Hardware Requirements
        - Mobile: iPhone 16 Plus (required for optimal A18 tracking performance).
        - Desktop: Windows 10/11 PC with .NET Framework installed.
        - Mounting: A tripod is required to maintain a stable camera angle for accurate 2D analysis.
    2. Environment Calibration
        - Distance: Stand 6–10 feet away from the camera to ensure your full range of motion is captured.
        - Lighting: Ensure the practice area is well-lit, as shadows can cause "jitter" in the 2D skeletal extraction.
    3. Running the System
        - PC Receiver: Open the Visual Studio project and start the WPF application. It will begin listening on Port 8888.
        - iPhone Sensor: Open the Xcode project. Ensure your PC's IP address is correctly entered in the sender script.
        - Authentication: Deploy the app to your physical device and grant Camera Permissions when prompted.
     
  Troubleshooting:
    - Latency Issues: Ensure both devices are on a 5GHz Wi-Fi band. UDP is fast, but network congestion can push latency above the 100ms threshold.
    - Tracking Drift: If the skeleton is misaligned, ensure you are wearing high-contrast clothing (different from the background) to help the 2D motion extraction.
    - Privacy Assurance: This system is built with a Security-First approach as no raw video is recorded or stored. Only numerical coordinate data is transmitted.
