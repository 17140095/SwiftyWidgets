//
//  PhoneSelector.swift
//
//
//  Created by Ali Raza on 29/05/2024.
//

import SwiftUI

@available(iOS 16.0, *)
public struct PhoneSelector: View, BaseProps {
    
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
    public var showFlag: Bool = AppConfig.Selectors.PhoneSelector.showFlag
    public var showDialCodeAfterArrow: Bool = AppConfig.Selectors.PhoneSelector.showDialCodeAfterArrow
    
    public var shouldDisabled: Bool = false
    
    var label: String = ""
    var prompt: String?
    var valueKey: String = ""
    var isValueFromMap: Bool = false
    
    
    public static var values: [String: PhoneSelectorValue] = [:]
    @State var phoneNo: String = ""
    @State private var selectedCountry: Country?
    @State private var presentSheet = false
    @State private var phoneWithoutCode: String =  ""
    @FocusState private var keyIsFocused: Bool
    
    public init(key: String = "PhoneNo", prompt: String? = nil ) {
        self.prompt = prompt
        self.valueKey = key
        if PhoneSelector.values[valueKey] == nil {
            PhoneSelector.values[valueKey] = PhoneSelectorValue()
        } else {
            self.isValueFromMap = true
        }
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
                    if showFlag {
                        Text(selectedCountry?.flag ?? "")
                    }
                    if !showDialCodeAfterArrow {
                        Text(selectedCountry?.dial_code ?? "")
                            .foregroundStyle(primaryColor)
                    }
                    arrowImage
                }
                .foregroundStyle(primaryColor)
                if showDialCodeAfterArrow {
                    Text(selectedCountry?.dial_code ?? "")
                        .foregroundStyle(primaryColor)
                }
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
                        saveSelection()
                    })
                    .foregroundColor(primaryColor)
                    .tint(primaryColor)
            }
            .font(font)
            .padding(padding, if: style == .BORDERD)
            .padding(.top, padding.top, if: style == .UNDERLINED)
            .padding(.bottom, padding.bottom, if: style == .UNDERLINED)
            .onTapGesture {
                keyIsFocused = true
                hideKeyboard()
            }
            .animation(.easeInOut(duration: 0.6), value: keyIsFocused)
            .sheet(isPresented: $presentSheet) {
                NavigationView {
                    List(Countries.allCountry) { country in
                        HStack {
                            if showFlag {
                                Text(country.flag)
                            }
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
                        .background(.white.opacity(0.0001))
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
            .disableWithOpacity(shouldDisabled)
            
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
        .onAppear {
            if isValueFromMap {
                self.phoneNo = PhoneSelector.values[valueKey]?.value ?? ""
                self.selectedCountry = PhoneSelector.values[valueKey]?.country
                let dialCodeCount = selectedCountry?.dial_code.count ?? 0
                self.phoneWithoutCode = phoneNo.dropFirst(dialCodeCount - 1).description
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
    
    private func saveSelection() {
        PhoneSelector.values[self.valueKey]?.value = phoneNo
        PhoneSelector.values[self.valueKey]?.country = selectedCountry
    }
    
}// PhoneSelector

@available(iOS 16.0, *)
extension PhoneSelector {
    //setter
    public func setshowFlag(_ show: Bool) -> Self {
        var copy = self
        copy.showFlag = show
        return copy
    }
    public func setshowDialCodeAfterArrow(_ show: Bool) -> Self {
        var copy = self
        copy.showDialCodeAfterArrow = show
        return self
    }
    public func shouldDisabled(_ disabled: Bool) -> Self {
        var copy = self
        copy.shouldDisabled = disabled
        return copy
    }
    public func setLabel(_ label: String) -> Self {
        var copy = self
        copy.label = label
        return copy
    }
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
    
    public func setStyle(_ style: SwiftyInputStyle) -> Self {
        var copy = self
        copy.style = style
        return copy
    }
}

@available(iOS 16.0, *)
public class PhoneSelectorValue {
    public var value: String = ""
    public var country: Country?
}

@available(iOS 16.0, *)
public enum PhoneSelectorDisplay {
    case NO_FLAG
    
}

#if DEBUG
@available(iOS 16.0, *)
struct TestPhoneSelector: View {
    @State var text: String = ""
    @State var showAlert: Bool = false
    init() {
        let selector = PhoneSelectorValue()
        selector.country = Countries.allCountry.last
        selector.value = "\(selector.country?.dial_code ?? "")34567890"
        PhoneSelector.values["PhoneNo"] = selector
    }
    var body: some View {
        VStack {
            PhoneSelector(key: "PhoneNo")
//                .setPrimaryColor(.red)
                .setPadding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
//                .shouldDisabled(true)
            CountrySelector(key: "Country")
            Spacer()
            SwiftyButton(title: "CheckValue") {
                print((PhoneSelector.values["PhoneNo"]?.value ?? "").onlyNumbers)
            }
        }
//        .padding()
    }
}

@available(iOS 16.0, *)
#Preview {
    TestPhoneSelector()
}
#endif



