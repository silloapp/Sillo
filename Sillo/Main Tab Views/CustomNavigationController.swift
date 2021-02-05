
import UIKit

class CustomNavigationController: UINavigationBar {
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 51)
    }

}
