//
//  WeatherViewController.swift
//  Weather
//
//  Created by Maxim on 18.03.2026.
//

import UIKit

final class WeatherViewController: UIViewController {
    private let viewModel: WeatherViewModel
    private let dashboardView = WeatherDashboardView()
    
    private var pendingAlertMessage: String?

    init(viewModel: WeatherViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureNavigationBar()
        bindViewModel()
        viewModel.requestWeather()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            DispatchQueue.main.async {
                self?.render(state: state)
            }
        }
    }

    private func render(state: WeatherViewState) {
        switch state {
        case .idle(let viewData), .loading(let viewData), .loaded(let viewData):
            dashboardView.render(viewData: viewData)
        case .failed(let viewData, let alertMessage):
            dashboardView.render(viewData: viewData)
            presentErrorAlertIfNeeded(message: alertMessage)
        }
    }
    
}

extension WeatherViewController {
    @objc
    private func refreshTapped() {
        viewModel.requestWeather()
    }
    
    private func presentErrorAlertIfNeeded(message: String) {
        guard !message.isEmpty else { return }

        if pendingAlertMessage == message,
           presentedViewController is UIAlertController {
            return
        }

        pendingAlertMessage = message

        let presentAlert = { [weak self] in
            guard let self else { return }

            let alertController = UIAlertController(
                title: "Ошибка",
                message: message,
                preferredStyle: .alert
            )
            alertController.addAction(
                UIAlertAction(
                    title: "OK",
                    style: .default,
                    handler: { [weak self] _ in
                        self?.pendingAlertMessage = nil
                    }
                )
            )

            self.present(alertController, animated: true)
        }

        if let presentedAlert = presentedViewController as? UIAlertController {
            presentedAlert.dismiss(animated: false) { [weak self] in
                self?.pendingAlertMessage = nil
                presentAlert()
            }
            return
        }

        presentAlert()
    }
}

extension WeatherViewController {
    private func configureHierarchy() {
        view.backgroundColor = .black
        dashboardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(dashboardView)

        NSLayoutConstraint.activate([
            dashboardView.topAnchor.constraint(equalTo: view.topAnchor),
            dashboardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dashboardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dashboardView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func configureNavigationBar() {
        navigationItem.title = nil
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(refreshTapped)
        )
        navigationItem.rightBarButtonItem?.tintColor = .white

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        appearance.shadowColor = .clear
        appearance.buttonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.white]

        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
    }
}
