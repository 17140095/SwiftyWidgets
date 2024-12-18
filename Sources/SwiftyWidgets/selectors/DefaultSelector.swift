//
//  InputSelector.swift
//
//
//  Created by Ali Raza on 24/05/2024.
//

import SwiftUI

@available(iOS 16.0, *)
public struct DefaultSelector: View, BaseProps {
    public var primaryColor: Color = AppConfig.Selectors.InputSelector.primaryColor
    public var secondaryColor: Color = AppConfig.Selectors.InputSelector.secondaryColor
    public var border: BorderProps? = AppConfig.Selectors.InputSelector.border
    public var shadow: ShadowProps? = AppConfig.Selectors.InputSelector.shadow
    public var cornerRadius: CGFloat = AppConfig.Selectors.InputSelector.cornerRadius
    public var padding: EdgeInsets = AppConfig.Selectors.InputSelector.padding
    public var font: Font = AppConfig.Selectors.InputSelector.font
    
    public var background = AppConfig.Selectors.InputSelector.background
    public var textColor = AppConfig.Selectors.InputSelector.textColor
    public var style = AppConfig.Selectors.InputSelector.style
    public var arrowImage = AppConfig.Selectors.InputSelector.arrowImage
    public var checkImage = AppConfig.Selectors.InputSelector.checkImage
    
    var items: [String]
    @Binding var select: String
    @State private var presentSheet = false
    
    var preFix: String?
    var title: String = ""
    
    public init(items: [String], select: Binding<String>) {
        self.items = items
        self._select = select
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if title.trim.isNotEmpty {
                Text(title)
                    .bold()
                    .font(font)
                    .foregroundStyle(secondaryColor)
                    .padding(.bottom)
            }
            VStack (spacing: 0){
                HStack {
                    if let preFix {
                        Text(preFix)
                        Spacer()
                    }
                    Text(select)
                    arrowImage
                }
                .foregroundStyle(primaryColor)
                .font(font)
                .padding(padding, if: style == .BORDERD)
                .padding(.top, padding.top, if: style == .UNDERLINED)
                .padding(.bottom, padding.bottom, if: style == .UNDERLINED)
                
                .onTapGesture {
                    presentSheet = true
                }
                .sheet(isPresented: $presentSheet) {
                    NavigationView {
                        List {
                            ForEach(items, id: \.self) { item in
                                HStack {
                                    Text(item)
                                        .font(font)
                                    if select == item {
                                        checkImage
                                            .foregroundStyle(primaryColor)
                                    }
                                    Spacer()
                                }
                                .onTapGesture {
                                    select = item
                                    presentSheet = false
                                }
                            }
                        }
                        .listStyle(.plain)
                    }
                    .padding(.vertical, 20)
                }
                if style == .UNDERLINED {
                    Rectangle()
                        .foregroundStyle(primaryColor)
                        .frame(height: 2)
                }
            }
            .background(background)
            .cornerRadius(cornerRadius)
        }
        
    }
}

@available(iOS 16.0, *)
extension DefaultSelector {
    public func setPrimaryColor(_ color: Color) -> Self {
        var view = self
        view.primaryColor = color
        return view
    }
    
    public func setSecondaryColor(_ color: Color) -> Self {
        var view = self
        view.secondaryColor = color
        return view
    }
    
    public func setBorder(_ border: BorderProps) -> Self {
        var view = self
        view.border = border
        return view
    }
    
    public func setShadow(_ shadow: ShadowProps) -> Self {
        var view = self
        view.shadow = shadow
        return view
    }
    
    public func setCornerRadius(_ radius: CGFloat) -> Self {
        var view = self
        view.cornerRadius = radius
        return view
    }
    
    public func setPadding(_ padding: EdgeInsets) -> Self {
        var view = self
        view.padding = padding
        return view
    }
    
    public func setFont(_ font: Font) -> Self {
        var view = self
        view.font = font
        return view
    }
    public func setStyle(_ style: SwiftyInputStyle) -> Self {
        var view = self
        view.style = style
        return view
    }
    
    public func setPrefix(_ preFix: String) -> Self {
        var view = self
        view.preFix = preFix
        return view
    }
    public func settTitle(_ title: String) -> Self {
        var view = self
        view.title = title
        return view
    }
    public func setBackground(_ color: Color) -> Self {
        var view = self
        view.background = color
        return view
    }
    public func setTextColor(_ textColor: Color) -> Self {
        var view = self
        view.textColor = textColor
        return view
    }
    public func setFieldArrowImage(_ arrowImg: Image) -> Self {
        var view = self
        view.arrowImage = arrowImg
        return view
    }
    public func setCheckImage(_ checkImage: Image) -> Self {
        var view = self
        view.checkImage = checkImage
        return view
    }
}




#if DEBUG

@available(iOS 16.0, *)
struct SelectorTestView: View {
    @State private var selectedGenderIndex = 0
    @State private var select: String = "Please select Gender"
    
    let genderOptions = ["Male", "Female"]
    
    var body: some View {
        VStack {
            DefaultSelector(items: genderOptions, select: $select)
                .setPrefix("Gender")
                .settTitle("Gender Title")
                .setBorder(BorderProps())
//                .setStyle(.UNDERLINED)
//                .setBackground(.clear)
            Spacer()
        }
        .padding()
        .background(.cyan)
        
    }
}


@available(iOS 16.0, *)
#Preview {
    SelectorTestView()
}

#endif
