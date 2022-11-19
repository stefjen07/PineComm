//
//  ImagePicker.swift
//  PineComm
//
//  Created by Евгений on 17.11.22.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
	@Environment(\.presentationMode) private var presentationMode
	var sourceType: UIImagePickerController.SourceType = .photoLibrary
	var completionHandler: (UIImage) -> Void

	func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
		let imagePicker = UIImagePickerController()
		imagePicker.allowsEditing = false
		imagePicker.sourceType = sourceType
		imagePicker.delegate = context.coordinator
		return imagePicker
	}

	func updateUIViewController(
		_ uiViewController: UIImagePickerController,
		context: UIViewControllerRepresentableContext<ImagePicker>
	) {

	}

	func makeCoordinator() -> Coordinator {
		Coordinator(self)
	}

	final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
		var parent: ImagePicker

		init(_ parent: ImagePicker) {
			self.parent = parent
		}

		func imagePickerController(
			_ picker: UIImagePickerController,
			didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
		) {
			if let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)?.fixedOrientation {
				parent.completionHandler(image)
			}
			parent.presentationMode.wrappedValue.dismiss()
		}
	}
}
