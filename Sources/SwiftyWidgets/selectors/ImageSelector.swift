//
//  SwiftUIView.swift
//  
//
//  Created by Ali Raza on 24/05/2024.
//

import SwiftUI

@available(iOS 15.0.0, *)
public struct ImageSelector: View {
    let images: [Image]
    @Binding var select: Int
    var props: ImageSelectorProps = ImageSelectorProps()
    public var body: some View {
        if props.style == .HORIZONTAL {
            HStack(spacing: props.customSpace) {
                imagesView
            }
        } else {
            VStack(spacing: props.customSpace) {
                imagesView
            }
        }
    }
    
    private var imagesView: some View {
        ForEach(0..<images.count, id: \.self) { index in
                images[index]
                .border(props.selectionColor, width: props.selectionWidth, if: select == index)
                .onTapGesture {
                    withAnimation {
                        select = index
                    }
                }
            if props.customSpace < 1 && index != images.count-1 {
                Spacer()
            }
        }
    }
}

@available(iOS 15.0.0, *)
public struct ImageSelectorProps {
    public var selectionColor = AppConfig.primaryColor
    public var selectionWidth: CGFloat = 3
    public var style: Orientation = .HORIZONTAL
    public var customSpace: CGFloat = 0
    
    public init(selectionColor: Color = AppConfig.primaryColor, selectionWidth: CGFloat = 3, style: Orientation = .HORIZONTAL, customSpace: CGFloat = 0) {
        self.selectionColor = selectionColor
        self.selectionWidth = selectionWidth
        self.style = style
        self.customSpace = customSpace
    }
}

@available(iOS 15.0.0, *)
public enum Orientation {
    case VERTICAL, HORIZONTAL
}


#if DEBUG
@available(iOS 15.0, *)
struct TestImageSelector: View {
    @State private var select = 0
    var body: some View {
        ImageSelector(images: [
            Image(systemName: "arrow.left"),
            Image(systemName: "arrow.right"),
            Image(systemName: "arrow.up"),
            Image(systemName: "arrow.down")
        ], select: $select, props: ImageSelectorProps(selectionWidth: 3, style: .HORIZONTAL, customSpace: 20))
    }
}

@available(iOS 15.0, *)
#Preview {
    TestImageSelector()
}

#endif
