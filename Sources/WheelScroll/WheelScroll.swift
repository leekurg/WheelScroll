//
//  WheelScroll.swift
//  TestSwiftUI
//
//  Created by Илья Аникин on 19.10.2023.

import SwiftUI

@available(iOS 17, *)
public struct WheelScroll<Content: View>: View {
    let axis: Axis.Set
    let contentSpacing: CGFloat

    @ViewBuilder let content: () -> Content

    public init(axis: Axis.Set = .vertical, contentSpacing: CGFloat = 15, content: @escaping () -> Content) {
        self.axis = axis
        self.contentSpacing = contentSpacing
        self.content = content
    }

    private var timingCurve: UnitCurve { axis.isVertical ? .easeIn : .easeOut }
    private var opacityThreshold: ScrollTransitionConfiguration.Threshold {
        axis.isVertical ? .visible(0.1) : .visible
    }
    private var blurThreshold: ScrollTransitionConfiguration.Threshold {
        axis.isVertical ? .visible(0.5) : .visible(0.8)
    }

    public var body: some View {
            ScrollView(axis, showsIndicators: false) {
                content()
                    .scrollTransition(
                        .interactive(timingCurve: .easeIn),
                        transition: scrollTransitionRoll
                    )
                    .scrollTransition(
                        .interactive(timingCurve: timingCurve).threshold(blurThreshold)
                    ) { effect, phase in
                        effect
                            .blur(radius: phase.isIdentity ? 0 : 5)
                            .scaleEffect(
                                x: phase.isIdentity
                                    ? 1
                                    : axis.isVertical ? 0.95 : 1,
                                y: phase.isIdentity
                                    ? 1
                                : axis == .horizontal ? 0.9 : 1
                            )
                    }
                    .scrollTransition(
                        .interactive(timingCurve: timingCurve).threshold(opacityThreshold)
                    ) { effect, phase in
                        effect.opacity(phase.isIdentity ? 1 : 0)
                    }
                    .embedInStack(axis, spacing: contentSpacing)
            }
            .defaultScrollAnchor(.topLeading)
            .scrollClipDisabled()
            .frame(maxWidth: .infinity)
            .padding(20)
            .clipShape(.rect)
    }

    @Sendable
    func scrollTransitionRoll(effect: EmptyVisualEffect, phase: ScrollTransitionPhase) -> some VisualEffect {
        effect
            .rotation3DEffect(
                .degrees(phase.isIdentity ? 0 : 80),
                axis: axis.isVertical ? (x: 1, y: 0, z: 0) : (x: 0, y: 1, z: 0),
                anchor: {
                    switch phase {
                    case .topLeading:
                        axis.isVertical ? .bottom : .trailing
                    case .identity:
                            .center
                    case .bottomTrailing:
                        axis.isVertical ? .top : .leading
                    }
                }(),
                anchorZ: 0,
                perspective: {
                    switch phase {
                    case .topLeading:
                        axis.isVertical ? 0.3 : -0.3
                    case .identity:
                        0
                    case .bottomTrailing:
                        axis.isVertical ? -0.3 : 0.3
                    }
                }()
            )
    }
}

fileprivate extension Axis.Set {
    var isVertical: Bool {
        self == .vertical
    }
}

fileprivate extension View {
    @ViewBuilder
    func embedInStack(_ axis: Axis.Set, spacing: CGFloat) -> some View {
        switch axis {
        case .horizontal:
            HStack(spacing: spacing, content: { self })
        default:
            VStack(spacing: spacing, content: { self })
        }
    }
}
