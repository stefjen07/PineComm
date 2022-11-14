//
//  MultipeerService.swift
//  RadioComm
//
//  Created by Евгений on 10.11.22.
//

import Foundation
import MultipeerConnectivity

class MultipeerService: NSObject, ObservableObject {
	static func getDeviceId() -> String {
		if let deviceId = UserDefaults.standard.string(forKey: "device_id") {
			return deviceId
		}

		let deviceId = UUID().uuidString
		UserDefaults.standard.set(deviceId, forKey: "device_id")
		return deviceId
	}

	private let myPeerID: MCPeerID
	private let session: MCSession
	private let nearbyServiceBrowser: MCNearbyServiceBrowser
	private let nearbyServiceAdvertiser: MCNearbyServiceAdvertiser

	private var peers: [MCPeerID] = []
	private var timer: Timer?

	var deviceId: String = getDeviceId()
	var role: Role

	@Published var messages = [Message]()

	init(role: Role) {
		self.role = role

		myPeerID = MCPeerID(displayName: (UIDevice.current.identifierForVendor ?? UUID()).uuidString)
		session = MCSession(peer: myPeerID, securityIdentity: nil, encryptionPreference: .none)

		nearbyServiceBrowser = MCNearbyServiceBrowser(
			peer: myPeerID,
			serviceType: Constants.serviceType
		)
		nearbyServiceAdvertiser = MCNearbyServiceAdvertiser(
			peer: myPeerID,
			discoveryInfo: nil,
			serviceType: Constants.serviceType
		)

		super.init()

		session.delegate = self
		nearbyServiceBrowser.delegate = self
		nearbyServiceAdvertiser.delegate = self
	}

	func start() {
		nearbyServiceBrowser.startBrowsingForPeers()
		nearbyServiceAdvertiser.startAdvertisingPeer()

		if role == .server {
			timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true, block: { _ in
				self.broadcastMessages()
			})
		}
	}

	func broadcastMessages() {
		for message in self.messages {
			self.sendMessage(message)
		}
	}

	func invitePeer(_ newPeer: MCPeerID) {
		print("Peer invited")
		nearbyServiceBrowser.invitePeer(
			newPeer,
			to: session,
			withContext: nil,
			timeout: 30
		)
	}

	func sendMessage(_ text: String) {
		let message = Message(id: UUID(), text: text, date: Date(), sender: deviceId)
		messages.append(message)
		sendMessage(message)
	}

	func sendMessage(_ message: Message) {
		guard let data = try? JSONEncoder().encode(message) else { return }

		try? session.send(data, toPeers: peers, with: .reliable)
	}
}

extension MultipeerService: MCNearbyServiceBrowserDelegate {
	func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
		if !peers.contains(peerID) {
			if(myPeerID.hashValue<peerID.hashValue){
				invitePeer(peerID)
			}

			peers.append(peerID)
		}
	}

	func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
		guard let index = peers.firstIndex(of: peerID) else { return }

		peers.remove(at: index)
	}

	func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
		print(error.localizedDescription)
	}
}

extension MultipeerService: MCNearbyServiceAdvertiserDelegate {
	func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
		print("Invitation accepted")
		invitationHandler(true, self.session)
	}

	func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
		print(error.localizedDescription)
	}
}

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

		DispatchQueue.main.async {
			if !self.messages.contains(where: { $0.id == message.id }) {
				self.messages.append(message)
			}
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
