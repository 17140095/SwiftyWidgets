//
//  InputField.swift
//  HealthDiet
//
//  Created by Ali Raza on 21/01/2024.


import SwiftUI

@available(iOS 15.0, *)
public struct SwiftyInput: View {
    @Binding var text: String
    @State private var isSecure: Bool = true
    @FocusState private var isFocused: Bool
    var props: InputFieldProps

    public init(text: Binding<String>, props: InputFieldProps = InputFieldProps()) {
        self._text = text
        self.props = props
        self.isSecure = props.isSecure
        UITextField.appearance().tintColor = props.cursorColor
    }

    public var body: some View {
        getContent()
    }
    
    private func getContent() -> some View {
        VStack(spacing: 0) {
            HStack (spacing: 0){
                if let leftView = props.leftView {
                    leftView
                        .foregroundStyle(props.leftViewColor)
                        .padding(.trailing, props.leftViewSpace)
                }

                getField(isSecure: isSecure)
                    .focused($isFocused)
                    .foregroundStyle(props.textColor)
                    .textFieldStyle(.plain)
                    .padding(.vertical, 15)
                if !self.text.trim().isEmpty {
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
                        .foregroundStyle(props.rightViewColor)
                        .padding(.leading, props.rightViewSpace)
                }
                
            }//HStack
            .padding(.horizontal, 10, if: props.style == .BORDERD)
            .border(props.borderProps.color, width: props.borderProps.width, if: props.showBorder())
            .background(props.backgroundColor)
            
            if props.style == .UNDERLINED {
                withAnimation {
                    Rectangle()
                        .frame(height: isFocused ? props.borderProps.width: 1.0)
                        .foregroundStyle(props.borderProps.color)
                }
                
            }
        }
    }
    
    @ViewBuilder
    private func getField(isSecure: Bool) -> some View {
        if isSecure {
            SecureField("", text: $text, prompt: getPlaceholder())
        } else {
            TextField("", text: $text, prompt: getPlaceholder())
        }
    }
    
    @ViewBuilder
    private func getSecureIconView()-> some View {
        Button {
            self.isSecure.toggle()
        } label: {
            Image(systemName: getSecureIconName())
                .tint(ThemeColors.SwiftyInut.rightView)
        }
        .padding(.leading, 8)
    }
    private func getSecureIconName() -> String {
        let icons = props.secureIcons.split(separator: ",")
        
        return isSecure ? "\(icons[0])": "\(icons[1])"
    }
    
    private func getPlaceholder() -> Text? {
        if #available(iOS 17.0, *) {
            Text(props.placeholder)
                .foregroundStyle(props.placeholderColor)
                .font(props.font)
        } else {
            // Fallback on earlier versions
            Text(props.placeholder)
                .foregroundColor(props.placeholderColor)
                .font(props.font)
        }
    }
    
}

#if DEBUG
@available(iOS 15.0, *)
struct TestContentView: View {
    @State private var text = ""

    var body: some View {
        VStack {
            SwiftyInput(text: $text)
            SwiftyInput(text: $text, props: InputFieldProps(leftView: AnyView(Image(systemName: "person"))))
            SwiftyInput(text: $text, props: InputFieldProps(leftView: AnyView(Image(systemName: "person"))))
            SwiftyInput(text: $text, props: InputFieldProps(leftView: AnyView(Text("🔒")), rightView: AnyView(Image(systemName: "eyeglasses"))))
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
    public var secureIcons: String
    public var cursorColor: UIColor
    public var textColor: Color
    public var placeholderColor: Color
    public var clearIconColor: Color
    public var backgroundColor: Color
    public var borderProps: BorderProps
    public var font: Font
    public var isSecure: Bool
    public var style: InputFieldStyle
    
    
    public init(placeholder: String = "Placeholder...", leftView: AnyView? = nil, rightView: AnyView? = nil, leftViewSpace: CGFloat = 5.0, rightViewSpace: CGFloat = 5.0, leftViewColor: Color = ThemeColors.SwiftyInut.leftView, rightViewColor: Color = ThemeColors.SwiftyInut.rightView, clearIcon: Image = Image(systemName: "multiply"), secureIcons: String = "eye.fill,eye.slash.fill", cursorColor: UIKit.UIColor = UIColor(ThemeColors.SwiftyInut.tint), textColor: Color = ThemeColors.SwiftyInut.forground, placeholderColor: Color = ThemeColors.SwiftyInut.tint, clearIconColor: Color = ThemeColors.SwiftyInut.tint, backgroundColor: Color = ThemeColors.SwiftyInut.background, borderProps: BorderProps = BorderProps(color: ThemeColors.SwiftyInut.border, width: 2.0), font: Font  = ThemeFonts.primary, isSecure: Bool = false, style: InputFieldStyle = .UNDERLINED) {
        
        self.placeholder = placeholder
        self.leftView = leftView
        self.rightView = rightView
        self.leftViewSpace = leftViewSpace
        self.rightViewSpace = rightViewSpace
        self.leftViewColor = leftViewColor
        self.rightViewColor = rightViewColor
        self.clearIcon = clearIcon
        self.secureIcons = secureIcons
        self.cursorColor = cursorColor
        self.textColor = textColor
        self.placeholderColor = placeholderColor
        self.clearIconColor = clearIconColor
        self.backgroundColor = backgroundColor
        self.borderProps = borderProps
        self.font = font
        self.isSecure = isSecure
        self.style = style
    }
    
    public func showBorder()-> Bool {
        self.style == .BORDERD
    }
}



public enum InputFieldStyle {
    case BORDERD, UNDERLINED
}
