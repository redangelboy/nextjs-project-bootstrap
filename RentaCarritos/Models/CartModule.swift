import Foundation

enum CartType: String, CaseIterable, Identifiable {
    case paletas = "Paletas"
    case aguas = "Aguas Frescas"
    case charcuterie = "Charcutería Premium"
    
    var id: String { self.rawValue }
}

struct CartModule: Identifiable, Hashable {
    let id: UUID
    var type: CartType
    var name: String
    var description: String
    var pricePerDay: Double
    var imageURL: String
    var isAvailable: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: CartModule, rhs: CartModule) -> Bool {
        lhs.id == rhs.id
    }
}
