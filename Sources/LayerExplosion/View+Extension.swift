//
//  View+Extension.swift
//
//
//  Created by Luis Gonzalez on 3/5/24.
//

import Foundation
import SwiftUI

struct UpdatableGeoReaderModifier: ViewModifier {
    var id: String
    var coordinateSpace: CoordinateSpace = .global
    var rectCallback: (CGRect) -> Void
    @StateObject private var changeHistory = ChangeHistory()
    
    class ChangeHistory: ObservableObject {
        static let changeQueue = DispatchQueue(label: "es.innotest.geo_reader_change")
        var lastValue: GeoRectUnit?
    }
    
    init(id: String? = nil, coordinateSpace: CoordinateSpace, rectCallback: @escaping (CGRect) -> Void) {
        self.id = id ?? UUID().uuidString
        self.coordinateSpace = coordinateSpace
        self.rectCallback = rectCallback
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader {geo in
                    Color.clear
                        .preference(key: GeoProxyPrefKey.self, value: [
                            GeoRectUnit(id: id, value: geo.frame(in: coordinateSpace))
                        ])
                }
            )
            .onPreferenceChange(GeoProxyPrefKey.self) { rects in
                guard let unit = rects.first(where: { $0.id == self.id }) else {
                    return
                }
                
                let lastValue = changeHistory.lastValue
                
                ChangeHistory.changeQueue.async {
                    if let lastValue {
                        if unit == lastValue { return } // Only notify of value changes
                    }
                    
                    DispatchQueue.main.async {
                        self.changeHistory.lastValue = unit
                        
                        rectCallback(unit.value)
                    }
                }
            }
    }
    
    struct GeoRectUnit: Equatable {
        var id: String
        var value: CGRect
    }
    
    struct GeoProxyPrefKey: PreferenceKey {
        static var defaultValue: [GeoRectUnit] = []
        
        static func reduce(value: inout [GeoRectUnit], nextValue: () -> [GeoRectUnit]) {
            value.append(contentsOf: nextValue())
        }
    }
}

extension View {
    @ViewBuilder
    func rectReader(id: String? = nil, in coordinateSpace: CoordinateSpace = .global, _ rectCallback: @escaping (CGRect) -> Void) -> some View {
        self
            .modifier(UpdatableGeoReaderModifier(id: id, coordinateSpace: coordinateSpace, rectCallback: rectCallback))
    }
}
