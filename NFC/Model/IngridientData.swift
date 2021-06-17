import FirebaseFirestore
import UIKit

struct IngridientData: Codable, Equatable {
    var uuid: UUID = UUID()
    var name: String = ""
    var buyDate: String = ""
    var expirationDate: String = ""
    var memoText: String = ""
    
    static func == (lhs: IngridientData, rhs: IngridientData) -> Bool {
        lhs.uuid == rhs.uuid
    }
}
