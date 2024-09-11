//
//  ChatBubbleShape.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 9/10/24.
//

import Foundation
import SwiftUI

struct ChatBubbleShape: Shape {
    enum Direction {
        case left
        case right
    }

    let direction: Direction

    func path(in rect: CGRect) -> Path {
        return (direction == .left) ? leftBubble(in: rect) : rightBubble(in: rect)
    }

    private func leftBubble(in rect: CGRect) -> Path {
        // Para los mensajes del chatbot (a la izquierda)
        let width = rect.width
        let height = rect.height
        let path = Path { p in
            p.move(to: CGPoint(x: 0, y: height)) // Esquina inferior izquierda cuadrada
            p.addLine(to: CGPoint(x: width - 20, y: height))
            p.addCurve(to: CGPoint(x: width, y: height - 20),
                       control1: CGPoint(x: width - 8, y: height),
                       control2: CGPoint(x: width, y: height - 8))
            p.addLine(to: CGPoint(x: width, y: 20))
            p.addCurve(to: CGPoint(x: width - 20, y: 0),
                       control1: CGPoint(x: width, y: 8),
                       control2: CGPoint(x: width - 8, y: 0))
            p.addLine(to: CGPoint(x: 20, y: 0))
            p.addCurve(to: CGPoint(x: 0, y: 20),
                       control1: CGPoint(x: 8, y: 0),
                       control2: CGPoint(x: 0, y: 8))
            p.addLine(to: CGPoint(x: 0, y: height)) // Completa el path cuadrado
        }
        return path
    }

    private func rightBubble(in rect: CGRect) -> Path {
        // Para los mensajes del usuario (a la derecha)
        let width = rect.width
        let height = rect.height
        let path = Path { p in
            p.move(to: CGPoint(x: 25, y: height))
            p.addLine(to: CGPoint(x:  20, y: height))
            p.addCurve(to: CGPoint(x: 0, y: height - 20),
                       control1: CGPoint(x: 8, y: height),
                       control2: CGPoint(x: 0, y: height - 8))
            p.addLine(to: CGPoint(x: 0, y: 20))
            p.addCurve(to: CGPoint(x: 20, y: 0),
                       control1: CGPoint(x: 0, y: 8),
                       control2: CGPoint(x: 8, y: 0))
            p.addLine(to: CGPoint(x: width - 20, y: 0))
            p.addLine(to: CGPoint(x: width, y: 0)) // Esquina superior derecha cuadrada
            p.addLine(to: CGPoint(x: width, y: height - 20))
            p.addCurve(to: CGPoint(x: width - 20, y: height),
                       control1: CGPoint(x: width, y: height - 8),
                       control2: CGPoint(x: width - 8, y: height))
            p.addLine(to: CGPoint(x: 25, y: height)) // Completa el path cuadrado
        }
        return path
    }
}
