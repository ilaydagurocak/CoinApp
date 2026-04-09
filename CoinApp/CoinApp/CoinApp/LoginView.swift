import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    
    @State private var email = ""
    @State private var password = ""
    @State private var showRegister = false
    @State private var showForgotPassword = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background
                    .ignoresSafeArea()
                
                VStack(spacing: 24) {
                    Spacer()
                    
                    VStack(spacing: 10) {
                        Text("CoinApp")
                            .font(.system(size: 34, weight: .bold))
                            .foregroundColor(AppColors.yellow)
                        
                        Text("Track crypto markets live")
                            .font(.subheadline)
                            .foregroundColor(AppColors.textSecondary)
                    }
                    
                    VStack(spacing: 16) {
                        TextField("Email", text: $email)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .keyboardType(.emailAddress)
                            .padding()
                            .background(AppColors.card)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                        
                        SecureField("Password", text: $password)
                            .padding()
                            .background(AppColors.card)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.horizontal)
                    
                    if !authViewModel.errorMessage.isEmpty {
                        Text(authViewModel.errorMessage)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                    }
                    
                    Button {
                        Task {
                            await authViewModel.login(email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                                                      password: password)
                        }
                    } label: {
                        HStack {
                            if authViewModel.isLoading {
                                ProgressView()
                                    .tint(.black)
                            } else {
                                Text("Login")
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(AppColors.yellow)
                        .foregroundColor(.black)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.horizontal)
                    
                    Button("Forgot Password?") {
                        showForgotPassword = true
                    }
                    .foregroundColor(AppColors.yellow)
                    
                    HStack(spacing: 6) {
                        Text("Don’t have an account?")
                            .foregroundColor(AppColors.textSecondary)
                        Button("Register") {
                            showRegister = true
                        }
                        .foregroundColor(AppColors.yellow)
                    }
                    .font(.footnote)
                    
                    Spacer()
                }
            }
            .navigationDestination(isPresented: $showRegister) {
                RegisterView()
            }
            .navigationDestination(isPresented: $showForgotPassword) {
                ForgotPasswordView()
            }
        }
    }
}
