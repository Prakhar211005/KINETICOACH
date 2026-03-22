import SwiftUI
import ARKit
import RealityKit

struct ContentView: View {
    
    @State private var transmitter = MotionTransmitter()

    var body: some View {
        ARViewContainer(transmitter: transmitter)
            .edgesIgnoringSafeArea(.all)
    }
}

struct ARViewContainer: UIViewRepresentable {
    let transmitter: MotionTransmitter

    func makeUIView(context: Context) -> ARSCNView {
        let arView = ARSCNView()
        let config = ARBodyTrackingConfiguration()
        arView.session.run(config)
        arView.session.delegate = context.coordinator
        return arView
    }

    func updateUIView(_ uiView: ARSCNView, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(transmitter: transmitter)
    }

    class Coordinator: NSObject, ARSessionDelegate {
        let transmitter: MotionTransmitter
        init(transmitter: MotionTransmitter) { self.transmitter = transmitter }
        
        func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
            for anchor in anchors {
                if let bodyAnchor = anchor as? ARBodyAnchor {
                    // We are using the specific 'elbow_right' and 'wrist_right' naming convention
                    let elbowJoint = ARSkeleton.JointName(rawValue: "elbow_right")
                    let wristJoint = ARSkeleton.JointName(rawValue: "wrist_right")
                    
                    let elbow = bodyAnchor.skeleton.modelTransform(for: elbowJoint)
                    let wrist = bodyAnchor.skeleton.modelTransform(for: wristJoint)
                    
                    // Extracting X and Y from the transform
                    let ex = elbow?.columns.3.x ?? 0
                    let ey = elbow?.columns.3.y ?? 0
                    let wx = wrist?.columns.3.x ?? 0
                    let wy = wrist?.columns.3.y ?? 0
                    
                    transmitter.sendJointData(joint: "Elbow", x: ex, y: ey)
                    transmitter.sendJointData(joint: "Wrist", x: wx, y: wy)
                }
            }
        }
        func session(_ session: ARSession, didFailWithError error: Error) {
            print("AR Session Failed: \(error.localizedDescription)")
        }

        func sessionWasInterrupted(_ session: ARSession) {
            print("AR Session Interrupted")
        }
    }
}
