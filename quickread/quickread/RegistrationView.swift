import SwiftUI
import Amplify
import AmplifyPlugins

struct RegistrationView: View {
    @State private var phoneNumber: String = ""
    @State private var password: String = ""
    @State private var confirmationCode: String = ""
    @State private var isShowingConfirmationView = false
    
    var body: some View {
        VStack {
            if !isShowingConfirmationView {
                TextField("Phone Number", text: $phoneNumber)
                    .keyboardType(.phonePad)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                Button(action: signUp) {
                    Text("Sign Up")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            } else {
                TextField("Confirmation Code", text: $confirmationCode)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                
                Button(action: confirmSignUp) {
                    Text("Confirm Sign Up")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
        }
        .padding()
    }
    
    func signUp() {
        let userAttributes = [AuthUserAttribute(.phoneNumber, value: phoneNumber)]
        let options = AuthSignUpRequest.Options(userAttributes: userAttributes)
        
        _ = Amplify.Auth.signUp(username: phoneNumber, password: password, options: options) { result in
            switch result {
            case .success(let signUpResult):
                print("Sign up result: \(signUpResult)")
                if signUpResult.isSignupComplete {
                    print("Sign up complete")
                } else {
                    DispatchQueue.main.async {
                        isShowingConfirmationView = true
                    }
                }
            case .failure(let error):
                print("Sign up error: \(error)")
            }
        }
    }
    
    func confirmSignUp() {
        _ = Amplify.Auth.confirmSignUp(for: phoneNumber, confirmationCode: confirmationCode) { result in
            switch result {
            case .success(let confirmResult):
                if confirmResult.isSignupComplete {
                    print("Confirmation successful")
                } else {
                    print("Confirmation not completed")
                }
            case .failure(let error):
                print("Confirmation error: \(error)")
            }
        }
    }
}
