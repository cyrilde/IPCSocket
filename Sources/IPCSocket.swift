//  Copyright © 2017 Cyril Deba. All rights reserved.
//
// 	Licensed under the Apache License, Version 2.0 (the "License");
// 	you may not use this file except in compliance with the License.
// 	You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// 	Unless required by applicable law or agreed to in writing, software
// 	distributed under the License is distributed on an "AS IS" BASIS,
// 	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// 	See the License for the specific language governing permissions and
// 	limitations under the License.
//

import Darwin

public class IPCSocket {
    
    // MARK: Public Constants
    
    public static let INVALID_FD = Int32(-1)
    public static let INVALID_PATH = ""
    
    
    // MARK: Public Properties
    
    public internal(set) var fd: Int32 = INVALID_FD
    public internal(set) var path:String = INVALID_PATH
    public internal(set) var isConnected: Bool = false

    
    // MARK: Lifecycle
    
    public init(with path: String) throws {
        try verifyPath(path)
        
        self.path = path
        
        self.fd = Darwin.socket(Int32(AF_UNIX), SOCK_STREAM, Int32(0))
        
        if self.fd == IPCSocket.INVALID_FD {
            throw IPCError.unableCreateSocket
        }
    }
    
    deinit {
        if self.fd != IPCSocket.INVALID_FD {
            disconnect()
        }
    }
    
    
    // MARK: Public Functions
    
    public func connect() throws {
        if isConnected {
            throw IPCError.alreadyConnected
        }
        
        let address = getSocketAddress()
        let addressLength = getSocketAddressLength()
        
        defer {
            address.deallocate(capacity: addressLength)
        }
        
        let result = address.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            (addressPointer:UnsafeMutablePointer<sockaddr>) -> Int32 in
            return Darwin.connect(self.fd, addressPointer, socklen_t(addressLength))
        }
        
        if result < 0 {
            throw IPCError.connectFailed
        }
        
        isConnected = true
    }
    
    public func disconnect() {
        if self.fd != IPCSocket.INVALID_FD {
        
            _ = Darwin.close(self.fd)
        
            self.fd = IPCSocket.INVALID_FD
            self.path = IPCSocket.INVALID_PATH
            
            isConnected = false
        }
    }

    
    // MARK: Private Functions
    
    private func verifyPath(_ path: String) throws {
        guard path.isNotBlank else {
            throw IPCError.malformedPath(details: "Path cannot be empty or blank")
        }
    }
    
    private func getSocketAddress() -> UnsafeMutablePointer<UInt8>{
        let address = UnsafeMutablePointer<UInt8>.allocate(capacity: getSocketAddressLength())

        address[0] = UInt8(MemoryLayout<sockaddr_un>.size)
        address[1] = UInt8(AF_UNIX)
        
        memcpy(address + 2, Array<UInt8>(path.utf8), path.length)
        
        return address
    }
    
    func getSocketAddressLength() -> Int {
        return MemoryLayout<UInt8>.size + MemoryLayout<sockaddr_un>.size + path.length
    }
    
}
