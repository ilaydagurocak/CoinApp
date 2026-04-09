import SwiftUI

struct RegisterView: View {
    
    @EnvironmentObject var authViewModel: AuthViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var localError = ""
    
    var body: some View {
        ZStack {
            AppColors.background
                .ignoresSafeArea()
            
            VStack(spacing: 22) {
                Text("Create Account")
                    .font(.system(size: 30, weight: .bold))
                    .foregroundColor(AppColors.yellow)
                    .padding(.top, 40)
                
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
                    
                    SecureField("Confirm Password", text: $confirmPassword)
                        .padding()
                        .background(AppColors.card)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .padding(.horizontal)
                
                if !localError.isEmpty {
                    Text(localError)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                if !authViewModel.errorMessage.isEmpty {
                    Text(authViewModel.errorMessage)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(.horizontal)
                }
                
                Button {
                    localError = ""
                    
                    guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
                        localError = "Lütfen tüm alanları doldur."
                        return
                    }
                    
                    guard password == confirmPassword else {
                        localError = "Şifreler eşleşmiyor."
                        return
                    }
                    
                    guard password.count >= 6 else {
                        localError = "Şifre en az 6 karakter olmalı."
                        return
                    }
                    
                    Task {
                        await authViewModel.register(email: email.trimmingCharacters(in: .whitespacesAndNewlines),
                                                     password: password)
                    }
                } label: {
                    HStack {
                        if authViewModel.isLoading {
                            ProgressView()
                                .tint(.black)
                        } else {
                            Text("Create Account")
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
        .navigationTitle("Register")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .hideKeyboardOnTap()
        
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColors.yellow)
                }
            }
        }
    }
}

