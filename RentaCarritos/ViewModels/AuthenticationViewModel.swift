import Foundation
import Combine

class AuthenticationViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    func login(with credentials: UserCredentials) {
        isLoading = true
        errorMessage = nil
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            // Mock authentication - In production, this would call an actual auth service
            if credentials.email.contains("@") && !credentials.password.isEmpty {
                self.currentUser = User(
                    id: UUID(),
                    name: "Usuario Demo",
                    email: credentials.email,
                    phoneNumber: "+52 123 456 7890",
                    address: Address(
                        street: "Calle Principal 123",
                        city: "Ciudad de México",
                        state: "CDMX",
                        zipCode: "01234"
                    ),
                    rentals: []
                )
                self.isAuthenticated = true
            } else {
                self.errorMessage = AuthenticationError.invalidCredentials.message
            }
            
            self.isLoading = false
        }
    }
    
    func logout() {
        isAuthenticated = false
        currentUser = nil
    }
    
    func updateProfile(name: String, phone: String, address: Address) {
        guard var user = currentUser else { return }
        user.name = name
        user.phoneNumber = phone
        user.address = address
        currentUser = user
    }
}
