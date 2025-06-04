import SwiftUI

struct HomeView: View {
    @EnvironmentObject var rentalViewModel: RentalViewModel
    @State private var selectedType: CartType?
    @State private var showingRentalForm = false
    
    private let columns = [
        GridItem(.adaptive(minimum: 160), spacing: 16)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Filter Section
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        FilterButton(title: "Todos", isSelected: selectedType == nil) {
                            selectedType = nil
                        }
                        
                        ForEach(CartType.allCases) { type in
                            FilterButton(
                                title: type.rawValue,
                                isSelected: selectedType == type
                            ) {
                                selectedType = type
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Carts Grid
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(rentalViewModel.filterCarts(by: selectedType)) { cart in
                        CartCardView(cart: cart)
                            .onTapGesture {
                                rentalViewModel.selectedCart = cart
                                showingRentalForm = true
                            }
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Renta de Carritos")
        .sheet(isPresented: $showingRentalForm) {
            if let selectedCart = rentalViewModel.selectedCart {
                RentalFormView(cart: selectedCart)
            }
        }
    }
}

struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .fontWeight(.medium)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color.black : Color.gray.opacity(0.1))
                .foregroundColor(isSelected ? .white : .black)
                .cornerRadius(20)
        }
    }
}

struct CartCardView: View {
    let cart: CartModule
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Image placeholder (in production, use AsyncImage)
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .aspectRatio(1, contentMode: .fit)
                .overlay(
                    Image(systemName: "cart.fill")
                        .foregroundColor(.gray)
                )
                .cornerRadius(12)
            
            Text(cart.name)
                .font(.headline)
                .lineLimit(2)
            
            Text("$\(Int(cart.pricePerDay))/día")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            if !cart.isAvailable {
                Text("No disponible")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .padding(12)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            HomeView()
                .environmentObject(RentalViewModel())
        }
    }
}
