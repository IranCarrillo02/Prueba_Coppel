    //
    //  FavoriteButton.swift
    //  Prueba_Coppel
    //
    //  Created by Iran Carrillo on 24/07/22.
    //

    import UIKit

    class FavoriteButton: UIButton {
        
        let checkedImage = UIImage(named: "fav")
        let uncheckedImage = UIImage(named: "unfav")
        var isChecked: Bool = false {
            didSet {
                if isChecked == true {
                    self.setImage(checkedImage, for: UIControl.State.normal)
                } else {
                    self.setImage(uncheckedImage, for: UIControl.State.normal)
                }
            }
        }
        
        func setup(_ state: Bool) {
            if !state {
                self.isChecked = false
            } else {
                self.isChecked = true
            }
            
            self.addTarget(self, action:#selector(buttonClicked(sender:)), for: UIControl.Event.touchUpInside)
        }

        override init(frame: CGRect) {
            super.init(frame: frame)
            setup(false)
        }
        
        required public init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup(false)
        }


    @objc func buttonClicked(sender: UIButton) {
        if sender == self {
            isChecked = !isChecked
        }
    }
}
