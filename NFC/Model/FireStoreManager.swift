import FirebaseFirestore
import FirebaseFirestoreSwift
import UIKit

class FireStoreManager {
    
    static let db = Firestore.firestore()
    
//    static func getTag(openOnly: Bool = true, _ completion: @escaping ([CampaignData]) -> Void) -> ListenerRegistration {
//        var query: Query = FireStoreManager.db.collection("board")
//        if openOnly { query = query.whereField("closed", isEqualTo: false) }
//        return query.addSnapshotListener { snapshot, error in
//            guard let snapshot = snapshot, error == nil else {
//                UIAlertController.showErrorAlert(error?.localizedDescription ?? "No data")
//                return
//            }
//            let campaigns: [CampaignData] = snapshot.documents.map { document in
//                var campaign = CampaignData.decode(document.data())
//                campaign.id = document.documentID
//                return campaign
//            }
//            completion(campaigns)
//        }
//    }
//    
//    static func getCampaignData(_ boardId: String, _ completion: @escaping (CampaignData) -> Void) -> ListenerRegistration {
//        FireStoreManager.db.collection("board").document(boardId).addSnapshotListener { snapshot, error in
//            guard let data = snapshot?.data(), error == nil else {
//                UIAlertController.showErrorAlert(error?.localizedDescription ?? "No data")
//                return
//            }
//            var campaign = CampaignData.decode(data)
//            campaign.id = snapshot!.documentID
//            completion(campaign)
//        }
//    }
//    
//    static func listenOrderQueue(_ orderQueueId: String, _ completion: @escaping (String) -> Void) -> ListenerRegistration {
//        FireStoreManager.db.collection("order_queues").document(orderQueueId).addSnapshotListener { document, error in
//            guard let data = document?.data(), error == nil else {
//                UIAlertController.showErrorAlert(error?.localizedDescription ?? "No data")
//                return
//            }
//            if let status = data["status"] as? String {
//                completion(status)
//            }
//        }
//    }
//    
//    static func getPoint(_ userId: String, _ completion: @escaping (PointData?) -> Void) {
//        FireStoreManager.db.collection("user_points").document(userId).getDocument { document, error in
//            guard let data = document?.data(), error == nil else {
//                UIAlertController.showErrorAlert(error?.localizedDescription ?? "No data")
//                completion(nil)
//                return
//            }
//            completion(PointData.decode(data))
//        }
//    }
}
