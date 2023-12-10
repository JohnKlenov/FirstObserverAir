//
//  NetworkMonitor.swift
//  FirstObserverAir
//
//  Created by Evgenyi on 10.12.23.
//

import Foundation
import Network

extension Notification.Name {
    static let connectivityStatus = Notification.Name(rawValue: "connectivityStatusChanged")
}

enum ConnectionType {
    case wifi
    case cellular
    case ethernet
}

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue(label: "NetworkConnectivityMonitor")
    private let monitor: NWPathMonitor
    
    private(set) var isConnected = false
    var connectionType: ConnectionType?
    private var hasStatus: Bool = false
    private(set) var isExpensive = false
    private(set) var currentConnectionType: NWInterface.InterfaceType?
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    func startMonitoring() {
        monitor.pathUpdateHandler = { path in
//            print("monitor.pathUpdateHandler")
            
            self.getConnectionType(path)
#if targetEnvironment(simulator)
            if (!self.hasStatus) {
                self.isConnected = path.status == .satisfied
                self.hasStatus = true
            } else {
                self.isConnected = !self.isConnected
            }
#else
            self.isConnected = path.status == .satisfied
#endif
//            print("isConnected: " + String(self.isConnected))
            
            //            логическое значение, которое возвращает true, если текущее соединение осуществляется через сотовую связь или точку доступа.
//            print("path.isExpensive - \(path.isExpensive)")
            NotificationCenter.default.post(name: .connectivityStatus, object: nil)
        }
        monitor.start(queue: queue)
        
    }
    
    func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            self.connectionType = .wifi
//            print(".wifi")
        } else if path.usesInterfaceType(.cellular) {
            self.connectionType = .cellular
//            print(".cellular")
        } else if path.usesInterfaceType(.wiredEthernet) {
            self.connectionType = .ethernet
//            print(".ethernet")
        } else {
            connectionType = nil
//            print(".connectionType = nil")
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
