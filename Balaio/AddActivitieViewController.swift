//
//  AddActivitieViewController.swift
//  Balaio
//
//  Created by Camila Simões Marques Wanderley on 9/25/17.
//  Copyright © 2017 Camila Simões Marques Wanderley. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation



class AddActivitieViewController: UIViewController, UITextFieldDelegate, MKMapViewDelegate, CLLocationManagerDelegate {
  
  
  // Outlets e variáveis
  @IBOutlet weak var nomeEvento: UITextField!
  
  @IBOutlet weak var descricaoEvento: UITextField!
  
  @IBOutlet weak var popview: PopView!
  
  @IBOutlet weak var escolhaDaTag: UIImageView!
  
  @IBOutlet weak var quandoAcabaLabel: UILabel!
  
  @IBOutlet weak var quandoAcabaDataPicker: UIDatePicker!
  
  @IBOutlet weak var mapaLocalizacao: MKMapView!
  
  // constante pra usar na abertura do mapa
  var locationManagerAdd = CLLocationManager()
  
  var locationNow: CLLocation?
  
  var screenLoadFirst: Bool = true
 
  
  
  // View Did Load ()
  override func viewDidLoad() {
    super.viewDidLoad()
    nomeEvento.delegate = self
    descricaoEvento.delegate = self
    mapaLocalizacao.delegate = self
    
    // Da zoom na localização do usuário
    if CLLocationManager.locationServicesEnabled() {
      locationManagerAdd.delegate = self
      locationManagerAdd.desiredAccuracy = kCLLocationAccuracyBest
      locationManagerAdd.startUpdatingLocation()
    }
  
    // mapaLocalizacao.isUserLocationVisible = false // error isUserLocationVisible is a get only property
    mapaLocalizacao.isPitchEnabled = false // perspectiva
    
  }
  
  
  // Mostra a barra de navegação 
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.isNavigationBarHidden = false
    popview.isHidden = true
  }

  
  //Esconde o teclado ao clicar em Return
  func textFieldShouldReturn(_ textField : UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  
  // Dá o zoom na localização do evento (a mesma do usuário, por enquanto)
  // tem um if que só roda o zoom quando a tela é carregado
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    locationNow = locations[0]
    
    if screenLoadFirst == true {
      
      // Cria o pin do evento no mapa
      let newPin = MKPointAnnotation()
      newPin.coordinate = CLLocationCoordinate2D(latitude: locationNow!.coordinate.latitude, longitude: locationNow!.coordinate.longitude)
      mapaLocalizacao.addAnnotation(newPin)
      
      let zoom: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
      let userLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(locationNow!.coordinate.latitude, locationNow!.coordinate.longitude)
      let mapVisualArea: MKCoordinateRegion = MKCoordinateRegionMake(userLocation, zoom)
      
      mapaLocalizacao.setRegion(mapVisualArea, animated: true)
      self.mapaLocalizacao.showsUserLocation = true
      
      screenLoadFirst = false
    }
    
  }


    // Actions
    
    @IBAction func escolhaDaTag(_ sender: UIButton) {
        popview.isHidden = false
    }
    
    //POPUP
    @IBAction func celebrar(_ sender: UIButton) {
        escolhaDaTag.image = celebrarTag.tagIconColor
        popview.isHidden = true
    }
    @IBAction func contemplar(_ sender: UIButton) {
        escolhaDaTag.image = contemplarTag.tagIconColor
        popview.isHidden = true
    }
    @IBAction func colaborar(_ sender: UIButton) {
        escolhaDaTag.image = colaborarTag.tagIconColor
        popview.isHidden = true
    }
    @IBAction func praticar(_ sender: UIButton) {
        escolhaDaTag.image = praticarTag.tagIconColor
        popview.isHidden = true
    }
  
  
  
  // Novo Pin no mapa
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if let annotation = annotation as? MKPointAnnotation {
      let pinWillBeAdd = MKAnnotationView(annotation: annotation,reuseIdentifier: "newPin")
        pinWillBeAdd.image = UIImage(named:"neutralPin")!
      pinWillBeAdd.canShowCallout = false
      
      return pinWillBeAdd
    }
    return nil
  }
  
  
    
  // ENVIAR - append nova atividade no array
  @IBAction func enviarEventoProBancoDeDados(_ sender: UIButton) {
    
    let componentesDoPicker: DateComponents = Calendar.current.dateComponents([.hour,.minute], from: self.quandoAcabaDataPicker.date)
    let horaQueAcaba = componentesDoPicker.hour!
    let minutoQueAcaba = componentesDoPicker.minute!
    // jeito de comparar comentado na função refreshPin()
    
    
    let novoEvento = CulturalActivities()
    
    novoEvento.activitieName = nomeEvento.text!
    novoEvento.shortComment = descricaoEvento.text!
    novoEvento.activitieTag = celebrarTag // precisa de uma lógica pra pegar a tag escolhida
    novoEvento.endsAt = "Acaba de \(horaQueAcaba)h\(minutoQueAcaba)min"
    novoEvento.location = (locationNow?.coordinate)!
    
    // o init que vai ser usado: (activitiesName: String, location: CLLocationCoordinate2D, endsAt: String, tag: Tag, shortComment: String)
    
    bancoDeDados.append(novoEvento)
    
  }
  
  }
