//
//  FacetActiionRouter.swift
//  ToolExp00
//
//  Created by Thomas Wahl on 7/2/25.
//

//
//  FacetActionRouter.swift
//  UXKit
//
//  1. Purpose
//     Routes high-level facet UI actions to services.
// 2. Dependencies
//     Combine, RepKit, ServiceKit
// 3. Overview
//     Receives `FacetAction` payloads, invokes corresponding service.
// 4. Usage
//     Inject into view models handling facet UI.
// 5. Notes
//     Decouples UI from service implementations.

import Foundation
import Combine
import RepKit
import ServiceKit

/// Enum of all possible facet actions from the UI.
public enum FacetAction {
    case saveProject
    case loadProject(name: String)
    case exportImage(format: ImageFormat)
    case custom(name: String, parameters: [String:Any])
}

/// Routes facet actions to the appropriate service layer.
public final class FacetActionRouter {
    private var cancellables = Set<AnyCancellable>()

    public init() {
        // observe domain changes or UI messages if needed
    }

    /// Send a facet action to be handled.
    public func route(_ action: FacetAction) {
        switch action {
        case .saveProject:
            _ = ServiceKit.ResourceServ.shared.saveProject()
        case .loadProject(let name):
            _ = ServiceKit.ResourceServ.shared.loadProject(named: name)
        case .exportImage(let fmt):
            ServiceKit.ResourceServ.shared.exportCurrentView(format: fmt)
        case .custom(let name, let params):
            NotificationCenter.default.post(
                name: Notification.Name(name),
                object: params
            )
        }
    }
}
