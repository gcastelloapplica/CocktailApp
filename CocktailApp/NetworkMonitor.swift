//
//  NetworkMonitor.swift
//  CocktailApp
//
//  Created by Gaspar on 30/08/2022.
//

import Foundation
import Network
import UIKit

protocol BidderProtocol {
    var observerId: String { get }
    func update(isConnected : Bool)
}

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    public var isConnected: Bool = true {
        didSet { bidders.forEach { $0.update(isConnected: isConnected) } }
    }
    
    public private(set) var connectionType: ConnectionType = .unknown
    
    private var bidders = [BidderProtocol]()
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring() {
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status == .satisfied
            self?.getConnectionType(path)
        }
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
    
    public func getConnectionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi){
            connectionType = .wifi
        } else if path.usesInterfaceType(.cellular){
            connectionType = .cellular
        } else if path.usesInterfaceType(.wiredEthernet){
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
    }
    
    func register(bidder: BidderProtocol) {
        bidders.append(bidder)
    }
    
    func unregister(bidder: BidderProtocol) {
        bidders.removeAll { $0.observerId == bidder.observerId }
    }
}
