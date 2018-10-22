import WatchConnectivity

class WatchSessionManager: NSObject, WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("🤙 Session activated on watch")
    }
    
    static let sharedManager = WatchSessionManager()
    private override init() {
        super.init()
    }
    
    private let session: WCSession = WCSession.default
    
    func startSession() {
        session.delegate = self
        session.activate()
    }
    
    // Pass data obtained here to InterfaceController
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("⚡️ Context recieved on watch!")
        NotificationCenter.default.post(name: NSNotification.Name("didRecieveRouteSteps"), object: nil, userInfo: applicationContext)
    }
}
