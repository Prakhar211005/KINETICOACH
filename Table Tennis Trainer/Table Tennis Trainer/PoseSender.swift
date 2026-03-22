import Foundation
import Network

// We removed ': ObservableObject' to fix the protocol error
class MotionTransmitter {
    var connection: NWConnection?
    let pcIP = "10.130.94.71"
    let port: NWEndpoint.Port = 8888

    func sendJointData(joint: String, x: Float, y: Float) {
        let message = "\(joint):\(x),\(y)"
        print("DEBUG: Sending to Windows -> \(message)")
        guard let data = message.data(using: .utf8) else { return }
        
        if connection == nil {
            connection = NWConnection(host: NWEndpoint.Host(pcIP), port: port, using: .udp)
            connection?.start(queue: .global())
        }
        
        connection?.send(content: data, completion: .contentProcessed({ _ in }))
    }
}
