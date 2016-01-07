//
// This file is part of Akane
//
// Created by JC on 06/12/15.
// For the full copyright and license information, please view the LICENSE
// file that was distributed with this source code
//

import Foundation
import Bond

public class ViewModelWrapper<T: Observation where T.Element: ViewModel> {
    public typealias ObservationType = T
    public typealias ViewModelType = T.Element

    let viewModel: ObservationType
    let disposeBag: DisposeBag
    unowned let lifecycle: Lifecycle

    init(viewModel: ObservationType, lifecycle: Lifecycle, disposeBag: DisposeBag) {
        self.viewModel = viewModel
        self.lifecycle = lifecycle
        self.disposeBag = disposeBag
    }

    public func bindTo<T:UIView where T:ComponentView>(view: T?) {
        if let view = view {
            self.bindTo(view)
        }
    }

    public func bindTo<T:UIView where T:ComponentView>(view: T) {
        let controller:ComponentViewController? = self.lifecycle.presenterForSubview(view, createIfNeeded: true)

        guard (controller != nil) else {
            return
        }

        self.disposeBag.addDisposable(
            self.viewModel.observe { viewModel in
                controller!.viewModel = viewModel
            }
        )
    }

    func bindTo(cell: UITableViewCell, template: Template) {
        template.bind(cell, wrapper: self)
    }
}

extension ViewModelWrapper where T.Element: CollectionItemViewModel {

    public func bindTo<T:UITableView where
        T.ViewModelType == ViewModelType,
        T:ComponentTableView,
        T.DataSourceType.DataType == T.ViewModelType.DataType,
        T.DataSourceType.ItemType == T.ViewModelType.ItemType,
        T.DataSourceType.ItemIdentifier.RawValue == String>
        (tableView: T) {

        // FIXME that makes 2 signals to disposebag
        self.bindTo(tableView)

        let controller:ComponentViewController? = self.lifecycle.presenterForSubview(tableView, createIfNeeded: false)

        self.disposeBag.addDisposable(
            self.viewModel.observe { [weak tableView] viewModel in
                if let tableView = tableView {
                    let delegate = TableViewDelegate.init(tableView: tableView, collectionViewModel: viewModel)

                    delegate.becomeDataSource(controller!.lifecycle.binder, data: viewModel.collection)
                }
            }
        )
    }
}