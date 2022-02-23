//
// Copyright (c) 2022 shibafu
//

import Cocoa
import GRPC
import NIO
import PromiseKit

func defaultTimeoutCallOpt() -> CallOptions {
    return CallOptions(timeLimit: .timeout(.seconds(5)))
}

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
    lazy var channel = ClientConnection.insecure(group: self.group).connect(host: "localhost", port: 50051)
    lazy var mrpc = Mrpc_PluggaloidServiceClient(channel: self.channel)
    lazy var mshell = Mrpc_Shell_ShellServiceClient(channel: self.channel)
    
    var remoteWindow: RemoteWidget?
    var localWindowController: MikutterWindowController?

    deinit {
        try! group.syncShutdownGracefully()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let res = self.mshell.queryRootWindow(.init(), callOptions: defaultTimeoutCallOpt()).response
        res.whenSuccess { res in
            if case .proxy(let p) = res.window.val {
                print("[rootwindow] \(p)")
                let widget = RemoteWidget(p.classID, p.id)
                self.remoteWindow = widget
                firstly {
                    self.queryChildren(res.window.proxy, prefix: "rootwindow", parent: widget)
                }.done { _ in
                    print("[query] fin")
                    dump(self.remoteWindow)
                    self.constructLocalWidget(self.remoteWindow!)
                }.catch { error in
                    print("[query] error: \(error)")
                }
            } else {
                print("[rootwindow] not found")
            }
        }
        res.whenFailure { error in
            print("[rootwindow] error: \(error)")
            DispatchQueue.main.async {
                let alert = NSAlert(error: error)
                alert.runModal()
                NSApp.terminate(nil)
            }
        }
    }
    
    func queryChildren(_ proxy: Mrpc_Proxy, prefix: String, parent: RemoteWidget) -> Promise<Void> {
        return Promise { promise in
            let res = self.mrpc.query(.with {
                $0.subject = proxy
                $0.selection = "children"
            }, callOptions: defaultTimeoutCallOpt()).response
            res.whenSuccess { pv in
                if pv.response.sequence.val.count > 0 {
                    print("[\(prefix).children] \(pv.response)")
                    let promises = pv.response.sequence.val.map { p -> Promise<Void> in
                        let widget = RemoteWidget(p.proxy.classID, p.proxy.id, parent)
                        parent.children.append(widget)
                        return self.queryChildren(p.proxy, prefix: "\(prefix).children", parent: widget)
                    }
                    firstly {
                        when(resolved: promises)
                    }.done { _ in
                        promise.fulfill(())
                    }.catch { error in
                        promise.reject(error)
                    }
                } else {
                    promise.fulfill(())
                }
            }
            res.whenFailure { error in
                if let e = error as? GRPCStatus {
                    let message = e.message ?? ""
                    if e.code == .unknown && message.contains("undefined method") {
                        promise.fulfill(())
                    }
                }
                print("[\(prefix).children] error: \(error)")
                promise.reject(error)
            }
        }
    }
    
    func constructLocalWidget(_ remote: RemoteWidget) {
        switch remote.kind {
        case .window:
            localWindowController = MikutterWindowController(remote: remote)
            localWindowController!.showWindow(nil)
            localWindowController!.window!.makeKeyAndOrderFront(nil)
            remote.children.reversed().forEach { child in
                constructLocalWidget(child)
            }
        case .pane:
            localWindowController?.join(remotePane: remote)
        default:
            break
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
}

var App: AppDelegate {
    get {
        return NSApp.delegate as! AppDelegate
    }
}
