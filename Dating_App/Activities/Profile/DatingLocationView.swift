//
//  DatingLocationView.swift
//  Dating_App
//
//  Created by Robyn Chau on 05/04/2022.
//

import SwiftUI
import MapKit

struct DatingLocationView: View {
    let location: CLLocationCoordinate2D?
    var body: some View {
        if let data = location {
            VStack {
                MapView(annotation: getAnnotation(data: data))
            }
            .onAppear {
                getPlace(for: CLLocation(latitude: data.latitude, longitude: data.longitude)) { placeMark in
                    guard let placeMark = placeMark else { return }
                    var output = "Our location is:"
                    if let country = placeMark.country {
                        output = output + "\n\(country)"
                    }
                    if let state = placeMark.administrativeArea {
                        output = output + "\n\(state)"
                    }
                    if let town = placeMark.locality {
                        output = output + "\n\(town)"
                    }
                    print(output)
                }
            }
        } else {
            Text("Location was not recorded for this contact")
                .padding()
        }
    }

    func getAnnotation(data: CLLocationCoordinate2D) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: data.latitude, longitude: data.longitude)
        return annotation
    }

    func getPlace(for location: CLLocation, completion: @escaping (CLPlacemark?) -> Void) {
        let geoCoder = CLGeocoder()
        geoCoder.reverseGeocodeLocation(location) { placeMarks, error in
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            guard let placeMark = placeMarks?[0] else {
                print("*** Error in \(#function): Place Mark is nil")
                completion(nil)
                return
            }
            completion(placeMark)
        }
    }
}
