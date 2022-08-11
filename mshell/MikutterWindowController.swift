//
// Copyright (c) 2022 shibafu
//

import Cocoa
import GRPC

class MikutterWindowController: NSWindowController {
    @IBOutlet weak var paneStack: NSStackView!
    @IBOutlet weak var statusMessage: NSTextField!

    let remote: RemoteWidget
    var statusMessageStack: [(String, Date?)] = []
    var rewindStatusSubscription: ServerStreamingCall<Mrpc_SubscribeRequest, Mrpc_Event>?
    
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
    
    override func windowDidLoad() {
        super.windowDidLoad()
        statusMessageStack.append((statusMessage.stringValue, nil))
        rewindStatusSubscription = App.mrpc.subscribe(.with { $0.name = "gui_window_rewindstatus" }, callOptions: nil) { event in
            guard event.param.count == 3 else { return }
            let remoteWindow = event.param[0].proxy
            let text = event.param[1].sval
            let expire = event.param[2].ival
            
            guard remoteWindow == self.remote.proxy() else { return }
            if expire == 0 {
                self.statusMessageStack.append((text, nil))
            } else {
                let expireDate = Date().addingTimeInterval(TimeInterval(expire))
                self.statusMessageStack.append((text, expireDate))
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(expire))) {
                    self.statusMessageStack = self.statusMessageStack.filter { (_, exp) in
                        exp == nil || exp! > Date()
                    }
                    self.statusMessage.stringValue = self.statusMessageStack.last!.0
                }
            }
            DispatchQueue.main.async {
                self.statusMessage.stringValue = self.statusMessageStack.last!.0
            }
        }
        rewindStatusSubscription!.status.whenComplete { result in
            print("finished subscription gui_window_rewindstatus: \(result)")
        }
    }
    
    func join(remotePane: RemoteWidget) {
        let pane = MikutterPane(remote: remotePane)
        paneStack.addArrangedSubview(pane)
    }
}
