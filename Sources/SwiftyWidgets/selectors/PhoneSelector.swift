//
//  PhoneSelector.swift
//
//
//  Created by Ali Raza on 29/05/2024.
//

import SwiftUI

@available(iOS 15.0, *)
public struct PhoneSelector: View {
    var label: String = ""
    var prompt: String? = nil
    var shouldCache: Bool? = nil
    var readFromCache: Bool? = nil
    
    var props: PhoneSelectorProps
    
    @Binding var phoneNo: String
    @State private var selectedCountry: Country?
    @State private var presentSheet = false
    @State private var phoneWithoutCode: String =  ""
    @FocusState private var keyIsFocused: Bool
    
    public init(label: String = "", prompt: String? = nil, readFromCache: Bool? = nil, shouldCache: Bool? = nil ,phoneNo: Binding<String>, props: PhoneSelectorProps = PhoneSelectorProps()) {
        
        self.shouldCache = shouldCache
        self.readFromCache = readFromCache
        self.label = label
        self.prompt = prompt
        self.props = props
        self._phoneNo = phoneNo
        self._selectedCountry = State(initialValue: Countries.allCountry.first)
        
    }
    public var body: some View {
        VStack (alignment: .leading){
            if label.trim.isNotEmpty {
                Text(label)
                    .font(props.font)
                    .foregroundStyle(props.foreground)
            }
            HStack() {
                Button {
                    presentSheet = true
                    keyIsFocused = false
                } label: {
                    Text(selectedCountry?.flag ?? "")
                    props.arrowImage
                }
                .font(props.font)
                .foregroundStyle(props.foreground)
                Text(selectedCountry?.dial_code ?? "")
                    .font(AppConfig.Selectors.PhoneSelector.font)
                TextField("", text: $phoneWithoutCode)
                    .placeholder(when: phoneWithoutCode.isEmpty) {
                        Text(getPlaceholder())
                            .foregroundColor(props.promptColor)
                    }
                    .focused($keyIsFocused)
                    .keyboardType(.numberPad)
                    .onChange(of: phoneWithoutCode, perform: { newVal in
                        phoneWithoutCode = String(newVal.prefix(selectedCountry?.pattern.count ?? Int.max))
                        phoneWithoutCode = phoneWithoutCode.formatNumberOn(mask: selectedCountry?.pattern ?? "")
                        phoneNo = (selectedCountry?.dial_code ?? "").appending(phoneWithoutCode)
                        cacheSelection()
                    })
                    .font(AppConfig.Selectors.PhoneSelector.font)
                    .foregroundColor(props.foreground)
                    .tint(props.foreground)
            }
            .padding()
            .background(props.background)
            .clipShape(RoundedRectangle(cornerRadius: props.cornerRadius))
            .animation(.easeInOut(duration: 0.6), value: keyIsFocused)
            .overlay(if: props.showBorder) {
                RoundedRectangle(cornerRadius: props.cornerRadius)
                    .stroke(props.border, lineWidth: props.borderWidth)
            }
            .onTapGesture {
                hideKeyboard()
            }
            .sheet(isPresented: $presentSheet) {
                NavigationView {
                    List(Countries.allCountry) { country in
                        HStack {
                            Text(country.flag)
                            Text(country.name)
                                .font(props.font)
                                .foregroundStyle(props.textColor)
                            if country == selectedCountry {
                                props.checkImage
                                    .font(props.font)
                            }
                            Spacer()
                            Text(country.dial_code)
                                .font(props.font)
                                .foregroundStyle(props.foreground)
                        }
                        .onTapGesture {
                            selectedCountry = country
                            presentSheet = false
                        }
                    }
                    .listStyle(.plain)
                }
                .padding(.vertical, 20)
            }
            .disableWithOpacity(readFromCache ?? false)
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
            return selectedCountry?.pattern.replacingOccurrences(of: "#", with: "0") ?? "123456789"
        }
    }
    
    private func cacheSelection() {
        if shouldCache ?? false {
            AppConfig.Cache.PhoneSelector.country = selectedCountry
            AppConfig.Cache.PhoneSelector.phoneNo = phoneWithoutCode
        }
    }
    
    private func readCache() {
        if readFromCache ?? false {
            selectedCountry = AppConfig.Cache.PhoneSelector.country
            phoneWithoutCode = AppConfig.Cache.PhoneSelector.phoneNo
        }
    }
    
}// PhoneSelector


@available(iOS 15.0, *)
public struct PhoneSelectorProps {
    public var font: Font
    public var foreground: Color
    public var background: Color
    public var promptColor: Color
    public var textColor: Color
    public var cornerRadius = 10.0
    public var showBorder: Bool
    public var border: Color
    public var borderWidth: CGFloat
    public var arrowImage: Image
    public var checkImage: Image
    
    public init(
        font: Font = AppConfig.Selectors.PhoneSelector.font,
        foreground: Color = AppConfig.Selectors.PhoneSelector.foreground,
        background: Color = AppConfig.Selectors.PhoneSelector.background,
        promptColor: Color = AppConfig.Selectors.PhoneSelector.promptColor,
        textColor: Color = AppConfig.Selectors.PhoneSelector.textColor,
        cornerRadius: Double = AppConfig.Selectors.PhoneSelector.cornerRadius,
        showBorder: Bool = AppConfig.Selectors.PhoneSelector.showBorder,
        border: Color = AppConfig.Selectors.PhoneSelector.border,
        borderWidth: CGFloat = AppConfig.Selectors.PhoneSelector.borderWidth,
        arrowImage: Image = AppConfig.Selectors.PhoneSelector.arrowImage, 
        checkImage: Image = AppConfig.Selectors.PhoneSelector.checkImage
    ) {
        self.font = font
        self.foreground = foreground
        self.background = background
        self.promptColor = promptColor
        self.textColor = textColor
        self.cornerRadius = cornerRadius
        self.showBorder = showBorder
        self.border = border
        self.borderWidth = borderWidth
        self.arrowImage = arrowImage
        self.checkImage = checkImage
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
                .padding(.top, 50)
            CountrySelector(select: $text)
            Spacer()
        }
    }
}

@available(iOS 15.0, *)
#Preview {
    TestPhoneSelector()
}
#endif



