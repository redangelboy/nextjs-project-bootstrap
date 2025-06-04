import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var showingAlert = false
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 12) {
                Image(systemName: "cart.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.black)
                
                Text("Renta de Carritos")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Inicia sesión para continuar")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.top, 60)
            
            // Login Form
            VStack(spacing: 16) {
                // Email Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Correo electrónico")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    TextField("ejemplo@correo.com", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                // Password Field
                VStack(alignment: .leading, spacing: 8) {
                    Text("Contraseña")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    SecureField("••••••••", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .padding(.horizontal, 32)
            
            // Login Button
            Button(action: login) {
                if authViewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                } else {
                    Text("Iniciar Sesión")
                        .fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.black)
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal, 32)
            .disabled(authViewModel.isLoading)
            
            // Error Message
            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
                    .padding(.top, 8)
            }
            
            Spacer()
            
            // Demo Account Info
            VStack(spacing: 8) {
                Text("Cuenta de demostración:")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text("demo@example.com / password")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .padding(.bottom, 32)
        }
    }
    
    private func login() {
        let credentials = UserCredentials(
            email: email,
            password: password
        )
        authViewModel.login(with: credentials)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(AuthenticationViewModel())
    }
}
