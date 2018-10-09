//
//  MPOrderSocketManager.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/10/9.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import Starscream
import SwiftHash

protocol MPOrderSocketDelegate: class {
    /// 连接成功
    func websocketDidConnect()
    /// 连接失败
    func websocketDidDisconnect(error: Error?)
    /// 收到socket msg
    func websocketDidReceiveMessage(text: String)
    /// 收到socket data
    func websocketDidReceiveData(data: Data)
}

/// 抢单的socket管理
class MPOrderSocketManager {
    static let shared = MPOrderSocketManager()
    fileprivate lazy var socket: WebSocket = self.createSocket()
    weak var delegate: MPOrderSocketDelegate?
    
    private init() {
    }
    
    func createSocket() -> WebSocket {
        let stamp: String = String(format: "%.0f", Date().timeIntervalSince1970)
        let sign: String = MD5(MPUserModel.shared.token + stamp)
        let urlStr = "ws://www.nolasthope.cn/ws/driver/order/\(MPUserModel.shared.userID)/\(stamp)/\(sign)/"
        let url: URL = URL(string: urlStr)!
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
        let tmp = WebSocket.init(request: request)
        tmp.delegate = self
        return tmp
    }
    
    /// 连接socket
    func connect(socketDelegate: MPOrderSocketDelegate?) {
        delegate = socketDelegate
        socket.connect()
    }
    
    /// 断开socket
    func disconnet() {
        socket.disconnect()
    }
    
    /// token刷新后，创建新的socket进行重连
    func reconnect() {
        if socket.isConnected {
            socket.disconnect()
            socket = createSocket()
            socket.connect()
        }
    }
}

// MARK: - WebSocketDelegate
extension MPOrderSocketManager: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        delegate?.websocketDidConnect()
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        delegate?.websocketDidDisconnect(error: error)
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        delegate?.websocketDidReceiveMessage(text: text)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        delegate?.websocketDidReceiveData(data: data)
    }
}
