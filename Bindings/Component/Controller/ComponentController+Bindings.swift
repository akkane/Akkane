//
// This file is part of Akane
//
// Created by JC on 15/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation

#if AKANE_BINDINGS

extension ComponentController {
    
    public func makeBindings() {
        guard let viewModel = self.viewModel, let componentView = self.componentView as? ViewObserver else {
            return
        }

        self.stopBindings()
        componentView.observerCollection = ObservationCollection()

        componentView.componentLifecycle = self
        componentView.bindings(viewModel: viewModel)
    }

    public func stopBindings() {
        guard let componentView = self.componentView as? ViewObserver else { return }
        componentView.observerCollection?.removeAllObservers()
    }
}

#endif
