//
//  MPListenSocketManager.swift
//  MaintainDriverClient
//
//  Created by Maple on 2018/10/9.
//  Copyright © 2018年 Maple. All rights reserved.
//

import UIKit
import Starscream
import SwiftHash

protocol MPListenSocketDelegate: class {
    /// 连接成功
    func listenSocketDidConnect()
    /// 连接失败
    func listenSocketDidDisconnect(error: Error?)
    /// 收到socket msg
    func listenSocketDidReceiveMessage(text: String)
    /// 收到socket data
    func listenSocketDidReceiveData(data: Data)
}

/// 听单的socket管理
class MPListenSocketManager {
    static let shared = MPListenSocketManager()
    fileprivate lazy var socket: WebSocket = self.createSocket()
    weak var delegate: MPListenSocketDelegate?
    
    private init() {
    }
    
    func createSocket() -> WebSocket {
        let stamp: String = String(format: "%.0f", Date().timeIntervalSince1970)
        let sign: String = MD5(MPUserModel.shared.token + stamp)
        let urlStr = "ws://www.nolasthope.cn/ws/driver/listen/\(MPUserModel.shared.userID)/\(stamp)/\(sign)/"
        let url: URL = URL(string: urlStr)!
        var request = URLRequest(url: url)
        request.timeoutInterval = 5
//        let tmp = WebSocket.init(request: request)
        let tmp = WebSocket.init(url: url)
        tmp.delegate = self
        return tmp
    }
    
    /// 创建socket
    func connect(socketDelegate: MPListenSocketDelegate?) {
        socket.disconnect()
        delegate = socketDelegate
        socket = createSocket()
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
extension MPListenSocketManager: WebSocketDelegate {
    func websocketDidConnect(socket: WebSocketClient) {
        delegate?.listenSocketDidConnect()
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        delegate?.listenSocketDidDisconnect(error: error)
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        delegate?.listenSocketDidReceiveMessage(text: text)
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        delegate?.listenSocketDidReceiveData(data: data)
    }
}

