//
//  PhoneSelector.swift
//
//
//  Created by Ali Raza on 29/05/2024.
//

import SwiftUI

@available(iOS 15.0, *)
public struct PhoneSelector: View {
    public enum Cache {
        public static var country = Countries.allCountry.first
        public static var phoneNo = ""
    }
    
    public var primaryColor: Color = AppConfig.Selectors.PhoneSelector.primaryColor
    public var secondaryColor: Color = AppConfig.Selectors.PhoneSelector.secondaryColor
    public var border: BorderProps? = AppConfig.Selectors.PhoneSelector.border
    public var shadow: ShadowProps? = AppConfig.Selectors.PhoneSelector.shadow
    public var cornerRadius: CGFloat = AppConfig.Selectors.PhoneSelector.cornerRadius
    public var padding: EdgeInsets = AppConfig.Selectors.PhoneSelector.padding
    public var font: Font = AppConfig.Selectors.PhoneSelector.font
    
    public var style: SwiftyInputStyle = AppConfig.Selectors.PhoneSelector.style
    public var promptColor: Color = AppConfig.Selectors.PhoneSelector.promptColor
    public var textColor: Color = AppConfig.Selectors.PhoneSelector.textColor
    public var showBorder: Bool = AppConfig.Selectors.PhoneSelector.showBorder
    public var arrowImage: Image = AppConfig.Selectors.PhoneSelector.arrowImage
    public var checkImage: Image = AppConfig.Selectors.PhoneSelector.checkImage
    public var background: Color = AppConfig.Selectors.PhoneSelector.background
    
    var label: String
    var prompt: String?
    var shouldCache: Bool? = nil
    var readFromCache: Bool? = nil
    
    
    @Binding var phoneNo: String
    @State private var selectedCountry: Country?
    @State private var presentSheet = false
    @State private var phoneWithoutCode: String =  ""
    @FocusState private var keyIsFocused: Bool
    
    public init(label: String = "", prompt: String? = nil ,phoneNo: Binding<String>) {
        self.label = label
        self.prompt = prompt
        self._phoneNo = phoneNo
        self._selectedCountry = State(initialValue: Countries.allCountry.first)
        
    }
    public var body: some View {
        VStack (alignment: .leading){
            if label.trim.isNotEmpty {
                Text(label)
                    .font(font)
                    .foregroundStyle(primaryColor)
            }
            HStack() {
                Button {
                    presentSheet = true
                    keyIsFocused = false
                } label: {
                    Text(selectedCountry?.flag ?? "")
                    arrowImage
                }
                .foregroundStyle(primaryColor)
                Text(selectedCountry?.dial_code ?? "")
                    .foregroundStyle(primaryColor)
                TextField("", text: $phoneWithoutCode)
                    .placeholder(when: phoneWithoutCode.isEmpty) {
                        Text(getPlaceholder())
                            .foregroundColor(promptColor)
                    }
                    .focused($keyIsFocused)
                    .keyboardType(.numberPad)
                    .onChange(of: phoneWithoutCode, perform: { newVal in
                        phoneWithoutCode = String(newVal.prefix(selectedCountry?.pattern.count ?? Int.max))
                        phoneWithoutCode = phoneWithoutCode.formatNumberOn(mask: selectedCountry?.pattern ?? "")
                        phoneNo = (selectedCountry?.dial_code ?? "").appending(phoneWithoutCode)
                        cacheSelection()
                    })
                    .foregroundColor(primaryColor)
                    .tint(primaryColor)
            }
            .font(font)
            .padding(padding, if: style == .BORDERD)
            .padding(.top, padding.top, if: style == .UNDERLINED)
            .padding(.bottom, padding.bottom, if: style == .UNDERLINED)
            .onTapGesture {
                hideKeyboard()
            }
            .animation(.easeInOut(duration: 0.6), value: keyIsFocused)
            .sheet(isPresented: $presentSheet) {
                NavigationView {
                    List(Countries.allCountry) { country in
                        HStack {
                            Text(country.flag)
                            Text(country.name)
                                .foregroundStyle(textColor)
                            if country == selectedCountry {
                                checkImage
                                    .foregroundStyle(primaryColor)
                            }
                            Spacer()
                            Text(country.dial_code)
                                .foregroundStyle(textColor)
                        }
                        .onTapGesture {
                            selectedCountry = country
                            presentSheet = false
                        }
                    }
                    .listStyle(.plain)
                    .font(font)
                }
                .padding(.vertical, 20)
            }
            .disableWithOpacity(readFromCache ?? false)
            
            if style == .UNDERLINED {
                Rectangle()
                    .fill(primaryColor)
                    .frame(height: keyIsFocused ? 2 : 1)
            }
        }
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius), if: style == .BORDERD)
        .overlay(if: showBorder && style == .BORDERD) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(border?.color ?? .clear, lineWidth: border?.width ?? 0)
        }
        .onAppear{
            if readFromCache ?? false {
                readCache()
            }
        }
    }
    
    private func getPlaceholder()-> String {
        if let prompt {
            return prompt
        } else {
            return selectedCountry?.pattern.replacingOccurrences(of: "#", with: "0") ?? ""
        }
    }
    
    private func cacheSelection() {
        if shouldCache ?? false {
            Cache.country = selectedCountry
            Cache.phoneNo = phoneWithoutCode
        }
    }
    
    private func readCache() {
        if readFromCache ?? false {
            selectedCountry = Cache.country
            phoneWithoutCode = Cache.phoneNo
        }
    }
    
}// PhoneSelector

@available(iOS 15.0, *)
extension PhoneSelector {
    //setter
    public func setPrimaryColor(_ color: Color) -> Self {
        var copy = self
        copy.primaryColor = color
        return copy
    }
    public func setSecondaryColor(_ color: Color) -> Self {
        var copy = self
        copy.secondaryColor = color
        return copy
    }
    public func setBorder(_ border: BorderProps) -> Self {
        var copy = self
        copy.border = border
        return copy
    }
    public func setShadow(_ shadow: ShadowProps) -> Self {
        var copy = self
        copy.shadow = shadow
        return copy
    }
    public func setCornerRadius(_ radius: CGFloat) -> Self {
        var copy = self
        copy.cornerRadius = radius
        return copy
    }
    public func setPadding(_ padding: EdgeInsets) -> Self {
        var copy = self
        copy.padding = padding
        return copy
    }
    public func setFont(_ font: Font) -> Self {
        var copy = self
        copy.font = font
        return copy
    }
    public func setPromptColor(_ color: Color) -> Self {
        var copy = self
        copy.promptColor = color
        return copy
    }
    public func setTextColor(_ color: Color) -> Self {
        var copy = self
        copy.textColor = color
        return copy
    }
    public func setShowBorder(_ show: Bool) -> Self {
        var copy = self
        copy.showBorder = show
        return copy
    }
    public func setArrowImage(_ image: Image) -> Self {
        var copy = self
        copy.arrowImage = image
        return copy
    }
    public func setCheckImage(_ image: Image) -> Self {
        var copy = self
        copy.checkImage = image
        return copy
    }
    public func setBackground(_ color: Color) -> Self {
        var copy = self
        copy.background = color
        return copy
    }
    public func setShouldCache(_ shouldCache: Bool = true) -> Self {
        var copy = self
        copy.shouldCache = shouldCache
        return copy
    }
    public func setReadFromCache(_ readFromCache: Bool = true) -> Self {
        var copy = self
        copy.readFromCache = readFromCache
        return copy
    }
    public func setStyle(_ style: SwiftyInputStyle) -> Self {
        var copy = self
        copy.style = style
        return copy
    }
}


#if DEBUG
@available(iOS 15.0, *)
struct TestPhoneSelector: View {
    @State var text: String = ""
    @State var showAlert: Bool = false
    var body: some View {
        VStack {
            PhoneSelector(label: "",phoneNo: $text)
//                .setPrimaryColor(.red)
                .setPadding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            CountrySelector(select: $text)
            Spacer()
        }
//        .padding()
    }
}

@available(iOS 15.0, *)
#Preview {
    TestPhoneSelector()
}
#endif



