//
// Copyright (c) 2022 shibafu
//

import Foundation
import PromiseKit

struct RemoteObject: Identifiable, Hashable {
    let classID: String
    let objectID: String
    
    var id: String {
        get {
            return [classID, objectID].joined(separator: "/")
        }
    }
    
    func unwrap() -> Mrpc_Proxy {
        return .with {
            $0.classID = classID
            $0.id = objectID
        }
    }
    
    func query(_ selector: String) -> Promise<Mrpc_Param> {
        Promise { promise in
            // FIXME: [reports] Main Thread Checker: UI API called on a background thread: -[NSApplication delegate]
            let res = App.mrpc.query(.with { $0.subject = unwrap(); $0.selection = selector }, callOptions: nil).response
            res.whenComplete { result in
                switch result {
                case let .success(pv):
                    promise.fulfill(pv.response)
                case let .failure(e):
                    promise.reject(e)
                }
            }
        }
    }
}

extension Mrpc_Proxy {
    func wrap() -> RemoteObject {
        return .init(classID: classID, objectID: id)
    }
}
