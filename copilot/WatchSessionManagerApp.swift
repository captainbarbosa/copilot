import WatchConnectivity

// Note that the WCSessionDelegate must be an NSObject
// So no, you cannot use the nice Swift struct here!
class WatchSessionManager: NSObject, WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("👋 Session deactivated")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("🚗 Session activated")
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("⭐️ Session activation completed")
    }
    
    // Instantiate the Singleton
    static let sharedManager = WatchSessionManager()
    private override init() {
        super.init()
    }
    
    // Keep a reference for the session,
    // which will be used later for sending / receiving data
    private let session: WCSession? = WCSession.isSupported() ? WCSession.default : nil
    
    private var validSession: WCSession? {
        
        // paired - the user has to have their device paired to the watch
        // watchAppInstalled - the user must have your watch app installed
        
        // Note: if the device is paired, but your watch app is not installed
        // consider prompting the user to install it for a better experience
        
        if let session = session, session.isPaired && session.isWatchAppInstalled {
            return session
        }
        return nil
    }
    
    private var validReachableSession: WCSession? {
        // check for validSession on iOS only (see above)
        // in your Watch App, you can just do an if session.reachable check
        if let session = validSession, session.isReachable {
            return session
        }
        return nil
    }
    
    // Activate Session
    // This needs to be called to activate the session before first use!
    func startSession() {
        session?.delegate = self
        session?.activate()
    }
    
    func session(_ session: WCSession, didReceiveApplicationContext applicationContext: [String : Any]) {
        print("✅ did recieve data on phone!")
    }
}

extension WatchSessionManager {
    func updateApplicationContext(applicationContext: [String : AnyObject]) throws {
        if let session = validSession {
            do {
                try session.updateApplicationContext(applicationContext)
                print("✅ Context updated")
            } catch let error {
                print("❌ Oops - context couldn't be updated")
                throw error
            }
        }
    }
}
