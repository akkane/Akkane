//
// This file is part of Akane
//
// Created by JC on 09/11/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

/**
ComponentView is used on an `UIView` in order to associate it to a 
`ComponentViewModel` implementing its business logic.

- *Future enhancements:* this protocol will be generic once we will be able to 
use generics with Storyboard/Xib
*/
public protocol ComponentView : class, HasAssociatedObjects {

    /**
     `ComponentViewController` class associated to the `ComponentView`

     - returns: The `ComponentViewController` type.
     The Default implementation returns `ComponentViewController.self`
     */
    static func componentControllerClass() -> ComponentViewController.Type
    
    /**
     Define the bindings between the fields (IBOutlet) and the ComponentViewModel
     
     - parameter observer:  The observer to use for defining  and registering
     bindings
     - parameter viewModel: The `ComponentViewModel` associated to the `UIView`
     */
    func bindings(viewModel: AnyObject)
}

var ViewObserverLifecycleAttr = "ViewObserverLifecycleAttr"

extension ComponentView {
    
    public static func componentControllerClass() -> ComponentViewController.Type {
        return ComponentViewController.self
    }
    
    public internal(set) weak var componentLifecycle: Lifecycle? {
        get {
            guard let weakValue = self.associatedObjects[ViewObserverLifecycleAttr] as? AnyWeakValue else {
                return nil
            }
            
            return weakValue.value as? Lifecycle
        }
        set { self.associatedObjects[ViewObserverLifecycleAttr] = AnyWeakValue(newValue) }
    }
}
