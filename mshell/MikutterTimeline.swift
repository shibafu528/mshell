//
// Copyright (c) 2022 shibafu
//

import Cocoa
import GRPC
import PromiseKit

class MikutterTimeline: NSView {
    @IBOutlet weak var tableView: NSTableView!
    
    let remote: RemoteWidget
    var subscription: ServerStreamingCall<Mrpc_SubscribeRequest, Mrpc_Event>?
    var messages: [String] = []
    
    required init(remote: RemoteWidget) {
        self.remote = remote
        super.init(frame: NSRect())
        translatesAutoresizingMaskIntoConstraints = false
        loadNib()
        
        subscription = App.mrpc.subscribe(.with { $0.name = "gui_timeline_add_messages" }, callOptions: nil) { event in
            guard event.param.count == 2 else { return }
            let remoteTimeline = event.param[0].proxy
            let messages = event.param[1].sequence.val
            
            guard remoteTimeline == self.remote.proxy() else { return }
            messages.forEach { param in
                DispatchQueue.global(qos: .utility).async {
                    let message = param.proxy.wrap()
                    firstly {
                        when(fulfilled: message.query("description"), message.query("user").then { $0.proxy.wrap().query("idname") })
                    }.done(on: .main) { (desc, idname) in
                        let msg = "\(idname.sval): \(desc.sval)"
                        self.messages.insert(msg, at: 0)
                        self.tableView.insertRows(at: .init(integer: 0), withAnimation: .slideDown)
                    }
                }
            }
        }
        subscription!.status.whenComplete { result in
            print("finished subscription gui_timeline_add_messages: \(result)")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        subscription?.cancel(promise: nil)
    }
    
    func loadNib() {
        guard let nib = NSNib(nibNamed: "MikutterTimeline", bundle: Bundle.main) else { return }
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
}

extension MikutterTimeline: NSTableViewDelegate {
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let view = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView
        let message = messages[row]
        view?.textField?.stringValue = message
        return view
    }
}

extension MikutterTimeline: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return messages.count
    }
}
