//
// Copyright (c) 2022 shibafu
//

import Cocoa

class MikutterWindowController: NSWindowController {
    @IBOutlet weak var paneStack: NSStackView!
    
    let remote: RemoteWidget
    
    required init(remote: RemoteWidget) {
        self.remote = remote
        super.init(window: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var windowNibName: NSNib.Name? {
        return String(describing: type(of: self))
    }
    
    func join(remotePane: RemoteWidget) {
        let tabView = NSTabView()
        paneStack.addArrangedSubview(tabView)
        
        remotePane.children.forEach { remoteTab in
            guard remoteTab.kind == .tab else { return }
            
            let tab = NSTabViewItem()
            tab.view = MikutterTab(remote: remoteTab)
            tabView.addTabViewItem(tab)
            
            let res = App.mrpc.query(.with { $0.subject = remoteTab.proxy(); $0.selection = "name" }, callOptions: defaultTimeoutCallOpt()).response
            res.whenCompleteBlocking(onto: .main) { result in
                switch result {
                case let .success(pv):
                    tab.label = pv.response.sval
                case let .failure(error):
                    print(error)
                    tab.label = remoteTab.id
                }
            }
        }
    }
}

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
