import SwiftUI

@main
struct RentaCarritosApp: App {
    @StateObject private var authViewModel = AuthenticationViewModel()
    @StateObject private var rentalViewModel = RentalViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if authViewModel.isAuthenticated {
                    TabView {
                        HomeView()
                            .tabItem {
                                Label("Inicio", systemImage: "house.fill")
                            }
                        
                        RentalHistoryView()
                            .tabItem {
                                Label("Mis Rentas", systemImage: "clock.fill")
                            }
                        
                        ProfileView()
                            .tabItem {
                                Label("Perfil", systemImage: "person.fill")
                            }
                    }
                    .environmentObject(authViewModel)
                    .environmentObject(rentalViewModel)
                } else {
                    LoginView()
                        .environmentObject(authViewModel)
                }
            }
        }
    }
}

// Preview Provider
struct RentaCarritosApp_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Text("Preview Content")
        }
    }
}
