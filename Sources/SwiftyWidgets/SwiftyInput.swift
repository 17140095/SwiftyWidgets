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
    @FocusState private var isFocused: Bool
    var props: InputFieldProps

    public init(text: Binding<String>, props: InputFieldProps = InputFieldProps()) {
        self._text = text
        self.props = props
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
                    .fgStyle(props.textColor)
                    .textFieldStyle(.plain)
                    .padding(.vertical, 15)
                    
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
            .border(props.borderProps.color, width: props.borderProps.width, if: props.showBorder())
            .background(props.backgroundColor)
            
            if props.style == .UNDERLINED {
                withAnimation {
                    Rectangle()
                        .frame(height: isFocused ? props.borderProps.width: 1.0)
                        .fgStyle(props.borderProps.color)
                }
                
            }
        }
    }
    
    
    @ViewBuilder
    private func getFieldView() -> some View {
        if isSecure {
            if #available(iOS 15.0, *) {
                getField(forSecure: true)
            } else {
                ZStack {
                    if text.isEmpty{
                        getPlaceholder()
                    }
                    getField(forSecure: true)
                }
            }
        } else {
            if #available(iOS 15.0, *) {
                getField(forSecure: false)
            } else {
                ZStack {
                    if text.isEmpty{
                        getPlaceholder()
                    }
                    getField(forSecure: false)
                        .foregroundColor(.blue)
                }
                
            }
        }
    }
    
    private func getField(forSecure: Bool) -> some View {
        Group {
            if forSecure {
                SecureField("", text: $text)
                    .onChange(of: text, perform: { value in
                        if props.limit > -1 {
                            text = String(value.prefix(props.limit))
                        }
                    })
            } else {
                TextField("", text: $text)
                    .onChange(of: text, perform: { value in
                        if props.limit > -1 {
                            text = String(value.prefix(props.limit))
                        }
                    })
            }
        }.padding(0)
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
                    .tint(ThemeColors.SwiftyInut.rightView)
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

#if DEBUG
@available(iOS 15.0, *)
struct TestContentView: View {
    @State private var text = ""

    var body: some View {
        VStack {
            SwiftyInput(text: $text, props: InputFieldProps(showClearIcon: false, limit: -1))
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
    
    public init(placeholder: String = "Placeholder...", leftView: AnyView? = nil, rightView: AnyView? = nil, leftViewSpace: CGFloat = 5.0, rightViewSpace: CGFloat = 5.0, leftViewColor: Color = ThemeColors.SwiftyInut.leftView, rightViewColor: Color = ThemeColors.SwiftyInut.rightView, clearIcon: Image = Image(systemName: "multiply"), showClearIcon: Bool = true, secureIcons: String = "eye.fill,eye.slash.fill", cursorColor: Color = ThemeColors.SwiftyInut.tint, textColor: Color = ThemeColors.SwiftyInut.forground, placeholderColor: Color = ThemeColors.SwiftyInut.tint, clearIconColor: Color = ThemeColors.SwiftyInut.tint, backgroundColor: Color = ThemeColors.SwiftyInut.background, borderProps: BorderProps = BorderProps(color: ThemeColors.SwiftyInut.border, width: 2.0), font: Font  = ThemeFonts.SwiftyInput.font, isSecure: Bool = false, style: InputFieldStyle = .UNDERLINED, limit: Int = -1) {
        
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
    }
    
    public func showBorder()-> Bool {
        self.style == .BORDERD
    }
}



public enum InputFieldStyle {
    case BORDERD, UNDERLINED
}
