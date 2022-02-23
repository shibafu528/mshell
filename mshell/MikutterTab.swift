//
// Copyright (c) 2022 shibafu
//

import Cocoa

class MikutterTab: NSView {
    let remote: RemoteWidget
    
    required init(remote: RemoteWidget) {
        self.remote = remote
        super.init(frame: NSRect())
        translatesAutoresizingMaskIntoConstraints = false
        remote.children.forEach { child in
            join(remote: child)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func join(remote: RemoteWidget) {
        switch remote.kind {
        case .timeline:
            let timeline = MikutterTimeline(remote: remote)
            addSubview(timeline)
            NSLayoutConstraint.activate([
                timeline.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                timeline.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                timeline.topAnchor.constraint(equalTo: self.topAnchor),
                timeline.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ])
            break
        default:
            break
        }
    }
}
