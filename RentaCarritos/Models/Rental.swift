import Foundation

enum RentalStatus: String {
    case pending = "Pendiente"
    case active = "Activo"
    case completed = "Completado"
    case cancelled = "Cancelado"
}

struct Rental: Identifiable {
    let id: UUID
    let cartId: UUID
    let userId: UUID
    var startDate: Date
    var endDate: Date
    var status: RentalStatus
    var totalPrice: Double
    
    var numberOfDays: Int {
        Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
    }
}

struct RentalRequest {
    let cartId: UUID
    let startDate: Date
    let endDate: Date
}
