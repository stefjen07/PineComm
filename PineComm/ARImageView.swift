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

		let imageNode = SCNNode()
		let geometry = SCNPlane()

		let material = SCNMaterial()
		material.diffuse.contents = image
		geometry.materials = [material]

		imageNode.geometry = geometry
		arView.scene.rootNode.addChildNode(imageNode)

		return arView
	}

	func updateUIView(_ uiView: ARSCNView, context: Context) {

	}

	func makeCoordinator() -> Coordinator {
		return Coordinator()
	}

	class Coordinator: NSObject, ARSCNViewDelegate {
		
	}
}

struct ARImageView_Previews: PreviewProvider {
    static var previews: some View {
		ARImageView(image: .init())
    }
}
