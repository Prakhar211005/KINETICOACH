import Foundation
import Network

class PoseSender {
    var connection: NWConnection?
    let pcIP = "10.130.94.71" 
    let port: NWEndpoint.Port = 8888

    func sendJointData(joint: String, x: Float, y: Float) {
        let message = "\(joint):\(x),\(y)"
        let data = message.data(using: .utf8)
        
        if connection == nil {
            connection = NWConnection(host: NWEndpoint.Host(pcIP), port: port, using: .udp)
            connection?.start(queue: .global())
        }
        
        connection?.send(content: data, completion: .contentProcessed({ _ in }))
    }
}
