import FirebaseStorage
import UIKit

class FireStorageManager {
    static let storageRef = Storage.storage().reference()
    static func postImage(_ image: UIImage, _ uuid: UUID) {
        if let data = image.pngData() {
            storageRef.child("images/\(uuid.uuidString)").putData(data, metadata: nil) { (metadata, error) in
                guard let _ = metadata else {
                    return
                }
                storageRef.downloadURL { (url, error) in
                    if let error = error {
                        print(error.localizedDescription)
                        return
                    }
                }
            }.resume()
        }
    }
    
    static func getImageUrl(_ uuid: UUID, _ completion: @escaping (URL?) -> Void) {
        storageRef.child("images/\(uuid.uuidString)").downloadURL { url, error in
            completion(url)
        }
    }
}
