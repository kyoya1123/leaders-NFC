import FirebaseFirestore
import UIKit

struct IngridientData: Codable {
    var uuid: UUID = UUID()
    var name: String = ""
    var buyDate: String = ""
    var expirationDate: String = ""
    var imageUrl: URL?
}
