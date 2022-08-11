//
// Copyright (c) 2022 shibafu
//

import Cocoa

class MikutterPane: NSView {
    @IBOutlet weak var tabView: NSTabView!
    @IBOutlet weak var tabBar: MMTabBarView!
    
    let remote: RemoteWidget
    
    required init(remote: RemoteWidget) {
        self.remote = remote
        super.init(frame: NSRect())
        translatesAutoresizingMaskIntoConstraints = false
        loadNib()
        initTabBar()
        remote.children.forEach { child in
            join(remote: child)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadNib() {
        guard let nib = NSNib(nibNamed: "MikutterPane", bundle: Bundle.main) else { return }
        var objs: NSArray? = []
        nib.instantiate(withOwner: self, topLevelObjects: &objs)
        
        guard let found = objs?.first(where: { $0 is NSView }), let view = found as? NSView else { return }
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    func initTabBar() {
        tabBar.setStyleNamed("Card")
        tabBar.orientation = .horizontalOrientation
        tabBar.buttonMinWidth = 100
        tabBar.buttonMaxWidth = 280
        tabBar.buttonOptimumWidth = 130
        tabBar.disableTabClose = true
        tabBar.hideForSingleTab = false
        tabBar.showAddTabButton = false
        tabBar.sizeButtonsToFit = true
        tabBar.useOverflowMenu = true
        tabBar.needsUpdate = true
    }
    
    func join(remote: RemoteWidget) {
        guard remote.kind == .tab else { return }
        
        let tab = NSTabViewItem()
        tab.view = MikutterTab(remote: remote)
        tabView.addTabViewItem(tab)
        
        let res = App.mrpc.query(.with { $0.subject = remote.proxy(); $0.selection = "name" }, callOptions: defaultTimeoutCallOpt()).response
        res.whenCompleteBlocking(onto: .main) { result in
            switch result {
            case let .success(pv):
                tab.label = pv.response.sval
            case let .failure(error):
                print(error)
                tab.label = remote.id
            }
        }
    }
}

extension MikutterPane: MMTabBarViewDelegate {
}
