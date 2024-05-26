//
//  ParticleEffect.swift
//  DDooing
//
//  Created by kimjihee on 5/26/24.
//

import SwiftUI

fileprivate struct ParticleModifier: ViewModifier {
    var systemImage: String
    var font: Font
    var status: Bool
    var activeTint: Color
    var inActiveTint: Color
    
    @State private var particles: [ParticleModel] = []
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                ZStack {
                    Group {
                        ForEach(particles) { particle in
                            Image(systemName: systemImage)
                                .foregroundColor(status ? activeTint : inActiveTint)
                                .scaleEffect(particle.scale)
                                .offset(x: particle.randomX, y: particle.randomY)
                                .opacity(particle.opacity)
                                .opacity(status ? 1 : 0)
                                .animation(.none, value: status)
                        }
                    }
                }
                .onAppear {
                    if particles.isEmpty {
                        for _ in 1...15 {
                            let particle = ParticleModel()
                            particles.append(particle)
                        }
                    }
                }
                .onChange(of: status) { newValue in
                    if !newValue {
                        for i in particles.indices {
                            particles[i].reset()
                        }
                    } else {
                        for i in particles.indices {
                            let total = CGFloat(particles.count)
                            let progress = CGFloat(i) / total
                            let maxX: CGFloat = progress > 0.5 ? 100 : -100
                            let maxY: CGFloat = 60
                            let randomX: CGFloat = (progress > 0.5 ? progress - 0.5 : progress) * maxX
                            let randomY: CGFloat = (progress > 0.5 ? progress - 0.5 : progress) * maxY + 35
                            let randomScale: CGFloat = .random(in: 0.35...1.0)
                            
                            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                                let extraRandomX: CGFloat = progress > 0.5 ? .random(in: 0...10) : .random(in: -10...0)
                                let extraRandomY: CGFloat = .random(in: 0...30)
                                
                                particles[i].randomX = randomX + extraRandomX
                                particles[i].randomY = -randomY - extraRandomY
                            }
                            
                            withAnimation(.easeInOut(duration: 0.3)) {
                                particles[i].scale = randomScale
                            }
                            
                            
                            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7).delay(0.25 + (Double(i) * 0.005))) {
                                particles[i].scale = 0.001
                            }
                        }
                    }
                }
            }
    }
}
