//
//  MultipeerService-MCSessionDelegate.swift
//  PineComm
//
//  Created by Евгений on 20.11.22.
//

import Foundation
import MultipeerConnectivity

extension MultipeerService: MCSessionDelegate {
	func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
		if state == MCSessionState.connected {
			print("Peer connected")
			if role == .server {
				broadcastMessages()
			}
		}
	}

	func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
		guard let message = try? JSONDecoder().decode(Message.self, from: data) else { return }

		if !self.messages.contains(where: { $0.id == message.id }) {
			self.addMessage(message)
		}
	}

	func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {

	}

	func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
		certificateHandler(true)
	}

	func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {

	}

	func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {

	}
}
