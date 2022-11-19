//
//  MultipeerService.swift
//  RadioComm
//
//  Created by Евгений on 10.11.22.
//

import Foundation
import MultipeerConnectivity

protocol MultipeerServiceProtocol {
	var deviceId: String { get }
	var delegate: MultipeerServiceDelegate? { get set }

	func start()
	func stop()
	
	func sendMessage(_ text: String)
	func sendImage(_ image: UIImage)
}

protocol MultipeerServiceDelegate {
	func multipeerService(_ service: MultipeerServiceProtocol, receivedMessage message: Message)
	func multipeerService(_ service: MultipeerServiceProtocol, serverConnected isConnected: Bool)
}

class MultipeerService: NSObject, MultipeerServiceProtocol {
	static func getDeviceId() -> String {
		if let deviceId = UserDefaults.standard.string(forKey: "device_id") {
			return deviceId
		}

		let deviceId = UUID().uuidString
		UserDefaults.standard.set(deviceId, forKey: "device_id")
		return deviceId
	}

	var delegate: MultipeerServiceDelegate?

	let myPeerID: MCPeerID
	let session: MCSession
	let nearbyServiceBrowser: MCNearbyServiceBrowser
	let nearbyServiceAdvertiser: MCNearbyServiceAdvertiser

	var peers: [Peer] = []
	var timer: Timer?

	var deviceId: String = getDeviceId()
	var role: Role

	var messages = [Message]()

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
			discoveryInfo: [
				"role": role.rawValue
			],
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

	func stop() {
		nearbyServiceBrowser.stopBrowsingForPeers()
		nearbyServiceAdvertiser.stopAdvertisingPeer()
		timer?.invalidate()
	}

	func broadcastMessages() {
		for message in self.messages {
			self.sendMessage(message)
		}
	}

	func addMessage(_ message: Message) {
		messages.append(message)
		delegate?.multipeerService(self, receivedMessage: message)
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
		let message = Message(text: text, deviceId: deviceId)
		addMessage(message)
		sendMessage(message)
	}

	func sendImage(_ image: UIImage) {
		let message = Message(image: image, deviceId: deviceId)
		addMessage(message)
		sendMessage(message)
	}

	func sendMessage(_ message: Message) {
		guard let data = try? JSONEncoder().encode(message) else { return }

		try? session.send(data, toPeers: peers.map { $0.peerID }, with: .reliable)
	}
}
