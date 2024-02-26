//
//  SwiftyInput.swift
//
//  Created by Ali Raza on 21/01/2024.


import SwiftUI

@available(iOS 15.0, *)
public struct SwiftyInput: View {
    @State var prompt: String
    @Binding var text: String
    @State private var isSecure: Bool
    @State private var showError = false
    @FocusState private var isFocused: Bool
    @State var errorMsg: String = ""
    @State var leftViewWidth: CGFloat = 0
    var delegate: SwiftyInputProtocol?
    var props: SwiftyInputProps
    var placeholder: String = ""
    

    public init(prompt: String = "Placeholder", text: Binding<String>, props: SwiftyInputProps = SwiftyInputProps(), delegate: SwiftyInputProtocol? = nil) {
        self.placeholder = prompt
        self._prompt = State<String>(initialValue: prompt)
        self._text = text
        self.props = props
        self.delegate = delegate
        self._isSecure = State<Bool>(initialValue: props.isSecure)
        UITextField.appearance().tintColor = props.cursorColor.uiColor()
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack (alignment: .bottom, spacing: 0){
                if let leftView = props.leftView {
                    getOnlyIconLabel(icon: leftView)
                        .font(props.font)
                        .fgStyle(props.rightViewColor)
                        .padding(.trailing, props.leftViewSpace)
                        .overlay {
                            GeometryReader(content: { geometry in
                                Color.clear.onAppear {
                                    leftViewWidth = geometry.size.width
                                    print("leftViewSize: \(geometry.size)")
                                }
                            })
                        }
                }
                
                getFieldView()
                    .focused($isFocused)
                    .onChangeInput(of: text, delegate: delegate, perform: self.onChangeText(_:))
                    .fgStyle(props.textColor)
                    .textFieldStyle(.plain)
                    .overlay(alignment: .bottomLeading) {
                        HStack {
                            
                            Label {
                                Text(prompt)
                                    .fgStyle(getFloatingValue() > 0.0 ? props.leftViewColor : props.placeholderColor)
                            } icon: {
                                Image(systemName: "circle.fill")
                                    .fgStyle(.red)
                            }
                            .labelStyle(SwiftyInputLabelStyle(props: props))
                            .font(props.font)
                            .offset(getOffsetSize())
                            .scaleEffect(getScaleValue(), anchor: .leading)
                            Spacer()
                        }
                        .animation(.easeInOut, value: isFocused)
                    }
                
                HStack(spacing: props.rightViewSpace) {
                    if !self.text.trim().isEmpty && props.showClearIcon {
                        Button {
                            self.text = ""
                        } label: {
                            props.clearIcon
                                .tint(props.clearIconColor)
                                .font(props.font)
                        }
                    }
                    
                    if props.isSecure {
                        getSecureIconView()
                    }
                    if let rightView = props.rightView {
                       getOnlyIconLabel(icon: rightView)
                            .font(props.font)
                            .fgStyle(props.rightViewColor)
                    }
                }
                
                
            }//HStack
            .padding(.top, 15)
            .padding(.bottom, getBottomSpaceValue())
            .padding(.horizontal, 10, if: props.style == .BORDERD)
            .padding(.top, getBorderFloatValue())
            .border(props: props.borderProps ?? BorderProps(), isFocus: isFocused, isError: showError, if: props.style == .BORDERD)
            .background(props.backgroundColor)
            
            if props.style != .BORDERD {
                withAnimation {
                    Rectangle()
                        .frame(height: isFocused ? props.borderProps?.getFocusWidth() ?? 2.0 : props.borderProps?.width ?? 1.0 )
                        .fgStyle(getBorderColor())
                }
                
            }
            
            //Error View/ Limit View
            HStack() {
                if !isFocused && showError {
                    Text(errorMsg)
                        .font(AppConfig.Inputs.errorFont)
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
    
    private func getFloatingValue() -> CGFloat {
        var toReturn = 0.0
        if props.shouldFloat {
            if isFocused {
                toReturn = -25
            } else {
                toReturn = text.isEmpty ? 0 : -25
            }
        }
        return toReturn
    }
    
    private func getScaleValue() -> CGFloat {
        
        return props.shouldFloat && (isFocused || !text.isEmpty) ? 0.8 : 1.0
    }
    
    private func getBorderFloatValue() -> CGFloat {
        props.style == .BORDERD && props.shouldFloat && (isFocused || !text.isEmpty) ? 10.0 : 0.0
    }
    
    private func getOffsetSize() -> CGSize {
        let x = (getFloatingValue() < 0.0 && leftViewWidth > 0) ? -(leftViewWidth + 5) : 0.0
        let y = getFloatingValue()
        
        return CGSize(width: x, height: y)
    }
    
    private func getBorderColor() -> Color {
        return showError && !isFocused ? .red : props.borderProps?.color ?? AppConfig.primaryColor
    }
    
    @ViewBuilder
    private func getOnlyIconLabel(icon: Image) -> some View {
        Label {
        } icon: {
            icon
        }
        
    }
    
    @ViewBuilder
    private func getFieldView() -> some View {
        if isSecure {
            SecureField("", text: $text, prompt: nil)
                .font(props.font)
        } else {
            TextField("", text: $text, prompt: nil)
                .font(props.font)
        }
    }
    
    private func getBottomSpaceValue() -> CGFloat {
        props.style == .BORDERD ? 15 : 8
    }
    
    private func getPlaceholder() -> Text? {
        if #available(iOS 17.0, *) {
            Text(prompt)
                .foregroundStyle(props.placeholderColor)
                .font(props.font)
        } else {
            Text(prompt)
                .foregroundColor(props.placeholderColor)
                .font(props.font)
        }
    }
    
    @ViewBuilder
    private func getSecureIconView()-> some View {
        Button {
            self.isSecure.toggle()
        } label: {
                getOnlyIconLabel(icon: getSecureIcon())
                    .font(props.font)
                    .fgStyle(props.rightViewColor)
        }
    }
    private func getSecureIcon() -> Image {
        isSecure ? props.secureIcons.secured : props.secureIcons.unsecured
    }
}

@available(iOS 15.0, *)
extension SwiftyInput {
    private func onChangeText(_ value: String) {
        if props.limit > -1 {
            text = String(value.prefix(props.limit))
        }
        if !props.shouldFloat {
            prompt = value.isEmpty ? self.placeholder : ""
        }
        validate()
    }
    
    private func onFocus(_ value: Bool) {
        if value {
            showError = false
        } else {
            validate()
        }
    }
    
    private func validate() {
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
    @State private var text2 = ""
    @State private var text3 = ""
    
    init(text: String = "") {
//        ThemeFonts.SwiftyInput.font = Font.system(size: 30)
//        ThemeColors.primary = .green
        self.text = text
    }
    var body: some View {
        ScrollView {
            VStack {
                SwiftyInput(text: $text, props: SwiftyInputProps(showClearIcon: false, shouldFloat: true, style: .UNDERLINED, isMandatory: true))
                SwiftyInput(text: $text2, props: SwiftyInputProps(leftView: Image(systemName: "person")))
                SwiftyInput(text: $text3, props: SwiftyInputProps(leftView: Image(systemName: "person")))
                SwiftyInput(text: $text, props: SwiftyInputProps(leftView: Image(systemName: "person"), isSecure: true, shouldFloat: true))
                SwiftyInput(text: $text, props: SwiftyInputProps(leftView: Image(systemName: "person"), rightView: Image(systemName: "person"), isSecure: true, shouldFloat: true))
                SwiftyInput(text: $text, props: SwiftyInputProps(leftView: Image(systemName: "person"), rightView: Image(systemName: "person"), leftViewSpace: 20, shouldFloat: true, style: .UNDERLINED))
                SwiftyInput(text: $text, props: SwiftyInputProps(leftView: Image(systemName: "person"), rightView: Image(systemName: "person"), shouldFloat: true, style: .BORDERD, isMandatory: true))
                SwiftyInput(text: $text, props: SwiftyInputProps(leftView: Image(systemName: "person"), rightView: Image(systemName: "person"), style: .BORDERD))
                SwiftyInput(text: $text, props: SwiftyInputProps(isSecure: true, style: .BORDERD, isMandatory: true))
                SwiftyInput(text: $text, props: SwiftyInputProps(isSecure: true, shouldFloat: true,  style: .BORDERD))
                
            }
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
public struct SwiftyInputProps {
    public var leftView: Image?
    public var rightView: Image?
    public var leftViewSpace: CGFloat
    public var rightViewSpace: CGFloat
    public var leftViewColor: Color
    public var rightViewColor: Color
    public var clearIcon: Image
    public var showClearIcon: Bool
    public var secureIcons: SwiftyInputSecureIcons
    public var cursorColor: Color
    public var textColor: Color
    public var placeholderColor: Color
    public var clearIconColor: Color
    public var backgroundColor: Color
    public var borderProps: BorderProps?
    public var font: Font
    public var isSecure: Bool
    public var shouldFloat: Bool
    public var style: SwiftyInputStyle
    public var limit: Int
    public var regex: String
    public var errors: ErrorMsgs
    public var isMandatory: Bool
    
    public init(
        leftView: Image? = nil,
        rightView: Image? = nil,
        leftViewSpace: CGFloat = AppConfig.Inputs.leftViewSpace,
        rightViewSpace: CGFloat = AppConfig.Inputs.rightViewSpace,
        leftViewColor: Color = AppConfig.Inputs.leftIconColor,
        rightViewColor: Color = AppConfig.Inputs.rightIconColor,
        clearIcon: Image = AppConfig.Inputs.clearIcon,
        showClearIcon: Bool = true,
        secureIcons: SwiftyInputSecureIcons = AppConfig.Inputs.securedIcons,
        cursorColor: Color = AppConfig.Inputs.cursorColor,
        textColor: Color = AppConfig.Inputs.foregroundColor,
        placeholderColor: Color = AppConfig.Inputs.placeholderColor,
        clearIconColor: Color = AppConfig.Inputs.cursorColor,
        backgroundColor: Color = AppConfig.Inputs.backgroundColor,
        borderProps: BorderProps? = nil,
        font: Font  = AppConfig.Inputs.font,
        isSecure: Bool = false,
        shouldFloat: Bool = AppConfig.Inputs.shouldFloat,
        style: SwiftyInputStyle = AppConfig.Inputs.style,
        limit: Int = -1,
        regex: String = ".*",
        errors: ErrorMsgs = AppConfig.Inputs.errorMsgs,
        isMandatory: Bool = false
    ) {
        
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
        self.shouldFloat = shouldFloat
    }
}

public enum SwiftyInputStyle {
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

@available(iOS 13.0, *)
public struct SwiftyInputSecureIcons {
    public let secured: Image
    public let unsecured: Image
    
    public init(
        secured: Image = Image(systemName: "eye.fill"),
        unsecured: Image = Image(systemName: "eye.slash.fill")
    ) {
        self.secured = secured
        self.unsecured = unsecured
    }
}

@available(iOS 15.0, *)
fileprivate struct SwiftyInputLabelStyle: LabelStyle {
    fileprivate var props: SwiftyInputProps
    
    fileprivate init(props: SwiftyInputProps) {
        self.props = props
    }
    fileprivate func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 5) {
            configuration.title
                .font(props.font)
            if props.isMandatory {
                configuration.icon
                    .font(Font.system(size: 5))
            }
        }
    }
}
