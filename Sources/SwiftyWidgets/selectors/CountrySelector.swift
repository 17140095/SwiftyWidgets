//
//  CountrySelector.swift
//
//
//  Created by Ali Raza on 24/05/2024.
//

import SwiftUI

@available(iOS 15.0, *)
public struct CountrySelector: View {
    
    public var primaryColor: Color = AppConfig.Selectors.CountrySelector.primaryColor
    public var secondaryColor: Color = AppConfig.secondaryColor
    public var border: BorderProps? = AppConfig.Buttons.borderProps
    public var shadow: ShadowProps? = nil
    public var cornerRadius: CGFloat = AppConfig.Buttons.radius
    public var padding: EdgeInsets = AppConfig.Buttons.padding
    public var font: Font = AppConfig.Buttons.font
    
    public var textColor: Color = AppConfig.Selectors.CountrySelector.textColor
    public var promptColor: Color = AppConfig.Selectors.CountrySelector.promptColor
    public var background: Color = AppConfig.Selectors.CountrySelector.background
    public var showTitle: Bool = AppConfig.Selectors.CountrySelector.showTitle
    public var showFlag: Bool = AppConfig.Selectors.CountrySelector.showFlag
    public var showCode: Bool = AppConfig.Selectors.CountrySelector.showCode
    public var showPrompt: Bool = AppConfig.Selectors.CountrySelector.showPrompt
    public var showBorder: Bool = AppConfig.Selectors.CountrySelector.showBorder
    public var titleAlign: Alignment = AppConfig.Selectors.CountrySelector.titleAlign
    public var arrowImage: Image = AppConfig.Selectors.CountrySelector.arrowImage
    public var checkImage: Image = AppConfig.Selectors.CountrySelector.checkImage
    public var style: SwiftyInputStyle = AppConfig.Selectors.CountrySelector.style
    
    var label: String = ""
    var prompt: String = "Select Country"
    @Binding var select: String
    
    @State private var presentSheet = false
    @State private var selectedCountry = Countries.allCountry.first
    @FocusState private var keyIsFocused: Bool
    
    public init(label: String = "", select: Binding<String>) {
        self.label = label
        self._select = select
        self.presentSheet = presentSheet
        self.selectedCountry = selectedCountry
        self.keyIsFocused = keyIsFocused
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if label.trim.isNotEmpty {
                Text(label)
                    .foregroundStyle(primaryColor)
                    .padding(.bottom, 8)
            }
            HStack {
                if showFlag {
                    Text(getFlagAndCode())
                        .frame(minWidth: 20)
                    
                }
                if showPrompt && selectedCountry == nil {
                    if titleAlign == .center || titleAlign == .trailing {
                        Spacer()
                    }
                    Text(prompt)
                        .foregroundStyle(promptColor)
                    
                    if titleAlign == .center || titleAlign == .leading {
                        Spacer()
                    }
                } else if showTitle {
                    if titleAlign == .center || titleAlign == .trailing {
                        Spacer()
                    }
                    Text(selectedCountry?.name ?? "")
                        .foregroundStyle(primaryColor)
                    
                    if titleAlign == .center || titleAlign == .leading {
                        Spacer()
                    }
                }
                arrowImage
                    .foregroundStyle(primaryColor)
            }
            .padding(padding, if: style == .BORDERD)
            .padding(.top, padding.top, if: style == .UNDERLINED)
            .padding(.bottom, padding.bottom, if: style == .UNDERLINED)
            .frame(minWidth: 100)
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
                                .font(font)
                            if country == selectedCountry {
                                checkImage
                                    .foregroundStyle(primaryColor)
                            }
                            Spacer()
                            Text(country.name)
                                .foregroundStyle(textColor)
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
            
            if style == .UNDERLINED {
                Rectangle()
                    .fill(primaryColor)
                    .frame(height: keyIsFocused ? 2 : 1)
            }
        }
        .background(background)
        .font(font)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius), if: style == .BORDERD)
        .overlay(if: showBorder && style == .BORDERD) {
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(border?.color ?? .clear, lineWidth: border?.width ?? 0)
        }
        
    }
    
    private func getFlagAndCode() -> String {
        let code = showCode ? "  \(selectedCountry?.code ?? "")" : ""
        return "\(selectedCountry?.flag ?? "")\(code)"
    }
    
}



@available(iOS 15.0, *)
extension CountrySelector {
    
    public func setPrimaryColor(_ color: Color) -> CountrySelector {
        var view = self
        view.primaryColor = color
        return view
    }
    
    public func setSecondaryColor(_ color: Color) -> CountrySelector {
        var view = self
        view.secondaryColor = color
        return view
    }
    
    public func setBorder(_ border: BorderProps) -> CountrySelector {
        var view = self
        view.border = border
        return view
    }
    
    public func setShadow(_ shadow: ShadowProps) -> CountrySelector {
        var view = self
        view.shadow = shadow
        return view
    }
    
    public func setCornerRadius(_ radius: CGFloat) -> CountrySelector {
        var view = self
        view.cornerRadius = radius
        return view
    }
    
    public func setPadding(_ padding: EdgeInsets) -> CountrySelector {
        var view = self
        view.padding = padding
        return view
    }
    
    public func setFont(_ font: Font) -> CountrySelector {
        var view = self
        view.font = font
        return view
    }
    public func setStyle(_ style: SwiftyInputStyle) -> CountrySelector {
        var view = self
        view.style = style
        return view
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
