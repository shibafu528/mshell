//
// Copyright (c) 2022 shibafu
//

import Cocoa
import GRPC

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
        
        let mrpc = App.mrpc
        subscription = mrpc.subscribe(.with { $0.name = "gui_timeline_add_messages" }, callOptions: nil) { event in
            guard event.param.count == 2 else { return }
            let remoteTimeline = event.param[0].proxy
            let messages = event.param[1].sequence.val
            
            guard remoteTimeline == self.remote.proxy() else { return }
            messages.forEach { param in
                DispatchQueue.global(qos: .utility).async {
                    let message = param.proxy
                    do {
                        // 面倒になってきたから同期処理でやっちゃう
                        let desc = try mrpc.query(.with { $0.subject = message; $0.selection = "description" }).response.wait()
                        let user = try mrpc.query(.with { $0.subject = message; $0.selection = "user" }).response.wait()
                        let idname = try mrpc.query(.with { $0.subject = user.response.proxy; $0.selection = "idname" }).response.wait()
                        DispatchQueue.main.async {
                            let msg = "\(idname.response.sval): \(desc.response.sval)"
                            self.messages.insert(msg, at: 0)
                            self.tableView.insertRows(at: .init(integer: 0), withAnimation: .slideDown)
                        }
                    } catch {}
                }
            }
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
