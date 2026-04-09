import SwiftUI

struct ForgotPasswordView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Reset Password")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(AppColors.yellow)
                    .padding(.top, 40)
                
                Text("Enter your email and we’ll send you a reset link.")
                    .font(.subheadline)
                    .foregroundColor(AppColors.textSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                TextField("Email", text: $email)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                    .keyboardType(.emailAddress)
                    .padding()
                    .background(AppColors.card)
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .padding(.horizontal)
                
                if !authViewModel.errorMessage.isEmpty {
                    Text(authViewModel.errorMessage)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                if !authViewModel.infoMessage.isEmpty {
                    Text(authViewModel.infoMessage)
                        .font(.footnote)
                        .foregroundColor(.green)
                        .padding(.horizontal)
                }
                
                Button {
                    Task {
                        await authViewModel.sendPasswordReset(email: email.trimmingCharacters(in: .whitespacesAndNewlines))
                    }
                } label: {
                    HStack {
                        if authViewModel.isLoading {
                            ProgressView()
                                .tint(.black)
                        } else {
                            Text("Send Reset Email")
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
                
                Spacer()
            }
        }
        .navigationTitle("Forgot Password")
        .navigationBarTitleDisplayMode(.inline)
    }
}
