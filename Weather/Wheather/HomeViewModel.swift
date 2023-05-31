//
//  HomeViewModel.swift
//  Wheather
//
//  Created by Eprem Sargsyan on 17.04.23.
//

import Foundation

class HomeViewModel {
    var weater: Weather?
    
    var nameString: String {
        return String(weater?.name ?? "")
    }
    
    var temperatureString: String {
        return displayableCelsiusTemp(weater?.temp ?? 0)
    }
    
    var feelsLikeTempString: String {
        return displayableCelsiusTemp(weater?.feelsLike ?? 0)
    }
    
    var MInTempString: String {
        return displayableCelsiusTemp(weater?.minTemp ?? 0)
    }
    
    var maxTempString: String {
        return displayableCelsiusTemp(weater?.maxTemp ?? 0)
    }
    
    var pressureString: String {
        return String(format: "%.0f", weater?.pressure ?? 0)
    }
    
    var humidityString: String {
        return String(format: "%.0f", weater?.humidity ?? 0)
    }
    
    func fetchWeather(for cityId: Int = 3163858, _ completion: @escaping (() -> Void)) {
        NetworkCOntroller.fetchWheater(for: cityId) { weather in
            self.weater = weather
            completion()
        }
    }
    
    private func displayableCelsiusTemp(_ tempAsKelvin: Double) -> String {
        return String(format: "%.0f", tempAsKelvin.kelvinToCelsius) + " °C"
    }
}
