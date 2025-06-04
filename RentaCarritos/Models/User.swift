import Foundation

struct User: Identifiable {
    let id: UUID
    var name: String
    var email: String
    var phoneNumber: String
    var address: Address
    var rentals: [Rental]
}

struct Address {
    var street: String
    var city: String
    var state: String
    var zipCode: String
    
    var formattedAddress: String {
        return "\(street), \(city), \(state) \(zipCode)"
    }
}

struct UserCredentials {
    let email: String
    let password: String
}

enum AuthenticationError: Error {
    case invalidCredentials
    case networkError
    case userNotFound
    case registrationFailed
    
    var message: String {
        switch self {
        case .invalidCredentials:
            return "Email o contraseña incorrectos"
        case .networkError:
            return "Error de conexión. Intente nuevamente"
        case .userNotFound:
            return "Usuario no encontrado"
        case .registrationFailed:
            return "Error al registrar usuario"
        }
    }
}
