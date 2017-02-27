//  Copyright © 2017 Cyril Deba
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

public enum IPCError: Swift.Error {
    
    case unableCreateSocket
    case alreadyConnected
    case malformedPath(details: String)
    case connectFailed
    
}

extension IPCError: CustomStringConvertible {

    public var description: String {
        switch self {
        case .unableCreateSocket:
            return "Unable to create a socket. \(getErrorDescription())"
        case .alreadyConnected:
            return "Socket is already connected."
        case .malformedPath(let details):
            return "Path is malformed. \(details)"
        case .connectFailed:
            return "Unable to connect. \(getErrorDescription())"
        }
    }
  
    private func getErrorDescription() -> String {
        return String(validatingUTF8: strerror(errno)) ?? "Description is not available"
    }
    
}
