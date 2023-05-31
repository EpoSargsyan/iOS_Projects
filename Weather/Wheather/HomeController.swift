//
//  HomeController.swift
//  Wheather
//
//  Created by Eprem Sargsyan on 14.04.23.
//

import UIKit

class HomeController: UIViewController {

    private let viewModel = HomeViewModel()
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var MInTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var HumidityLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchWeather { [weak self] in
            DispatchQueue.main.async {
                self?.setUpUI()
            }
        }
    }
    
    private func setUpUI() {
        setupHeader()
        setUpSubHeader()
    }
    
    private func setupHeader() {
        temperatureLabel.text = viewModel.temperatureString
        nameLabel.text = viewModel.nameString
    }
    
    private func setUpSubHeader() {
        feelsLikeLabel.text = viewModel.feelsLikeTempString
        MInTempLabel.text = viewModel.MInTempString
        maxTempLabel.text = viewModel.maxTempString
        pressureLabel.text = viewModel.pressureString
        HumidityLabel.text = viewModel.humidityString
    }
}

