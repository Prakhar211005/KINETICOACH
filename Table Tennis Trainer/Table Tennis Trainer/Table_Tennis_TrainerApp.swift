//  Created by Prakhar Sahu

import SwiftUI

@main
import Network
import ARKit

class PoseSender {
    var connection: NWConnection?
    let pcIP: String = "" // Dion needs to provide his IP
    let port: NWEndpoint.Port = 8888

    init() {
        let host = NWEndpoint.Host(pcIP)
        connection = NWConnection(host: host, port: port, using: .udp)
        connection?.start(queue: .global())
    }

    func sendJointData(jointName: String, x: Float, y: Float) {
        let message = "\(forehand):\(x),\(y)"
        let data = message.data(using: .utf8)
        
        connection?.send(content: data, completion: .contentProcessed({ error in
            if let error = error { print("Send error: \(error)") }
        }))
    }
}
