//
//  PresetMessage+UIImage.swift
//  Message-Preset MessagesExtension
//
//  Created by Nil Nguyen on 22/10/2022.
//

import UIKit

extension PresetMessage{
    func renderMessageImage(opaque: Bool) -> UIImage? {
        
        // Determine the size to draw as a sticker.
        let outputSize: CGSize = CGSize(width: 168, height: 124)
        
        
        let renderer = UIGraphicsImageRenderer(size: outputSize)
        let image = renderer.image { context in
            let backgroundColor: UIColor
            if opaque {
                backgroundColor = #colorLiteral(red: 0.9803921569, green: 0.8823529412, blue: 0.9215686275, alpha: 1)
            } else {
                backgroundColor = UIColor.clear
            }
            
            // Draw the background
            backgroundColor.setFill()
            context.fill(CGRect(origin: CGPoint.zero, size: outputSize))
            
                let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .natural

                let attrs = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Thin", size: 16)!, NSAttributedString.Key.paragraphStyle: paragraphStyle]

            let string = self.text
                string.draw(with: CGRect(origin: CGPoint(x: 5, y: 20), size: outputSize),
                            options: .usesLineFragmentOrigin,
                            attributes: attrs,
                            context: nil)
            
        }
        
        return image
    }

}
