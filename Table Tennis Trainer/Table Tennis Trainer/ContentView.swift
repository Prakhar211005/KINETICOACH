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
                guard let bodyAnchor = anchor as? ARBodyAnchor else {
                    continue
                }

                let elbowJoint = ARSkeleton.JointName(rawValue: "right_forearm_joint")
                let wristJoint = ARSkeleton.JointName(rawValue: "right_hand_joint")

                if let elbowTransform = bodyAnchor.skeleton.modelTransform(for: elbowJoint) {
                    let ex = elbowTransform.columns.3.x
                    let ey = elbowTransform.columns.3.y

                    poseSender.sendJointData(joint: "Elbow", x: ex, y: ey)
                    print("Elbow:", ex, ey)
                } else {
                    print("Elbow joint not found")
                }

                if let wristTransform = bodyAnchor.skeleton.modelTransform(for: wristJoint) {
                    let wx = wristTransform.columns.3.x
                    let wy = wristTransform.columns.3.y

                    poseSender.sendJointData(joint: "Wrist", x: wx, y: wy)
                    print("Wrist:", wx, wy)
                } else {
                    print("Wrist joint not found")
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
