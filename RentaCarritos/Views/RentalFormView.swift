import SwiftUI

struct RentalFormView: View {
    let cart: CartModule
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var rentalViewModel: RentalViewModel
    
    @State private var startDate = Date()
    @State private var endDate = Date().addingTimeInterval(24 * 60 * 60)
    @State private var isLoading = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    private var numberOfDays: Int {
        Calendar.current.dateComponents([.day], from: startDate, to: endDate).day ?? 0
    }
    
    private var totalPrice: Double {
        Double(numberOfDays) * cart.pricePerDay
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Detalles del Carrito")) {
                    HStack {
                        // Image placeholder (in production, use AsyncImage)
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 80, height: 80)
                            .cornerRadius(8)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(cart.name)
                                .font(.headline)
                            Text(cart.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("$\(Int(cart.pricePerDay))/día")
                                .font(.subheadline)
                                .foregroundColor(.blue)
                        }
                    }
                }
                
                Section(header: Text("Fechas de Renta")) {
                    DatePicker(
                        "Fecha de inicio",
                        selection: $startDate,
                        in: Date()...,
                        displayedComponents: [.date]
                    )
                    
                    DatePicker(
                        "Fecha de fin",
                        selection: $endDate,
                        in: startDate...,
                        displayedComponents: [.date]
                    )
                }
                
                Section(header: Text("Resumen")) {
                    HStack {
                        Text("Días de renta")
                        Spacer()
                        Text("\(numberOfDays)")
                    }
                    
                    HStack {
                        Text("Total a pagar")
                        Spacer()
                        Text("$\(Int(totalPrice))")
                            .fontWeight(.bold)
                    }
                }
            }
            .navigationTitle("Rentar Carrito")
            .navigationBarItems(
                leading: Button("Cancelar") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Rentar") {
                    createRental()
                }
                .disabled(isLoading || numberOfDays < 1)
            )
            .alert(isPresented: $showingAlert) {
                Alert(
                    title: Text("Información"),
                    message: Text(alertMessage),
                    dismissButton: .default(Text("OK")) {
                        if alertMessage.contains("éxito") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                )
            }
        }
    }
    
    private func createRental() {
        isLoading = true
        
        let request = RentalRequest(
            cartId: cart.id,
            startDate: startDate,
            endDate: endDate
        )
        
        // Simulate rental creation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false
            alertMessage = "¡Renta creada con éxito!"
            showingAlert = true
        }
    }
}

struct RentalFormView_Previews: PreviewProvider {
    static var previews: some View {
        RentalFormView(
            cart: CartModule(
                id: UUID(),
                type: .paletas,
                name: "Carrito de Paletas",
                description: "Carrito equipado para paletas",
                pricePerDay: 1200,
                imageURL: "",
                isAvailable: true
            )
        )
        .environmentObject(RentalViewModel())
    }
}
