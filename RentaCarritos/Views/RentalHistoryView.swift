import SwiftUI

struct RentalHistoryView: View {
    @EnvironmentObject var rentalViewModel: RentalViewModel
    
    var body: some View {
        List {
            if rentalViewModel.userRentals.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "clock.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    
                    Text("No tienes rentas activas")
                        .font(.headline)
                    
                    Text("Tus rentas aparecerán aquí")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .listRowInsets(EdgeInsets())
                .padding()
            } else {
                ForEach(rentalViewModel.userRentals) { rental in
                    RentalHistoryItemView(rental: rental)
                }
            }
        }
        .navigationTitle("Historial de Rentas")
        .refreshable {
            // In production, this would refresh the rental history
            print("Refreshing rental history...")
        }
    }
}

struct RentalHistoryItemView: View {
    let rental: Rental
    @EnvironmentObject var rentalViewModel: RentalViewModel
    
    private var statusColor: Color {
        switch rental.status {
        case .pending:
            return .orange
        case .active:
            return .green
        case .completed:
            return .blue
        case .cancelled:
            return .red
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading) {
                    // In production, fetch cart details using cartId
                    Text("Renta #\(rental.id.uuidString.prefix(8))")
                        .font(.headline)
                    
                    Text("Total: $\(Int(rental.totalPrice))")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                Text(rental.status.rawValue)
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(statusColor.opacity(0.1))
                    .foregroundColor(statusColor)
                    .cornerRadius(8)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
                    Text("Inicio: \(formatDate(rental.startDate))")
                        .font(.caption)
                }
                
                HStack {
                    Image(systemName: "calendar")
                        .foregroundColor(.gray)
                    Text("Fin: \(formatDate(rental.endDate))")
                        .font(.caption)
                }
            }
            
            if rental.status == .pending {
                Button(action: {
                    rentalViewModel.cancelRental(id: rental.id)
                }) {
                    Text("Cancelar Renta")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.red)
                        .padding(.vertical, 8)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.red, lineWidth: 1)
                        )
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "es_MX")
        return formatter.string(from: date)
    }
}

struct RentalHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RentalHistoryView()
                .environmentObject(RentalViewModel())
        }
    }
}
