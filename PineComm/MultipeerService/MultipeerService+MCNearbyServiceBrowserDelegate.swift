//
//  MultipeerService+MCNearbyServiceBrowserDelegate.swift
//  PineComm
//
//  Created by Евгений on 20.11.22.
//

import Foundation
import MultipeerConnectivity

extension MultipeerService: MCNearbyServiceBrowserDelegate {
	func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
		if !peers.contains(where: { $0.peerID == peerID }) {
			if(myPeerID.hashValue<peerID.hashValue){
				invitePeer(peerID)
			}

			let role = Role(rawValue: info?["role"] ?? "") ?? .client
			peers.append(Peer(peerID: peerID, role: role))

			if peers.contains(where: { $0.role == .server }) {
				delegate?.multipeerService(self, serverConnected: true)
			}
		}
	}

	func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
		guard let index = peers.firstIndex(where: { $0.peerID == peerID }) else { return }

		peers.remove(at: index)

		if !peers.contains(where: { $0.role == .server }) {
			delegate?.multipeerService(self, serverConnected: false)
		}
	}

	func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
		print(error.localizedDescription)
	}
}
