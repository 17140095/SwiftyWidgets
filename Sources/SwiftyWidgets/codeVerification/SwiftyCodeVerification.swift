//
//  File.swift
//  
//
//  Created by Ali Raza on 02/08/2024.
//

import SwiftUI
import Combine

@available(iOS 16.0, *)
public struct CodeVerification: View {
    
    
    @ObservedObject var viewModel: CodeVerificationVM
    @State var goOTP: Bool = false
    
    var title: String
    var shouldDisable: Bool = false
    var shouldCachePhone: Bool? = nil
    var shouldCacheEmail: Bool? = nil
    var readPhoneCache: Bool? = nil
    var readEmailCache: Bool? = nil
    
    public init(viewModel: CodeVerificationVM, title: String = "Code Verification") {
        self.viewModel = viewModel
        self.title = title
    }
    public var body: some View {
        mainView
        .showLoading(isLoading: $viewModel.isLoading)
        .swiftyAlert(isPresented: $viewModel.showAlert, title: viewModel.alertTitle, message: viewModel.errorMessage)
    }
    
    private var mainView: some View {
        VStack {
            if goOTP {
                OTPVerification(viewModel: viewModel, title: title)
            } else {
                sendCodeView
            }
        }
        .background(AppConfig.backgroundColor)
        .customBackButton(title: title) {
            goOTP = false
        }
    }
    
    private var sendCodeView: some View {
        VStack(spacing: 20) {
            Text(getTitle())
                .font(AppConfig.font)
                .fontWeight(.bold)
            Text(getDescription())
                .multilineTextAlignment(.center)
                .font(AppConfig.font)
            
            switch viewModel.by {
            case .PHONE_NO:
                phoneSelector
            case .EMAIL:
                emailInput
            case .BOTH:
                phoneSelector
                emailInput
            }
            
            SwiftyButton(title: "Receive code") {
                viewModel.delegate?.sendCode(){
                    goOTP = true
                }
            }
            .disableWithOpacity(shouldDisableContinueBtn())
        }
        .padding(.vertical)
        .cardView()
        .padding()
        .frame(maxHeight: .infinity)
    }
    
    private var phoneSelector: some View {
        PhoneSelector(key: "CodeVerification")
            .setShowBorder(true)
    }
    
    private var emailInput: some View {
        SwiftyInput(label: "",prompt: "Email", text: $viewModel.emailText)
            .setStyle(AppConfig.Inputs.style)
            .setShouldFloat(AppConfig.Inputs.shouldFloat)
            .disableWithOpacity(shouldDisable)
    }
    
    private func shouldDisableContinueBtn() -> Bool {
        var toReturn = false
        switch viewModel.by {
        case .EMAIL:
            toReturn = !viewModel.emailText.isEmail()
        case .PHONE_NO:
            toReturn = viewModel.phoneText.count < 13
        case .BOTH:
            toReturn = !viewModel.emailText.isEmail() || viewModel.phoneText.count < 13
        }
        
        return toReturn
    }
    
    private func getTitle() -> String {
        var verificationText = "Number"
        if viewModel.by == .EMAIL {
            verificationText = "Email"
        } else if viewModel.by == .BOTH {
            verificationText = "Number And Email"
        }
        return "Verification \(verificationText)"
    }
    
    private func getDescription() -> String {
        return "Please enter your phone \(viewModel.by == .EMAIL ? "email" : "number"), so we can verify this account for you. Thankyou."
    }
}

@available(iOS 16.0, *)
extension CodeVerification {
    public enum Config {
        public static var OTP_TIME = 10
        public static var OTP_LENGTH = 8
    }
    
    public func setShouldCache(ofPhone: Bool = true, ofEmail: Bool = true) -> Self {
        var copy = self
        copy.shouldCachePhone = ofPhone
        copy.shouldCacheEmail = ofEmail
        return copy
    }
    public func setReadCache(ofPhone: Bool = false, ofEmail: Bool = false) -> Self {
        var copy = self
        copy.readPhoneCache = ofPhone
        copy.readEmailCache = ofEmail
        return copy
    }
}


@available(iOS 16.0, *)
fileprivate struct OTPVerification: View {
    
    @FocusState var isFocusedPhone
    @FocusState var isFocusedEmail
    @ObservedObject var viewModel: CodeVerificationVM
    var title: String
    @State var inputPhoneCode: String = ""
    @State var inputEmailCode: String = ""
    
    @State private var remainingTime: Int = CodeVerification.Config.OTP_TIME
    @State private var timer: Timer? = nil
    @State private var shouldResendCode = false
    
    
    private var codeVerifyService = CodeVerificationVM()
    private var length = CodeVerification.Config.OTP_LENGTH
    private var spaceAfter: Int {
        length/2
    }
    
    init(viewModel: CodeVerificationVM, title: String) {
        self.title = title
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack {
            Text(sentMessageModeHeading)
                .multilineTextAlignment(.center)
                .textContentType(.oneTimeCode)
                .font(AppConfig.font)
                .foregroundStyle(AppConfig.defaultTextColor)
                .padding(.bottom, 32)
            
            
            // OTP Field
            switch viewModel.by {
            case .EMAIL:
                inputField(isEmail: true)
            case .PHONE_NO:
                inputField(isEmail: false)
            case .BOTH:
                inputField(isEmail: false)
                inputField(isEmail: true)
            }
            
            // Timer
            Text(timeFormatted(remainingTime))
                .font(AppConfig.navigationTitleFont)
                .padding(.top, 23)
                .onAppear {
                    startTimer()
                }
            
            // Resend button
            SwiftyButton(title: "Request Again") {
                // Resend logic here
                remainingTime = CodeVerification.Config.OTP_TIME
                shouldResendCode = false
                print("resend tap")
                viewModel.delegate?.sendCode() {
                    startTimer()
                    inputPhoneCode = ""
                    inputEmailCode = ""
                }
            }
            .setShouldMaxWidth(false)
            .setPrimaryColor(.clear)
            .setBorder(BorderProps(color: .clear))
            .setSecondaryColor(shouldResendCode ? AppConfig.primaryColor : AppConfig.defaultTextColor)
            .setFont(AppConfig.Buttons.font)
            .disableWithOpacity(!shouldResendCode)
            .padding(.bottom, 32)
            
            
            // Confirm button
            SwiftyButton(title: "Confirm") {
                // Confirm logic here
                if viewModel.by == .BOTH {
                    viewModel.delegate?.verifyCode(emailCode: viewModel.emailText, phoneCode: viewModel.phoneText)
                } else if viewModel.by == .PHONE_NO {
                    viewModel.delegate?.verifyCode(emailCode: nil, phoneCode: viewModel.phoneText)
                } else {
                    viewModel.delegate?.verifyCode(emailCode: viewModel.emailText, phoneCode: nil)
                }
            }
            .disableWithOpacity(!isValidInputs )
        }
        .cardView(EdgeInsets(top: 50, leading: 16, bottom: 30, trailing: 16))
        .padding(16)
        .frame(maxHeight: .infinity)
        .background(AppConfig.backgroundColor)
        
    }
    
    private var isValidInputs: Bool {
        if viewModel.by == .BOTH {
            return inputPhoneCode.count == length && inputEmailCode.count == length
        } else if viewModel.by == .PHONE_NO {
            return inputPhoneCode.count == length
        } else {
            return inputEmailCode.count == length
        }
    }
    
    private func inputField(isEmail: Bool)-> some View {
        VStack {
            Text(isEmail ? viewModel.emailText.maskEmail() : viewModel.phoneText.maskPhoneNumber())
                .font(AppConfig.font)
                .bold()
                .foregroundStyle(AppConfig.defaultTextColor)
                .padding(.top)
            TextField("", text: isEmail ? $inputEmailCode : $inputPhoneCode)
                .onChange(of: isEmail ? inputEmailCode : inputPhoneCode, do: { newValue in
                    if isEmail {
                        inputEmailCode = String(inputEmailCode.prefix(length))
                    } else {
                        inputPhoneCode = String(inputPhoneCode.prefix(length))
                    }
                })
                .focused(isEmail ? $isFocusedEmail : $isFocusedPhone)
                .keyboardType(.numberPad)
                .frame(maxWidth: .infinity, maxHeight: 60)
                .opacity(0.000009)
                .overlay(alignment: .center){
                    HStack {
                        Spacer()
                        ForEach((0...length-1), id: \.self) { index in
                            box(index: index, isEmail: isEmail )
                        }
                        Spacer()
                    }
            }
        }
    }
    
    @ViewBuilder
    private func box(index: Int, isEmail: Bool) -> some View {
        RoundedRectangle(cornerRadius: boxWidth * 0.2)
            .stroke(getBorderColor(isEmail: isEmail, index: index), lineWidth: 1)
            .overlay{
                Text(getText(isEmail: isEmail, index:index))
                    .font(AppConfig.font)
                    .foregroundStyle(AppConfig.defaultTextColor)
            }
            .frame(width: boxWidth, height: 60)
//            .frame(minWidth: 25, maxWidth: 35)
            .aspectRatio(1, contentMode: .fit)
            .padding(.trailing, if: index == spaceAfter-1)
            .overlay {
                Color.white.opacity(0.0001)
                    .onTapGesture {
                        if isEmail {
                            isFocusedEmail = true
                        } else {
                            isFocusedPhone = true
                        }
                    }
            }
    }
    private var boxWidth: CGFloat {
        var toReturn: CGFloat = 25
        if length < 5 {
            toReturn = 40
        } else if length < 7 {
            toReturn = 35
        }
        return toReturn
    }
    private func getBorderColor(isEmail:Bool, index: Int) -> Color {
        var inputCode = isEmail ? inputEmailCode : inputPhoneCode
        if isEmail {
            return (index == inputCode.count-1 || (inputCode.count == 0 && index == 0)) && isFocusedEmail ? AppConfig.primaryColor : AppConfig.promptColor
        } else {
            return (index == inputPhoneCode.count-1 || (inputPhoneCode.count == 0 && index == 0)) && isFocusedPhone ? AppConfig.primaryColor : AppConfig.promptColor
        }
        
    }
    private func getText(isEmail: Bool, index: Int)-> String {
        var inputCode = isEmail ? inputEmailCode : inputPhoneCode
        return index < inputCode.count ? inputCode.charAt(index: index) : ""
    }
    
    private func startTimer() {
        if timer == nil || !(timer?.isValid ?? false) {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                if remainingTime > 0 {
                    remainingTime -= 1
                } else {
                    stopTimer()
                }
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        shouldResendCode = true
    }
    
    private func timeFormatted(_ totalSeconds: Int) -> String {
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    private var sentMessageModeHeading: String {
        var toReturn = "Enter the \(length)-digit code that we sent to you by "
        switch viewModel.by {
        case .PHONE_NO:
            toReturn += "SMS"
        case .EMAIL:
            toReturn += "Email"
        case .BOTH:
            toReturn += "SMS and Email"
        }
        return toReturn
    }
}
@available(iOS 16.0, *)
#Preview {
    OTPVerification(viewModel: CodeVerificationVM(phone: "923062096896", email: "ali@mail.com", by: .BOTH), title: "Code Verification")
}
@available(iOS 16.0, *)
#Preview {
    CodeVerification(viewModel: CodeVerificationVM())
}


