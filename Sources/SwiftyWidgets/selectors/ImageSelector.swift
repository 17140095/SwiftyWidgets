//
//  ImageSelector.swift
//  
//
//  Created by Ali Raza on 24/05/2024.
//

import SwiftUI

@available(iOS 15.0.0, *)
public struct ImageSelector: View, BaseProps {
    public var primaryColor: Color = AppConfig.Selectors.ImageSelector.primaryColor
    public var secondaryColor: Color = AppConfig.Selectors.ImageSelector.secondaryColor
    public var border: BorderProps? = AppConfig.Selectors.ImageSelector.border
    public var shadow: ShadowProps? = AppConfig.Selectors.ImageSelector.shadow
    public var cornerRadius: CGFloat = AppConfig.Selectors.ImageSelector.cornerRadius
    public var padding: EdgeInsets = AppConfig.Selectors.ImageSelector.padding
    public var font: Font = AppConfig.Selectors.ImageSelector.font
    
    public var background: Color = AppConfig.Selectors.ImageSelector.background
    public var style: Axis.Set = AppConfig.Selectors.ImageSelector.style
    public var space: CGFloat = AppConfig.Selectors.ImageSelector.space
    
    let images: [Image]
    @Binding var select: Int
    
    public var body: some View {
        Group {
            if style == .horizontal {
                HStack(spacing: space) {
                    imagesView
                }
            } else {
                VStack(spacing: space) {
                    imagesView
                }
            }
        }
        .padding(padding)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .shadow(props: shadow)
    }
    
    private var imagesView: some View {
        ForEach(0..<images.count, id: \.self) { index in
                images[index]
                .border(props: border ?? BorderProps(), isFocus: true, isError: false, if: select == index)
                .onTapGesture {
                    withAnimation {
                        select = index
                    }
                }
            if space < 1 && index != images.count-1 {
                Spacer()
            }
        }
    }
}

@available(iOS 15.0.0, *)
extension ImageSelector {
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
    public func setBackground(_ color: Color) -> Self {
        var copy = self
        copy.background = color
        return copy
    }
    public func setStyle(_ style: Axis.Set) -> Self {
        var copy = self
        copy.style = style
        return copy
    }
    public func setSpace(_ space: CGFloat) -> Self {
        var copy = self
        copy.space = space
        return copy
    }
}


#if DEBUG
@available(iOS 15.0, *)
struct TestImageSelector: View {
    @State private var select = 0
    private var images = [
        Image(systemName: "arrow.left"),
        Image(systemName: "arrow.right"),
        Image(systemName: "arrow.up"),
        Image(systemName: "arrow.down")
    ]
    var body: some View {
        ImageSelector(images: images, select: $select)
//            .setStyle(.vertical)
//            .setBackground(.red)
//            .setPadding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
//            .setCornerRadius(20)
//            .setShadow(ShadowProps(color: .black, radius: 5, x: 5, y: 5))
        ImageSelector(images: images, select: $select)
//            .setStyle(.horizontal)
//            .setBackground(.red)
//            .setPadding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
//            .setCornerRadius(20)
//            .setShadow(ShadowProps(color: .black, radius: 5, x: 5, y: 5))
//            .setSpace(0)
    }
}

@available(iOS 15.0, *)
#Preview {
    TestImageSelector()
}

#endif
