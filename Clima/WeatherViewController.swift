//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire    // to make XHR call
import SwiftyJSON   // to parse API response to JSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "a5274e9b87ada6147a64307616b452d1"
    /***Get your own App ID at https://openweathermap.org/appid ****/
    

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()

    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
        locationManager.delegate = self    // delegate current class so that we can get the result in this class
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters     // define desired location accuracy
        locationManager.requestWhenInUseAuthorization()    // setup permission to acquire location
        locationManager.startUpdatingLocation()
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeatherData(url: String, params: [String: String]) {
        Alamofire.request(url, method: .get, parameters: params).responseJSON { response in
            if response.result.isSuccess {
                let weatherJSON: JSON = JSON(response.result.value!)
                print(weatherJSON)
                
                self.updateWeatherData(json: weatherJSON)
                
            } else {
                print("Error..... \(response.result.error!)")
                self.cityLabel.text = "Connection Error!"
            }
            
        }
        
    }

    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    func updateWeatherData(json: JSON) {
        let tempResult = (json["main"]["temp"].double)! - 273.15
        
        cityLabel.text = "\(json["name"])"
        temperatureLabel.text = "\(Int(tempResult))°C"
    }

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here: when the updateLocation is successful & comes back with results
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count-1]    // location manager will execute several times & push the result in an array CCLocation. The most accurate result is the latest result. Therefore, use the last index array
        // print(location)
        
        // if horizontalAccuracy > 0. Then it is accurate & valid result. Otherwise, not valid & accurate
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params: [String: String] = ["lat": latitude, "lon": longitude, "appid": APP_ID]
            print(params)
            
            getWeatherData(url: WEATHER_URL, params: params)
        }
        
    }
    
    
    //Write the didFailWithError method here: when the updateLocation fails & comes back with error
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Failed Retrieving Location!"
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    

    
    //Write the PrepareForSegue Method here
    
    
    
    
    
}


