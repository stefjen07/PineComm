//
//  ARImageView.swift
//  PineComm
//
//  Created by Евгений on 17.11.22.
//

import SwiftUI
import ARKit

struct ARImageView: UIViewRepresentable {
	var image: UIImage

	func makeUIView(context: Context) -> ARSCNView {
		let arView = ARSCNView(frame: .zero)

		let configuration = ARWorldTrackingConfiguration()
		configuration.planeDetection = .vertical
		arView.session.run(configuration)
		arView.delegate = context.coordinator

		return arView
	}

	func updateUIView(_ uiView: ARSCNView, context: Context) {

	}

	func makeCoordinator() -> Coordinator {
		return Coordinator(image: image)
	}

	class Coordinator: NSObject, ARSCNViewDelegate {
		var image: UIImage
		var imageNode: SCNNode?

		init(image: UIImage) {
			self.image = image
		}

		func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
			guard let planeAnchor = anchor as? ARPlaneAnchor, imageNode == nil else { return }

			let width = CGFloat(planeAnchor.extent.x)
			let height = CGFloat(planeAnchor.extent.x) * image.size.height / image.size.width

			let imageNode = SCNNode()
			let geometry = SCNPlane(width: width, height: height)

			let material = SCNMaterial()
			material.diffuse.contents = image
			geometry.materials = [material]

			imageNode.geometry = geometry
			imageNode.eulerAngles.x = -.pi/2

			node.addChildNode(imageNode)
			self.imageNode = imageNode
		}
	}
}

struct ARImageView_Previews: PreviewProvider {
    static var previews: some View {
		ARImageView(image: .init())
    }
}
