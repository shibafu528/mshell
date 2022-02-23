//
// Copyright (c) 2022 shibafu
//

import Foundation

class RemoteWidget: Identifiable, Hashable {
    enum Kind: String {
        case window = "Plugin::GUI::Window"
        case postbox = "Plugin::GUI::Postbox"
        case pane = "Plugin::GUI::Pane"
        case tab = "Plugin::GUI::Tab"
        case tabToolbar = "Plugin::GUI::TabToolbar"
        case timeline = "Plugin::GUI::Timeline"
    }
    
    static func == (lhs: RemoteWidget, rhs: RemoteWidget) -> Bool {
        return lhs.id == rhs.id
    }
    
    let classID: String
    let objectID: String
    weak var parent: RemoteWidget?
    var children: [RemoteWidget] = []
    
    init(_ classID: String, _ objectID: String, _ parent: RemoteWidget? = nil) {
        self.classID = classID
        self.objectID = objectID
        self.parent = parent
    }
    
    var id: String {
        get {
            return [classID, objectID].joined(separator: "/")
        }
    }
    
    var kind: Kind? {
        get {
            return Kind(rawValue: classID)
        }
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(classID)
        hasher.combine(objectID)
    }
    
    func proxy() -> Mrpc_Proxy {
        return .with {
            $0.classID = classID
            $0.id = objectID
        }
    }
}
