//
//  File.swift
//  PPPlanner
//
//  Created by JIN YIJIA on 8/21/21.
//

import UIKit

class ColorCell: UICollectionViewCell
{
    override init(frame: CGRect) {
        super.init(frame: frame)
        constructViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func constructViews(){
        
//        let color = UIView()
//        addSubview(color)
//        color.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//        color.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//        color.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        color.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        layer.cornerRadius = frame.height/2
       

    }
    
    override var isSelected: Bool {
        didSet {
                    if isSelected {
                        print("is selected")
                        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                            self.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                        }, completion: nil)
                    } else {
                        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
                            self.transform = CGAffineTransform(scaleX: 1, y: 1)
                        }, completion: nil)
                    }
        }
    }
    
}
