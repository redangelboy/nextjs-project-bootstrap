import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State private var showingEditProfile = false
    @State private var showingLogoutAlert = false
    
    var body: some View {
        List {
            if let user = authViewModel.currentUser {
                // User Info Section
                Section {
                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 80, height: 80)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.gray)
                            )
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.name)
                                .font(.headline)
                            Text(user.email)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Contact Info Section
                Section(header: Text("Información de Contacto")) {
                    InfoRow(icon: "phone.fill", title: "Teléfono", value: user.phoneNumber)
                    InfoRow(icon: "location.fill", title: "Dirección", value: user.address.formattedAddress)
                }
                
                // Actions Section
                Section {
                    Button(action: { showingEditProfile = true }) {
                        HStack {
                            Image(systemName: "pencil")
                            Text("Editar Perfil")
                        }
                    }
                    
                    Button(action: { showingLogoutAlert = true }) {
                        HStack {
                            Image(systemName: "arrow.right.square")
                            Text("Cerrar Sesión")
                        }
                        .foregroundColor(.red)
                    }
                }
            }
        }
        .navigationTitle("Perfil")
        .sheet(isPresented: $showingEditProfile) {
            if let user = authViewModel.currentUser {
                EditProfileView(user: user)
            }
        }
        .alert(isPresented: $showingLogoutAlert) {
            Alert(
                title: Text("Cerrar Sesión"),
                message: Text("¿Estás seguro que deseas cerrar sesión?"),
                primaryButton: .destructive(Text("Cerrar Sesión")) {
                    authViewModel.logout()
                },
                secondaryButton: .cancel(Text("Cancelar"))
            )
        }
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.gray)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(value)
                    .font(.body)
            }
        }
    }
}

struct EditProfileView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    let user: User
    @State private var name: String
    @State private var phone: String
    @State private var street: String
    @State private var city: String
    @State private var state: String
    @State private var zipCode: String
    
    init(user: User) {
        self.user = user
        _name = State(initialValue: user.name)
        _phone = State(initialValue: user.phoneNumber)
        _street = State(initialValue: user.address.street)
        _city = State(initialValue: user.address.city)
        _state = State(initialValue: user.address.state)
        _zipCode = State(initialValue: user.address.zipCode)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Información Personal")) {
                    TextField("Nombre", text: $name)
                    TextField("Teléfono", text: $phone)
                }
                
                Section(header: Text("Dirección")) {
                    TextField("Calle y Número", text: $street)
                    TextField("Ciudad", text: $city)
                    TextField("Estado", text: $state)
                    TextField("Código Postal", text: $zipCode)
                }
            }
            .navigationTitle("Editar Perfil")
            .navigationBarItems(
                leading: Button("Cancelar") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Guardar") {
                    saveChanges()
                }
            )
        }
    }
    
    private func saveChanges() {
        let newAddress = Address(
            street: street,
            city: city,
            state: state,
            zipCode: zipCode
        )
        
        authViewModel.updateProfile(
            name: name,
            phone: phone,
            address: newAddress
        )
        
        presentationMode.wrappedValue.dismiss()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProfileView()
                .environmentObject(AuthenticationViewModel())
        }
    }
}
