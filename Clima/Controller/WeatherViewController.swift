//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit

/**
 Delegate is not a struct or class, it is a protocol.
 It 'lists' some 'requirements' which need to be fulfilled by the implementers ~ kind of like an interface
 */

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    private var weatherManager = WeatherManager();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Textfield should report back to this ViewController!
        searchTextField.delegate = self;
        // Our own delegate protocol! Report updates back to this ViewController! This way you don't need to use closures in functions
        weatherManager.delegate = self;
    }
    
    private func onReceiveWeatherData(_ weather: ExternalWeatherData) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.name;
            self.temperatureLabel.text = String(Int(round(weather.main.temp)));

            if !weather.weather.isEmpty {
                let currentWeather = weather.weather[0];
                self.conditionImageView.image = WeatherManager.getIconForWeatherId(currentWeather.id);
            }
        }
    }
}

// Moved all of the code related to the WeatherManagerDelegate to this extension! - Takes all responsibility for delegate code to this extension
extension WeatherViewController : WeatherManagerDelegate {
    // Via our custom own WeatherManagerDelegate!!!!!
    func onWeatherResult(weather: ExternalWeatherData) {
        print("onWeatherResult :: Via custom delegate protocol!")
        onReceiveWeatherData(weather);
    }
    
    // Via our custom own WeatherManagerDelegate!!!!!
    func onWeatherFailedWithError(_ error: Error) {
        print("onWeatherFailedWithError :: Via custom delegate protocol!", error)
    }
}


// Moved all of the code related to the UITextFieldDelegate to this extension - Takes all responsibility for delegate code to this extension
extension WeatherViewController : UITextFieldDelegate {
    
    @IBAction func onSearchPressed(_ sender: UIButton) {
        print(searchTextField.text!)
        // Dismiss kb
        searchTextField.endEditing(true);
    }
    
    // Via UITextFieldDelegate!
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print(textField.text!);
        // Dismiss kb
        searchTextField.endEditing(true);
        
        
        return true;
    }
    /**
     If you had multiple textfield, each one of them would trigger these delegate methods. They pass their reference via the textField param, which you could use to differentiate them.
     */
    
    // Via UITextFieldDelegate!
    // Good for validation on user input
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        // Keep kb open as long as user did not enter any text!
//        return textField.text != "";
//    }
    
    // Via UITextFieldDelegate!
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let locationInput = searchTextField.text {
            // Here we 'had' a closure onResult, but also possible to receive 'updates' via our custom WeatherManagerDelegate!
            
            // Here via closure
            // weatherManager.getCurrentWeather(forLocation: locationInput, onResult: onReceiveWeatherData(_:));
            
            
            // No closure passed, this will work since we conform to the WeatherManagerDelegate protocol!!!
            weatherManager.getCurrentWeather(forLocation: locationInput, onResult: nil);

            return
        }
        
        searchTextField.text = "";
    }
}
