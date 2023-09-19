//
//  ImagePicker.swift
//  MeetAndEat
//
//  Created by Jasmine Micallef on 31/07/2023.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage


final class ImagePickerModel: ObservableObject {
    func convertImageToURL(_ image: UIImage, completion: @escaping (String?, Error?) -> Void) {
        // Convert the UIImage to Data
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            // Handle image data conversion error
            completion(nil, NSError(domain: "com.example.app", code: -1, userInfo: [NSLocalizedDescriptionKey: "Error converting image to data"]))
            return
        }

        // Reference to Firebase Storage
        let storage = Storage.storage()

        // Generate a unique ID for the image file name
        let uniqueID = UUID().uuidString

        // Specify the Firebase Storage path where you want to store the image
        let imagePath = "images/\(uniqueID).jpg"

        // Upload the image data to Firebase Storage
        let imageRef = storage.reference().child(imagePath)
        imageRef.putData(imageData, metadata: nil) { (_, error) in
            if let error = error {
                // Handle the error while uploading to Firebase Storage
                completion(nil, error)
            } else {
                // Get the download URL for the uploaded image
                imageRef.downloadURL { (url, error) in
                    if let error = error {
                        // Handle the error while getting the download URL
                        completion(nil, error)
                    } else if let downloadURL = url {
                        // Return the download URL as a String
                        completion(downloadURL.absoluteString, nil)
                    }
                }
            }
        }
    }
}

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let selectedImage = info[.originalImage] as? UIImage {
                parent.selectedImage = selectedImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

