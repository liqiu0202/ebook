import AuthenticationServices
import Combine
import CryptoKit

class SignInWithAppleManager: NSObject, ObservableObject {
    
    @Published var isAuthorized = UserDefaults.standard.bool(forKey: "isAuthorized")

    // Unhashed nonce.
    private var currentNonce: String?
    
    override init() {
        super.init()
        isAuthorized = UserDefaults.standard.bool(forKey: "isAuthorized")
        print("isAuthorizd: \(isAuthorized)")
        if isAuthorized {
            checkCredentialState()
        }
    }

    func checkCredentialState() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        if let userIdentifier = UserDefaults.standard.string(forKey: "userIdentifier") {
            print("userIdentifier: \(userIdentifier)")
            appleIDProvider.getCredentialState(forUserID: userIdentifier) { (state, error) in
                if state == .notFound {
                    UserDefaults.standard.set(false, forKey: "isAuthorized")
                    DispatchQueue.main.async {
                        self.isAuthorized = false
                    }
                }
            }
        } else {
            // No userIdentifier found in UserDefaults.
            // This probably means that the user has not signed in through Apple ID yet.
            // You could handle this case appropriately depending on your app's requirements.
            // For example, you might want to set isAuthorized to false:
            DispatchQueue.main.async {
                self.isAuthorized = false
            }
        }
    }
    
    func onRequest(request: ASAuthorizationAppleIDRequest) {
        currentNonce = randomNonceString()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(currentNonce!)
    }
    
    func onCompletion(result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authResults):
            guard let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential,
                  let nonce = currentNonce,
                  let appleIDToken = appleIDCredential.identityToken else {
                return
            }
            
            // Save the user identifier.
            UserDefaults.standard.set(appleIDCredential.user, forKey: "userIdentifier")
            print("Guard statement succeeded crediential.user \(appleIDCredential.user)")

            UserDefaults.standard.set(true, forKey: "isAuthorized")
            print("after setting userdefault \(UserDefaults.standard.bool(forKey: "isAuthorized"))")
            isAuthorized = true
            
            // please note that email and fullName will be returned only for the first-time login and they will be nil for the rest of the sign-in attempts
            let userId = appleIDCredential.user
            let email = appleIDCredential.email
            let fullName = appleIDCredential.fullName
                
        case .failure(let error):
            // Handle error.
            isAuthorized = false
            print("Authorization failed: " + error.localizedDescription)
        }
    }

    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0..<16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result
    }
}
