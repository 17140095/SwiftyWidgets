//
//  SwiftyInput.swift
//
//  Created by Ali Raza on 21/01/2024.


import SwiftUI

public enum SwiftyInputStyle {
    case BORDERD, UNDERLINED
}

public protocol SwiftyInputProtocol {
    func onFocus(_ value: Bool)
    func onSubmit()
    func onChange(_ newValue: String)
}

@available(iOS 16.0, *)
public struct SwiftyInput: View, BaseProps {
    public var primaryColor: Color = AppConfig.Inputs.primaryColor
    public var secondaryColor: Color = AppConfig.Inputs.secondaryColor
    public var border: BorderProps? = AppConfig.Inputs.border
    public var shadow: ShadowProps? = AppConfig.Inputs.shadow
    public var cornerRadius: CGFloat = AppConfig.Inputs.cornerRadius
    public var padding: EdgeInsets = AppConfig.Inputs.padding
    public var font: Font = AppConfig.Inputs.font
    
    public var leftView: Image? = nil
    public var rightView: Image? = nil
    public var leftViewSpace: CGFloat = AppConfig.Inputs.leftViewSpace
    public var rightViewSpace: CGFloat = AppConfig.Inputs.rightViewSpace
    public var leftViewColor: Color = AppConfig.Inputs.leftIconColor
    public var rightViewColor: Color = AppConfig.Inputs.rightIconColor
    public var clearIcon: Image = AppConfig.Inputs.clearIcon
    public var showClearIcon: Bool = AppConfig.Inputs.showClearIcon
    public var secureIcons: FieldSecuredIcons = AppConfig.Inputs.securedIcons
    public var textColor: Color = AppConfig.Inputs.primaryColor
    public var placeholderColor: Color = AppConfig.Inputs.placeholderColor
    public var clearIconColor: Color = AppConfig.Inputs.primaryColor
    public var backgroundColor: Color = AppConfig.Inputs.backgroundColor
    public var shouldFloat: Bool = AppConfig.Inputs.shouldFloat
    public var style: SwiftyInputStyle = AppConfig.Inputs.style
    public var limit: Int = -1
    public var regex: String? = nil
    public var errors: ErrorMsgs = AppConfig.Inputs.errorMsgs
    public var isMandatory: Bool = false
    
    
    
    @State var prompt: String
    @Binding var text: String
    @State private var isSecure: Bool
    @State private var showError = false
    @FocusState private var isFocused: Bool
    @State var errorMsg: String = ""
    @State var leftViewSize: CGSize = .zero
    @State var promptSize: CGSize = .zero
    var delegate: SwiftyInputProtocol?
    var placeholder: String = ""
    var label: String = ""

    public init(label: String = "", prompt: String = "Placeholder", text: Binding<String>, delegate: SwiftyInputProtocol? = nil, isSecure: Bool = false) {
        self.label = label
        self.placeholder = prompt
        self._prompt = State<String>(initialValue: prompt)
        self._text = text
        self.delegate = delegate
        self._isSecure = State<Bool>(initialValue: isSecure)
        UITextField.appearance().tintColor = self.primaryColor.uiColor()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if label.isNotEmpty{
                Text(label)
                    .font(font)
                    .foregroundStyle(textColor)
            }
            HStack (alignment: .center, spacing: 0){
                if let leftView = leftView {
                    getOnlyIconLabel(icon: leftView)
                        .font(font)
                        .fgStyle(leftViewColor)
                        .padding(.trailing, leftViewSpace)
                        .overlay {
                            GeometryReader(content: { geometry in
                                Color.clear.onAppear {
                                    leftViewSize = geometry.size
                                }
                            })
                        }
                }
                
                getFieldView()
                
                HStack(spacing: rightViewSpace) {
                    if !self.text.trim.isEmpty && showClearIcon {
                        Button {
                            self.text = ""
                        } label: {
                            clearIcon
                                .tint(clearIconColor)
                                .font(font)
                        }
                    }
                    
                    if isSecure {
                        getSecureIconButton()
                    }
                    if let rightView = rightView {
                       getOnlyIconLabel(icon: rightView)
                            .font(font)
                            .fgStyle(rightViewColor)
                    }
                }
                
                
            }//HStack
            .padding(padding, if: style == .BORDERD)
            .padding(.vertical, padding.top)
            .padding(.top, getBorderFloatValue())
            .background(backgroundColor)
            .overlay(if: style == .BORDERD) {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(getBorderColor(), lineWidth: getBorderWidth())
            }
            
            if style != .BORDERD {
                withAnimation {
                    Rectangle()
                        .frame(height: isFocused ? border?.getFocusWidth() ?? 2.0 : border?.width ?? 1.0 )
                        .fgStyle(getBorderColor())
                }
                
            }
            //Error View/ Limit View
            if !isFocused && showError {
                HStack() {
                    Text(errorMsg)
                        .font(font)
                        .foregroundStyle(.red)
                        .padding(.vertical, 5)
                    Spacer()
                }
            }
            
        }
        .animation(.easeInOut, value: showError)
        .animation(.easeInOut, value: isFocused)
        .onTapGesture {
            isFocused = true
        }
        .onChangeFocus(of: isFocused, delegate: delegate, perform: self.onFocus(_:))
    }
  
    private func getBorderWidth() -> CGFloat {
        isFocused ? border?.getFocusWidth() ?? 2 : border?.width ?? 1
    }
    
    private func getFloatingValue() -> CGFloat {
        var floatHeight: CGFloat = promptSize.height
        if let leftView {
            floatHeight = leftViewSize.height + 3
        }
        return shouldFloat && (isFocused || !text.isEmpty) ? -floatHeight : 0
    }
    
    private func getScaleValue() -> CGFloat {
        
        return shouldFloat && (isFocused || !text.isEmpty) ? 0.8 : 1.0
    }
    
    private func getBorderFloatValue() -> CGFloat {
        var floatX: CGFloat = promptSize.height/2
        if let leftView {
            floatX = leftViewSize.width/2
        }
        return style == .BORDERD && shouldFloat && (isFocused || text.isNotEmpty) ? floatX : 0.0
    }
    
    private func getOffsetSize() -> CGSize {
        let width = (getFloatingValue() < 0.0 && leftViewSize.width > 0) ? -(leftViewSize.width + 5) : 0.0
        
        return CGSize(width: width, height: getFloatingValue())
    }
    
    private func getBorderColor() -> Color {
        return showError && !isFocused ? .red : border?.color ?? primaryColor
    }
    
    private func getBottomSpaceValue() -> CGFloat {
        style == .BORDERD ? 15 : 8
    }
    
    
    private func getPlaceholder() -> Text? {
        if #available(iOS 17.0, *) {
            Text(prompt)
                .foregroundStyle(placeholderColor)
                .font(font)
        } else {
            Text(prompt)
                .foregroundColor(placeholderColor)
                .font(font)
        }
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
        getField()
            .focused($isFocused)
            .onChangeInput(of: text, delegate: delegate, perform: self.onChangeText(_:))
            .fgStyle(textColor)
            .textFieldStyle(.plain)
            .overlay(alignment: .bottomLeading) {
                HStack {
                    Label {
                        GeometryReader { geometry in
                            Text(prompt)
                                .fgStyle(getFloatingValue() > 0.0 ? leftViewColor : placeholderColor)
                                .onAppear{
                                    promptSize = geometry.size
                                }
                        }
                    } icon: {
                        if !prompt.isEmpty {
                            Image(systemName: "circle.fill")
                                .fgStyle(.red)
                        }
                    }
                    .labelStyle(SwiftyInputLabelStyle(font: font, isMandatory: isMandatory))
                    .font(font)
                    .offset(getOffsetSize())
                    .scaleEffect(getScaleValue(), anchor: .leading)
                    Spacer()
                }
            }
    }
    
    @ViewBuilder
    private func getField() -> some View {
        if isSecure {
            SecureField("", text: $text, prompt: nil)
                .font(font)
        } else {
            TextField("", text: $text, prompt: nil)
                .font(font)
        }
    }
    @ViewBuilder
    private func getSecureIconButton()-> some View {
        Button {
            self.isSecure.toggle()
        } label: {
                getOnlyIconLabel(icon: getSecureIcon())
                    .font(font)
                    .fgStyle(rightViewColor)
        }
    }
    private func getSecureIcon() -> Image {
        isSecure ? secureIcons.secured : secureIcons.unsecured
    }
}

@available(iOS 16.0, *)
extension SwiftyInput {
    private func onChangeText(_ value: String) {
        if limit > -1 {
            text = String(value.prefix(limit))
        }
        if !shouldFloat {
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
        if isMandatory && text.isBlank {
            errorMsg = errors.mandatory
            showError = true
        } else if let regex, text.range(of: regex, options: .regularExpression) == nil {
            errorMsg = errors.regex
            showError = true
        } else {
            showError = false
        }
    }
    
}//SwiftyInput

@available(iOS 16.0, *)
extension SwiftyInput {
    public func setPrimaryColor(_ color: Color) -> SwiftyInput {
        var view = self
        view.primaryColor = color
        return view
    }
    public func setSecondaryColor(_ color: Color) -> SwiftyInput {
        var view = self
        view.secondaryColor = color
        return view
    }
    public func setBorder(_ border: BorderProps) -> SwiftyInput {
        var view = self
        view.border = border
        return view
    }
    public func setShadow(_ shadow: ShadowProps) -> SwiftyInput {
        var view = self
        view.shadow = shadow
        return view
    }
    public func setCornerRadius(_ radius: CGFloat) -> SwiftyInput {
        var view = self
        view.cornerRadius = radius
        return view
    }
    public func setPadding(_ padding: EdgeInsets) -> SwiftyInput {
        var view = self
        view.padding = padding
        return view
    }
    public func setFont(_ font: Font) -> SwiftyInput {
        var view = self
        view.font = font
        return view
    }
    public func setLeftView(_ icon: Image) -> SwiftyInput {
        var view = self
        view.leftView = icon
        return view
    }
    public func setRightView(_ icon: Image) -> SwiftyInput {
        var view = self
        view.rightView = icon
        return view
    }
    public func setLeftViewSpace(_ space: CGFloat) -> SwiftyInput {
        var view = self
        view.leftViewSpace = space
        return view
    }
    public func setRightViewSpace(_ space: CGFloat) -> SwiftyInput {
        var view = self
        view.rightViewSpace = space
        return view
    }
    public func setLeftViewColor(_ color: Color) -> SwiftyInput {
        var view = self
        view.leftViewColor = color
        return view
    }
    public func setRightViewColor(_ color: Color) -> SwiftyInput {
        var view = self
        view.rightViewColor = color
        return view
    }
    public func setClearIcon(_ icon: Image) -> SwiftyInput {
        var view = self
        view.clearIcon = icon
        return view
    }
    public func setShowClearIcon(_ show: Bool = true) -> SwiftyInput {
        var view = self
        view.showClearIcon = show
        return view
    }
    public func setSecureIcons(_ icons: FieldSecuredIcons) -> SwiftyInput {
        var view = self
        view.secureIcons = icons
        return view
    }
    public func setTextColor(_ color: Color) -> SwiftyInput {
        var view = self
        view.textColor = color
        return view
    }
    public func setPlaceholderColor(_ color: Color) -> SwiftyInput {
        var view = self
        view.placeholderColor = color
        return view
    }
    public func setClearIconColor(_ color: Color) -> SwiftyInput {
        var view = self
        view.clearIconColor = color
        return view
    }
    public func setBackgroundColor(_ color: Color) -> SwiftyInput {
        var view = self
        view.backgroundColor = color
        return view
    }
    
    public func setShouldFloat(_ shouldFloat: Bool = true) -> SwiftyInput {
        var view = self
        view.shouldFloat = shouldFloat
        return view
    }
    public func setStyle(_ style: SwiftyInputStyle) -> SwiftyInput {
        var view = self
        view.style = style
        return view
    }
    public func setLimit(_ limit: Int) -> SwiftyInput {
        var view = self
        view.limit = limit
        return view
    }
    public func setRegex(_ regex: String) -> SwiftyInput {
        var view = self
        view.regex = regex
        return view
    }
    public func setErrors(_ errors: ErrorMsgs) -> SwiftyInput {
        var view = self
        view.errors = errors
        return view
    }
    public func setIsMandatory(_ isMandatory: Bool = true) -> SwiftyInput {
        var view = self
        view.isMandatory = isMandatory
        return view
    }
    public func setDelegate(_ delegate: SwiftyInputProtocol) -> SwiftyInput {
        var view = self
        view.delegate = delegate
        return view
    }
}

#if DEBUG
@available(iOS 16.0, *)
struct TestContentView: View {
    @State private var text = ""
    @State private var text2 = ""
    @State private var text3 = ""
    
    init(text: String = "") {
        self.text = text
    }
    var body: some View {
        ScrollView {
            VStack {
                SwiftyInput(text: $text)
                    .setStyle(.BORDERD)
                    .setShouldFloat()
//                    .setLeftView(Image(systemName: "person"))
//                    .setFont(.largeTitle)
                SwiftyInput(text: $text2)
                SwiftyInput(text: $text3)
                    .setShouldFloat()
                
            }
        }
    }
}
@available(iOS 16.0, *)
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TestContentView()
            .padding()
    }
}

#endif


@available(iOS 16.0, *)
fileprivate struct SwiftyInputLabelStyle: LabelStyle {
    fileprivate var font: Font
    fileprivate var isMandatory: Bool
    fileprivate init(font: Font, isMandatory: Bool) {
        self.font = font
        self.isMandatory = isMandatory
    }
    fileprivate func makeBody(configuration: Configuration) -> some View {
        HStack(spacing: 5) {
            configuration.title
                .font(font)
            if isMandatory {
                configuration.icon
                    .font(Font.system(size: 5))
            }
        }
    }
}
