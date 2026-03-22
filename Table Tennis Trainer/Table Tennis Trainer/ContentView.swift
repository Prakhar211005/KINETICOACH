import SwiftUI
import ARKit
import Network

struct ContentView: View {
    @State private var sender = PoseSender()
    
    var body: some View {
        ARViewContainer(sender: sender)
            .edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    let sender: PoseSender
    
    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView()
        let config = ARBodyTrackingConfiguration() 
        arView.session.run(config)
        arView.session.delegate = context.coordinator
        return arView
    }
    
    func updateUIView(_ uiView: ARSCNView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(sender: sender)
    }
    
    class Coordinator: NSObject, ARSessionDelegate {
        let sender: PoseSender
        init(sender: PoseSender) { self.sender = sender }
        
        func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
            for anchor in anchors {
                if let bodyAnchor = anchor as? ARBodyAnchor {
                    // Extract 2D normalized coordinates (0.0 to 1.0)
                    let elbow = bodyAnchor.skeleton.modelTransform(for: .rightElbow)
                    let wrist = bodyAnchor.skeleton.modelTransform(for: .rightWrist)
                    
                    // Send to Windows PC
                    sender.sendJointData(joint: "Elbow", x: elbow.columns.3.x, y: elbow.columns.3.y)
                    sender.sendJointData(joint: "Wrist", x: wrist.columns.3.x, y: wrist.columns.3.y)
                }
            }
        }
    }
}
