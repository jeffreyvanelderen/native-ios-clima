//
//  WeatherData.swift
//  Clima
//
//  Created by Jeffrey Vanelderen on 18/03/2024.
//  Copyright © 2024 App Brewery. All rights reserved.
//

import Foundation

public struct ExternalWeatherData : Decodable {
    let name: String;
    let weather: [ExternalWeather];
    let main: ExternalMain;
}

public struct ExternalMain : Decodable {
    let temp: Double;
}

public struct ExternalWeather : Decodable {
    let id: Int;
    let main: String;
    let description: String;
    let icon: String;
}
