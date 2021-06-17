import Foundation

class UserDefaultsManager {
    
    private static let ingridientKey = "ingridients"
    
    static func getIngridientData() -> [IngridientData] {
        if let ingridientData = UserDefaults.standard.object(forKey: ingridientKey) as? [Data] {
            return ingridientData.map { try! JSONDecoder().decode(IngridientData.self, from: $0) }
        } else {
            return []
        }
    }
    
    static func setIngridientData(_ ingridientData: [IngridientData]) {
        UserDefaults.standard.set(ingridientData.map { try! JSONEncoder().encode($0) }, forKey: ingridientKey)
    }
    
    static func updateIngridientData(_ ingridientData: IngridientData) {
        var ingridients = [IngridientData]()
        ingridients = getIngridientData()

        if let current = ingridients.first(where: { $0 == ingridientData }) {
            ingridients.replace(current, to: ingridientData)
        } else {
            ingridients.append(ingridientData)
        }
        setIngridientData(ingridients)
    }
}
