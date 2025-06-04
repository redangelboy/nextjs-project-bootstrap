import Foundation
import Combine

class RentalViewModel: ObservableObject {
    @Published var availableCarts: [CartModule] = []
    @Published var userRentals: [Rental] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedCart: CartModule?
    
    init() {
        loadMockData()
    }
    
    private func loadMockData() {
        // Mock cart data
        availableCarts = [
            CartModule(
                id: UUID(),
                type: .paletas,
                name: "Carrito de Paletas Premium",
                description: "Carrito equipado para venta de paletas artesanales",
                pricePerDay: 1200.0,
                imageURL: "https://images.pexels.com/photos/ice-cream-cart.jpg",
                isAvailable: true
            ),
            CartModule(
                id: UUID(),
                type: .aguas,
                name: "Carrito de Aguas Frescas",
                description: "Carrito especializado para aguas frescas naturales",
                pricePerDay: 1000.0,
                imageURL: "https://images.pexels.com/photos/beverage-cart.jpg",
                isAvailable: true
            ),
            CartModule(
                id: UUID(),
                type: .charcuterie,
                name: "Carrito Charcutería Premium",
                description: "Carrito gourmet para tableros de charcutería",
                pricePerDay: 1500.0,
                imageURL: "https://images.pexels.com/photos/food-cart.jpg",
                isAvailable: true
            )
        ]
    }
    
    func createRental(request: RentalRequest) -> AnyPublisher<Rental, Error> {
        return Future { promise in
            // Simulate network delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                let rental = Rental(
                    id: UUID(),
                    cartId: request.cartId,
                    userId: UUID(), // In production, this would be the current user's ID
                    startDate: request.startDate,
                    endDate: request.endDate,
                    status: .pending,
                    totalPrice: self.calculateTotalPrice(
                        for: request.cartId,
                        startDate: request.startDate,
                        endDate: request.endDate
                    )
                )
                
                self.userRentals.append(rental)
                promise(.success(rental))
            }
        }.eraseToAnyPublisher()
    }
    
    private func calculateTotalPrice(for cartId: UUID, startDate: Date, endDate: Date) -> Double {
        guard let cart = availableCarts.first(where: { $cart.id == cartId }) else { return 0 }
        
        let numberOfDays = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
        return Double(numberOfDays) * cart.pricePerDay
    }
    
    func cancelRental(id: UUID) {
        if let index = userRentals.firstIndex(where: { $0.id == id }) {
            var rental = userRentals[index]
            rental.status = .cancelled
            userRentals[index] = rental
        }
    }
    
    func filterCarts(by type: CartType?) -> [CartModule] {
        guard let type = type else { return availableCarts }
        return availableCarts.filter { $0.type == type }
    }
}
