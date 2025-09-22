//
//  AdaptiveStack.swift
//  example
//
//  Created by rb on 2025-08-13.
//

import SwiftUI

/// A container that switches between VStack/HStack depending on device idiom.
struct AdaptiveStack<Content: View>: View {
    
    public enum AxisLayout {
        case vertical, horizontal
    }
    
    private let phoneLayout: AxisLayout
    private let tabletLayout: AxisLayout
    private let alignment: Alignment?
    private let spacing: CGFloat?
    private let content: () -> Content

    /// - Parameters:
    ///   - phone:   which axis to use on .phone
    ///   - tablet:  which axis to use on .pad
    ///   - alignment: how to align the stack’s children (maps to HStack/VStack alignments)
    ///   - spacing:   spacing between items
    ///   - content:   child views
    public init(phone: AxisLayout, tablet: AxisLayout, alignment: Alignment = .center, spacing: CGFloat? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.phoneLayout = phone
        self.tabletLayout = tablet
        self.alignment = alignment
        self.spacing = spacing
        self.content = content
    }

    @ViewBuilder
    public var body: some View {

        let layout = DeviceType.isTablet ? tabletLayout : phoneLayout

        switch layout {
        case .horizontal:
            HStack(
                alignment: verticalAlignment(from: alignment ?? .center),
                spacing: spacing
            ) {
                content()
            }
        case .vertical:
            VStack(
                alignment: horizontalAlignment(from: alignment ?? .center),
                spacing: spacing
            ) {
                content()
            }
        }
    }

    private func horizontalAlignment(from a: Alignment) -> HorizontalAlignment {
        switch a {
        case .leading:  return .leading
        case .trailing: return .trailing
        default:         return .center
        }
    }

    private func verticalAlignment(from a: Alignment) -> VerticalAlignment {
        switch a {
        case .top:    return .top
        case .bottom: return .bottom
        default:      return .center
        }
    }
}

@MainActor
public enum DeviceType {
    static let isTablet = UIDevice.current.userInterfaceIdiom == .pad
}

@MainActor
public enum ScreenSize {
    static let screenWidth         = UIScreen.main.bounds.size.width
    static let screenHeight        = UIScreen.main.bounds.size.height
    static let screenMaxLength    = max(screenWidth, screenHeight)
    static let screenMinLength    = min(screenWidth, screenHeight)
}
