import SwiftUI

struct LoginView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var email = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: AppTheme.Spacing.lg) {
            // Header
            VStack(spacing: AppTheme.Spacing.sm) {
                Text("Login to FavStop")
                    .font(AppTheme.Typography.title1)
                    .foregroundColor(Color.primary)
                
                Text("Sign in to save your favorite stops")
                    .font(AppTheme.Typography.body)
                    .foregroundColor(Color.secondary)
            }
            .padding(.bottom, AppTheme.Spacing.lg)
            
            // Social Login
            Button(action: handleGoogleSignIn) {
                HStack {
                    Image(systemName: "g.circle.fill")
                        .font(.system(size: 20))
                    Text("Continue with Google")
                }
                .frame(maxWidth: .infinity)
                .secondaryButton()
            }
            .disabled(isLoading)
            
            // Divider
            HStack {
                Rectangle()
                    .fill(Color.secondary.opacity(0.3))
                    .frame(height: 1)
                
                Text("or")
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(Color.secondary)
                
                Rectangle()
                    .fill(Color.secondary.opacity(0.3))
                    .frame(height: 1)
            }
            .padding(.vertical, AppTheme.Spacing.md)
            
            // Email Login
            VStack(spacing: AppTheme.Spacing.md) {
                TextField("Email", text: $email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .textContentType(.emailAddress)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disabled(isLoading)
                
                Button(action: handleEmailLogin) {
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    } else {
                        Text("Send Magic Link")
                    }
                }
                .frame(maxWidth: .infinity)
                .primaryButton()
                .disabled(isLoading || !isValidEmail(email))
            }
            
            if let error = errorMessage {
                Text(error)
                    .font(AppTheme.Typography.caption)
                    .foregroundColor(AppTheme.Colors.error)
                    .multilineTextAlignment(.center)
                    .padding(.top, AppTheme.Spacing.sm)
            }
            
            Spacer()
        }
        .padding(AppTheme.Spacing.lg)
        .background(AppTheme.Colors.adaptiveBackground(for: colorScheme))
    }
    
    private func handleGoogleSignIn() {
        // TODO: Implement Google Sign In
        isLoading = true
        errorMessage = nil
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
            errorMessage = "Google Sign In not implemented yet"
        }
    }
    
    private func handleEmailLogin() {
        guard isValidEmail(email) else {
            errorMessage = "Please enter a valid email address"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            isLoading = false
            errorMessage = "Magic link functionality not implemented yet"
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

#Preview {
    LoginView()
} 