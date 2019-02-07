//
//  extentionViewController.swift
//  ARkit_Avy
//
//  Created by 阿部 祐輔 on 2019/02/04.
//  Copyright © 2019年 阿部 祐輔. All rights reserved.
//

import ARKit
import MultipeerConnectivity

extension ViewController: MCNearbyServiceBrowserDelegate {
    // セッションの招待
    func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
        browser.invitePeer(peerID, to: mcSession, withContext: nil, timeout: 30)
        print("\(peerID.displayName)をセッションに招待した")
    }
    // セッション相手が抜けた
    func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
        print("\(peerID.displayName)がセッションから抜けた")
    }
}

extension ViewController: MCNearbyServiceAdvertiserDelegate {
    // 招待を受ける
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        invitationHandler(true, mcSession) // 招待を受ける
        print("\(peerID.displayName)からセッションに招待された")
    }
}

// 受信したワールドマップで再構築する
extension ViewController: MCSessionDelegate {
    // dataを受信した
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        do {
            // ワールドマップを受け取る
            if let worldMap = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data) {
                // 受信したワールドマップでセッションをリセットする
                let configuration = ARWorldTrackingConfiguration()
                configuration.planeDetection = .horizontal
                configuration.initialWorldMap = worldMap
                sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
                mapProvider = peerID // マップデータを送ってきた相手
            }
            else if let anchor = try NSKeyedUnarchiver.unarchivedObject(ofClass: ARAnchor.self, from: data) {
                sceneView.session.add(anchor: anchor)
            } else { print("知らない場所のアンカーを受信 from \(peerID.displayName)") }
        } catch {
            print("デコードできないデータを受信 from \(peerID.displayName)")
        }
    }
    
    // マルチセッション通知
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print(#function, streamName, peerID.displayName, separator: ",")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print(#function, resourceName, peerID.displayName, separator: ",")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        print(#function, resourceName, peerID.displayName, localURL?.absoluteString ?? "?" ,error.debugDescription, separator: ",")
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print(#function, peerID.displayName, state.rawValue, separator: ",")
    }
}

extension ViewController: ARSessionDelegate {
    // トラッキングステータスの更新
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        updateSessionInfoLabel(for: session.currentFrame!, trackingState: camera.trackingState)
    }
    
    // マッピングステータスの更新
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        let mappingStatusMessage:String
        switch frame.worldMappingStatus {
        case .notAvailable, .limited:
            mappingStatusMessage = "not Available or limited"
            sendMapButton.isEnabled = false
        case .extending:
            mappingStatusMessage = "extending"
            sendMapButton.isEnabled = !mcSession.connectedPeers.isEmpty
        case .mapped:
            mappingStatusMessage = "mapped"
            sendMapButton.isEnabled = !mcSession.connectedPeers.isEmpty
        }
        // セッションインフォラベル表示へ
        mappingStatusLabel.text = mappingStatusMessage
        updateSessionInfoLabel(for: frame, trackingState: frame.camera.trackingState)
        // 送信ボタンの背景色
        if sendMapButton.isEnabled {
            sendMapButton.backgroundColor = UIColor.red
        } else {
            sendMapButton.backgroundColor = UIColor.gray
        }
    }
    
    // セッション情報のラベル表示
    private func updateSessionInfoLabel(for frame: ARFrame, trackingState: ARCamera.TrackingState) {
        let sessionInfoMessage: String
        switch trackingState {
        case .normal where frame.anchors.isEmpty && mcSession.connectedPeers.isEmpty:
            sessionInfoMessage = "待機中です。カメラを動かしてください。"
        case .normal where !mcSession.connectedPeers.isEmpty && mapProvider == nil:
            let peerNames = mcSession.connectedPeers.map({ $0.displayName }).joined(separator: ", ")
            sessionInfoMessage = "\(peerNames)と接続しました。"
        case .notAvailable:
            sessionInfoMessage = "トラッキングできません。"
        case .limited(.excessiveMotion):
            sessionInfoMessage = "ゆっくり動かしてください。"
        case .limited(.insufficientFeatures):
            sessionInfoMessage = "特徴点をトラッキングできません。"
        case .limited(.initializing) where mapProvider != nil:
            sessionInfoMessage = "\(mapProvider!.displayName)からマップを受け取りました。"
        case .limited(.relocalizing) where mapProvider != nil:
            sessionInfoMessage = "受信マップを構築中..."
        case .limited(.relocalizing):
            sessionInfoMessage = "リジューム中..."
        case .limited(.initializing):
            sessionInfoMessage = "ARセッション初期化中..."
        default:
            sessionInfoMessage = ""
        }
        sessionInfoLabel.text = sessionInfoMessage // メッセージの表示
        sessionInfoView.isHidden = sessionInfoMessage.isEmpty // メッセージが空のときは消す
    }
}


