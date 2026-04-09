import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 22) {
                    VStack(spacing: 12) {
                        Image(systemName: "person.crop.circle.fill")
                            .font(.system(size: 85))
                            .foregroundColor(AppColors.yellow)
                        
                        Text(Auth.auth().currentUser?.email ?? "No email")
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                    .padding(.top, 30)
                    
                    VStack(spacing: 14) {
                        ProfileRow(icon: "envelope.fill", title: "Email", value: Auth.auth().currentUser?.email ?? "-")
                        ProfileRow(icon: "bitcoinsign.circle.fill", title: "App", value: "CoinApp")
                        ProfileRow(icon: "star.fill", title: "Theme", value: "Black & Yellow")
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button {
                        authViewModel.signOut()
                    } label: {
                        Text("Log Out")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(AppColors.yellow)
                            .foregroundColor(.black)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct ProfileRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(AppColors.yellow)
                .frame(width: 28)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .foregroundColor(.gray)
                    .font(.caption)
                Text(value)
                    .foregroundColor(.white)
                    .font(.headline)
            }
            
            Spacer()
        }
        .padding()
        .background(AppColors.card)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}
