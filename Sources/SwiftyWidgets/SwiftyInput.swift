//
//  InputField.swift
//  HealthDiet
//
//  Created by Ali Raza on 21/01/2024.


import SwiftUI

@available(iOS 15.0, *)
public struct SwiftyInput: View {
    @Binding var text: String
    @State private var isSecure: Bool
    @State private var showError = false
    @FocusState private var isFocused: Bool
    var delegate: SwiftyInputProtocol?
    @State var errorMsg: String = ""
    var props: InputFieldProps

    public init(text: Binding<String>, props: InputFieldProps = InputFieldProps(), delegate: SwiftyInputProtocol? = nil) {
        self._text = text
        self.props = props
        self.delegate = delegate
        self._isSecure = State<Bool>(initialValue: props.isSecure)
        UITextField.appearance().tintColor = props.cursorColor.uiColor()
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack (spacing: 0){
                if let leftView = props.leftView {
                    leftView
                        .fgStyle(props.leftViewColor)
                        .padding(.trailing, props.leftViewSpace)
                }

                getFieldView()
                    .focused($isFocused)
                    .onChangeInput(of: text, delegate: delegate, perform: self.onChangeText(_:))
                    .fgStyle(props.textColor)
                    .textFieldStyle(.plain)
                    
                if !self.text.trim().isEmpty && props.showClearIcon {
                    Button {
                        self.text = ""
                    } label: {
                        props.clearIcon
                            .tint(props.clearIconColor)
                    }
                }
                
                if props.isSecure {
                    getSecureIconView()
                }
                if let rightView = props.rightView {
                    rightView
                        .fgStyle(props.rightViewColor)
                        .padding(.leading, props.rightViewSpace)
                }
                
            }//HStack
            .padding(.horizontal, 10, if: props.style == .BORDERD)
            .border(props.borderProps.color, width: isFocused ? props.borderProps.width: 1.0, if: props.showBorder())
            .background(props.backgroundColor)
            
            if props.style == .UNDERLINED {
                withAnimation {
                    Rectangle()
                        .frame(height: isFocused ? props.borderProps.width: 1.0)
                        .fgStyle(showError && !isFocused ? .red : props.borderProps.color)
                }
                
            }
            
            //Error View/ Limit View
            HStack() {
                if !isFocused && showError {
                    Text(errorMsg)
                        .font(ThemeFonts.SwiftyInput.errorFont)
                        .foregroundStyle(.red)
                }
                Spacer()
            }
            .padding(.vertical, 5)
            
        }
        .onTapGesture {
            isFocused = true
        }
        .onChangeFocus(of: isFocused, delegate: delegate, perform: self.onFocus(_:))
    }
    
    
    @ViewBuilder
    private func getFieldView() -> some View {
        if isSecure {
            if #available(iOS 15.0, *) {
                secureField()
            } else {
                ZStack {
                    if text.isEmpty{
                        getPlaceholder()
                    }
                    secureField()
                }
            }
        } else {
            if #available(iOS 15.0, *) {
                textField()
            } else {
                ZStack {
                    if text.isEmpty{
                        getPlaceholder()
                    }
                    textField()
                        .foregroundColor(.blue)
                }
                
            }
        }
    }
    
    private func secureField() -> some View {
        SecureField("", text: $text, prompt: getPlaceholder())
            .font(props.font)
            .padding(.vertical, 15)
    }
    
    private func textField() -> some View {
        TextField("", text: $text, prompt: getPlaceholder())
            .font(props.font)
            .padding(.vertical, 15)
    }
    
    private func getPlaceholder() -> Text? {
        if #available(iOS 17.0, *) {
            Text(props.placeholder)
                .foregroundStyle(props.placeholderColor)
                .font(props.font)
        } else {
            Text(props.placeholder)
                .foregroundColor(props.placeholderColor)
                .font(props.font)
        }
    }
    
    @ViewBuilder
    private func getSecureIconView()-> some View {
        Button {
            self.isSecure.toggle()
        } label: {
            if let iconName = getSecureIconName() {
                Image(systemName: iconName)
                    .tint(ThemeColors.SwiftyInput.rightView)
            }
        }
        .padding(.leading, 8)
    }
    private func getSecureIconName() -> String? {
        let icons = props.secureIcons.split(separator: ",")
        if nil == icons[0] || nil == icons[1] {
            return nil
        }
        return isSecure ? "\(icons[0])": "\(icons[1])"
    }
}

@available(iOS 15.0, *)
extension SwiftyInput {
    private func onChangeText(_ value: String) {
        if props.limit > -1 {
            text = String(value.prefix(props.limit))
        }
        validate()
    }
    
    private func onFocus(_ value: Bool) {
        print("Defalut Inuput on focus called.")
        print("\(props.placeholder) is focused: \(value)")
        if value {
            
        } else {
            validate()
        }
    }
    
    private func validate() {
        print("validation called")
        if props.isMandatory && text.isBlank() {
            errorMsg = props.errors.mandatory
            showError = true
        } else if text.range(of: props.regex, options: .regularExpression) == nil {
            errorMsg = props.errors.regex
            showError = true
        } else {
            showError = false
        }
    }
}

#if DEBUG
@available(iOS 15.0, *)
struct TestContentView: View {
    @State private var text = ""

    var body: some View {
        VStack {
            SwiftyInput(text: $text, props: InputFieldProps(showClearIcon: false, isMandatory: true))
            SwiftyInput(text: $text, props: InputFieldProps(leftView: AnyView(Image(systemName: "person"))))
            SwiftyInput(text: $text, props: InputFieldProps(leftView: AnyView(Image(systemName: "person"))))
            SwiftyInput(text: $text, props: InputFieldProps(leftView: AnyView(Text("🔒")), rightView: AnyView(Image(systemName: "eyeglasses")), isSecure: true))
            SwiftyInput(text: $text, props: InputFieldProps(leftView: AnyView(Text("🔒")), rightView: AnyView(Image(systemName: "eyeglasses"))))
                            
        }
    }
}
@available(iOS 15.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TestContentView()
            .padding()
    }
}

#endif

@available(iOS 15.0, *)
public struct InputFieldProps {
    public var placeholder: String
    public var leftView: AnyView?
    public var rightView: AnyView?
    public var leftViewSpace: CGFloat
    public var rightViewSpace: CGFloat
    public var leftViewColor: Color
    public var rightViewColor: Color
    public var clearIcon: Image
    public var showClearIcon: Bool
    public var secureIcons: String
    public var cursorColor: Color
    public var textColor: Color
    public var placeholderColor: Color
    public var clearIconColor: Color
    public var backgroundColor: Color
    public var borderProps: BorderProps
    public var font: Font
    public var isSecure: Bool
    public var style: InputFieldStyle
    public var limit: Int
    public var regex: String
    public var errors: ErrorMsgs
    public var isMandatory: Bool
    
    public init(placeholder: String = "Placeholder...", leftView: AnyView? = nil, rightView: AnyView? = nil, leftViewSpace: CGFloat = 5.0, rightViewSpace: CGFloat = 5.0, leftViewColor: Color = ThemeColors.SwiftyInput.leftView, rightViewColor: Color = ThemeColors.SwiftyInput.rightView, clearIcon: Image = Image(systemName: "multiply"), showClearIcon: Bool = true, secureIcons: String = "eye.fill,eye.slash.fill", cursorColor: Color = ThemeColors.SwiftyInput.tint, textColor: Color = ThemeColors.SwiftyInput.forground, placeholderColor: Color = ThemeColors.SwiftyInput.placeholderColor, clearIconColor: Color = ThemeColors.SwiftyInput.tint, backgroundColor: Color = ThemeColors.SwiftyInput.background, borderProps: BorderProps = BorderProps(color: ThemeColors.SwiftyInput.border, width: 2.0), font: Font  = ThemeFonts.SwiftyInput.font, isSecure: Bool = false, style: InputFieldStyle = .UNDERLINED, limit: Int = -1, regex: String = ".*", errors: ErrorMsgs = ErrorMsgs(), isMandatory: Bool = false) {
        
        self.placeholder = placeholder
        self.leftView = leftView
        self.rightView = rightView
        self.leftViewSpace = leftViewSpace
        self.rightViewSpace = rightViewSpace
        self.leftViewColor = leftViewColor
        self.rightViewColor = rightViewColor
        self.clearIcon = clearIcon
        self.secureIcons = secureIcons
        self.showClearIcon = showClearIcon
        self.cursorColor = cursorColor
        self.textColor = textColor
        self.placeholderColor = placeholderColor
        self.clearIconColor = clearIconColor
        self.backgroundColor = backgroundColor
        self.borderProps = borderProps
        self.font = font
        self.isSecure = isSecure
        self.style = style
        self.limit = limit
        self.regex = regex
        self.errors = errors
        self.isMandatory = isMandatory
    }
    
    public func showBorder()-> Bool {
        self.style == .BORDERD
    }
}

public enum InputFieldStyle {
    case BORDERD, UNDERLINED
}

public protocol SwiftyInputProtocol {
    func onFocus(_ value: Bool)
    func onSubmit()
    func onChange(_ newValue: String)
}

public struct ErrorMsgs {
    public var regex = "Invalid Input"
    public var mandatory = "Field is mandatory"
    
    public init(){
        
    }
}
