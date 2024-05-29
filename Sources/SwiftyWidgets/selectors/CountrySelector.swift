//
//  CountrySelector.swift
//  
//
//  Created by Ali Raza on 24/05/2024.
//

import SwiftUI

@available(iOS 15.0, *)
public struct CountrySelector: View {
    var label: String = ""
    var prompt: String = "Select Country"
    @Binding var select: String
    var props = CountrySelectorProps()
    
    @State private var presentSheet = false
    @State private var selectedCountry = Countries.allCountry.first
    @FocusState private var keyIsFocused: Bool
    
    public init(label: String = "", select: Binding<String>, props: CountrySelectorProps = CountrySelectorProps()) {
        self.label = label
        self._select = select
        self.props = props
        self.presentSheet = presentSheet
        self.selectedCountry = selectedCountry
        self.keyIsFocused = keyIsFocused
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            if label.trim.isNotEmpty {
                Text(label)
                    .font(props.font)
                    .foregroundStyle(props.textColor)
            }
            HStack {
                if props.showFlag {
                    Text(getFlagAndCode())
                        .font(props.font)
                        .frame(minWidth: 20)
                    
                }
                if props.showPrompt && selectedCountry == nil {
                    if props.titleAlign == .center || props.titleAlign == .trailing {
                        Spacer()
                    }
                    Text(prompt)
                        .font(props.font)
                        .foregroundStyle(props.promptColor)
                    
                    if props.titleAlign == .center || props.titleAlign == .leading {
                        Spacer()
                    }
                } else if props.showTitle {
                    if props.titleAlign == .center || props.titleAlign == .trailing {
                        Spacer()
                    }
                    Text(selectedCountry?.name ?? "")
                        .font(props.font)
                        .foregroundStyle(props.textColor)
                    
                    if props.titleAlign == .center || props.titleAlign == .leading {
                        Spacer()
                    }
                }
                props.arrowImage
            }
            .padding()
            .frame(minWidth: 100)
            .background(props.background)
            .clipShape(RoundedRectangle(cornerRadius: props.cornerRadius))
            .overlay(if: props.showBorder) {
                RoundedRectangle(cornerRadius: props.cornerRadius)
                    .stroke(props.border, lineWidth: props.borderWidth)
            }
            .onTapGesture {
                presentSheet = true
                keyIsFocused = false
            }
            .animation(.easeInOut(duration: 0.6), value: keyIsFocused)
            .sheet(isPresented: $presentSheet) {
                NavigationView {
                    List(Countries.allCountry) { country in
                        HStack {
                            Text(country.flag + "  \(country.code)")
                                .font(props.font)
                            if country == selectedCountry {
                                props.checkImage
                                    .font(props.font)
                            }
                            Spacer()
                            Text(country.name)
                                .font(props.font)
                                .foregroundStyle(props.textColor)
                        }
                        .onTapGesture {
                            selectedCountry = country
                            select = selectedCountry?.name ?? ""
                            presentSheet = false
                        }
                    }
                    .listStyle(.plain)
                }
                .padding(.vertical, 20)
        }
        }
        
    }
    
    private func getFlagAndCode() -> String {
        let code = props.showCode ? "  \(selectedCountry?.code ?? "")" : ""
        return "\(selectedCountry?.flag ?? "")\(code)"
    }
}

@available(iOS 15.0.0, *)
public struct CountrySelectorProps {
    public var font: Font
    public var textColor: Color
    public var promptColor: Color
    public var background: Color
    public var cornerRadius: CGFloat
    public var showTitle: Bool
    public var showFlag: Bool
    public var showCode: Bool
    public var showPrompt: Bool
    public var showBorder: Bool
    public var border: Color
    public var borderWidth: CGFloat
    public var titleAlign: Alignment
    public var arrowImage: Image
    public var checkImage: Image
    
    public init(
        font: Font = AppConfig.Selectors.CountrySelector.font,
        textColor: Color = AppConfig.Selectors.CountrySelector.textColor,
        promptColor: Color = AppConfig.Selectors.CountrySelector.promptColor,
        background: Color = AppConfig.Selectors.CountrySelector.background,
        cornerRadius: CGFloat = AppConfig.Selectors.CountrySelector.cornerRadius,
        showTitle: Bool = AppConfig.Selectors.CountrySelector.showTitle,
        showFlag: Bool = AppConfig.Selectors.CountrySelector.showFlag,
        showCode: Bool = AppConfig.Selectors.CountrySelector.showCode,
        showPrompt: Bool = AppConfig.Selectors.CountrySelector.showPrompt,
        showBorder: Bool = AppConfig.Selectors.CountrySelector.showBorder,
        borderWidth: CGFloat = AppConfig.Selectors.CountrySelector.borderWidth,
        border: Color = AppConfig.Selectors.CountrySelector.border,
        titleAlign: Alignment = AppConfig.Selectors.CountrySelector.titleAlign,
        arrowImage: Image = AppConfig.Selectors.CountrySelector.arrowImage,
        checkImage: Image = AppConfig.Selectors.CountrySelector.checkImage
    ) {
        self.font = font
        self.textColor = textColor
        self.promptColor = promptColor
        self.background = background
        self.cornerRadius = cornerRadius
        self.showTitle = showTitle
        self.showFlag = showFlag
        self.showCode = showCode
        self.showPrompt = showPrompt
        self.titleAlign = titleAlign
        self.arrowImage = arrowImage
        self.checkImage = checkImage
        self.showBorder = showBorder
        self.border = border
        self.borderWidth = borderWidth
    }
    
}


#if DEBUG
@available(iOS 15.0, *)
struct TestCounntrySelector: View {
    @State var text: String = ""
    var body: some View {
        VStack {
            Spacer()
            CountrySelector(label: "",select: $text)
            Spacer()
        }
        .background(AppConfig.backgroundColor)
    }
}

@available(iOS 15.0, *)
#Preview {
    TestCounntrySelector()
}
#endif
