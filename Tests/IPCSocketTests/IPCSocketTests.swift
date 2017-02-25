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

import XCTest
@testable import IPCSocket

class IPCSocketTests: XCTestCase {
    
    func testInit() throws {
        let socket: IPCSocket = try IPCSocket()
        XCTAssertNotEqual(socket.fd, IPCSocket.INVALID_FD)
    }


    static var allTests : [(String, (IPCSocketTests) -> () throws -> Void)] {
        return [
            ("testInit", testInit),
        ]
    }
}
