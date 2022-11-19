//
//  MultipeerService+MCNearbyServiceAdvertiserDelegate.swift
//  PineComm
//
//  Created by Евгений on 20.11.22.
//

import Foundation
import MultipeerConnectivity

extension MultipeerService: MCNearbyServiceAdvertiserDelegate {
	func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
		print("Invitation accepted")
		invitationHandler(true, self.session)
	}

	func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
		print(error.localizedDescription)
	}
}
