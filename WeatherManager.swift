import Foundation
import UIKit;

public protocol WeatherManagerDelegate : NSObjectProtocol {
    func onWeatherResult(weather: ExternalWeatherData) -> Void
    func onWeatherFailedWithError(_ error: Error) -> Void;
}

struct WeatherManager {
    private let openWeatherAPIKey = "c624a0a8f0ba8253f25b32d037e34f21";
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid=c624a0a8f0ba8253f25b32d037e34f21&units=metric";
    var delegate: WeatherManagerDelegate?;
    
    func getCurrentWeather(forLocation location: String, onResult: ( (_ weather: ExternalWeatherData) -> Void)?) {
        let url = "\(baseURL)&q=\(location)";
        getRequest(url: url, onResult: onResult)
    }
    
    func getCurrentWeather(lat: Int, lng: Int, onResult: ((_ weather: ExternalWeatherData) -> Void)?) {
        let url = "\(baseURL)&lat=\(lat)&lng=\(lng)";
        getRequest(url: url, onResult: onResult)
    }
    
    static func getIconForWeatherId(_ id: Int) -> UIImage? {
        var icon = "";
        
        switch id {
        case 200...300:
            icon = "cloud.bolt"; break;
        case 400...500:
            icon = "cloud.snow"; break;
        case 500...600:
            icon = "cloud.rain"; break;
        case 600...700:
            icon = "cloud.snow"; break;
        case let id where id == 800:
            icon = "sun.max"; break;
        case 801...900:
            icon = "cloud"; break;
        default:
            icon = "";
        }
        
        return UIImage(systemName: icon);
    }
    
    private func getRequest(url: String, onResult: ((_ weather: ExternalWeatherData) -> Void)?) {
        if let url = URL(string: url) {
            let session = URLSession(configuration: .default);
            let task = session.dataTask(with: url) { data, response, error in
                let result = onRequestResult(data: data, response: response, error: error);
                if let result = result {
                    // Via closure
                    if let onResult = onResult {
                        onResult(result);
                    }

                    // or via delegate, cleaner!
                    delegate?.onWeatherResult(weather: result);
                }
            };
            task.resume();
        }
    }
    
    // THis could've been inlined (anon function = Swift closure)
    private func onRequestResult(data: Data?, response: URLResponse?, error: Error?) -> ExternalWeatherData? {
        if error != nil {
            print("Request error! \(error!)");
            delegate?.onWeatherFailedWithError(error!);
            return nil;
        }
        
        if let data = data {
            // {"coord":{"lon":5.3056,"lat":50.8755},"weather":[{"id":801,"main":"Clouds","description":"few clouds","icon":"02d"}],"base":"stations","main":{"temp":1.85,"feels_like":-2.56,"temp_min":0.92,"temp_max":2.89,"pressure":1008,"humidity":72},"visibility":10000,"wind":{"speed":4.92,"deg":230,"gust":5.81},"clouds":{"all":15},"dt":1705414561,"sys":{"type":2,"id":2003943,"country":"BE","sunrise":1705390479,"sunset":1705420891},"timezone":3600,"id":2803285,"name":"Alken","cod":200}
            
            // let json = String(data: data, encoding: .utf8)!;
            
            return decode(data);
        }
        return nil;
    }
    
    private func decode(_ data: Data) -> ExternalWeatherData? {
        let decoder = JSONDecoder();
        
        do {
            let decoded = try decoder.decode(ExternalWeatherData.self, from: data);
            print("WeatherManager.decode() succeeded '\(decoded)'");
            
            return decoded;
        } catch {
            print("WeatherManager.decode() failed with error '\(error)'");
            delegate?.onWeatherFailedWithError(error);
        }
        
        return nil;
    }
    
}
