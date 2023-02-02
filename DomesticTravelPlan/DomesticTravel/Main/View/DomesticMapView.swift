//
//  DomesticMapView.swift
//  DomesticTravelPlan
//
//  Created by  on 2020/4/27.
//  Copyright © 2020 1. All rights reserved.
//

import UIKit
import MapKit

class DomesticMapView: UIView, MKMapViewDelegate {
    
    var px: Double = 0
    var py: Double = 0
    
    @IBOutlet weak var mMapView: MKMapView!
    @IBOutlet var views: UIView!
    
    @IBAction func didClickDismissBtn(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
    init(frame: CGRect, px: Double, py: Double) {
        super.init(frame: frame)
        self.px = px
        self.py = py
        subviewinit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func subviewinit() {
        Bundle.main.loadNibNamed("DomesticMapView", owner: self, options: nil)
        self.addSubview(views)

        views.translatesAutoresizingMaskIntoConstraints = false
        views.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        views.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        views.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        views.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        mMapView.delegate = self
        mapDisplay()
    }
    
    private func mapDisplay() {
        let studioAnnotation = MKPointAnnotation()
        studioAnnotation.coordinate = CLLocationCoordinate2D(latitude: py, longitude: px)
        mMapView.setCenter(studioAnnotation.coordinate, animated: true)
        mMapView.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: py, longitude: px), latitudinalMeters: 500, longitudinalMeters: 500)
        mMapView.addAnnotation(studioAnnotation)
    }
}
