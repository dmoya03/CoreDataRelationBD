//
//  Toast.swift
//  CoreDataTwo
//
//  Created by Daniel Moya on 22/5/24.
//

import SwiftUI
import UIKit

// Definición de la vista ToastView
struct ToastView: View {
    let message: String

    var body: some View {
        Text(message)
            .foregroundColor(.white)
            .padding()
            .background(Color.black.opacity(0.8))
            .cornerRadius(10)
            .shadow(radius: 10)
            .transition(.opacity)
            .animation(.easeInOut, value: message)
    }
}

// ViewModel para manejar el estado del Toast
class ToastManager: ObservableObject {
    static let shared = ToastManager()
    @Published var isShowing = false
    @Published var message = ""

    private init() {}

    func showToast(message: String, duration: Double = 2.0) {
        self.message = message
        self.isShowing = true

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation {
                self.isShowing = false
            }
        }
    }
}

// Controlador de ventana para manejar la superposición del Toast
class ToastWindowController {
    static let shared = ToastWindowController()
    private var window: UIWindow?

    func showToast(message: String) {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return
        }

        if window == nil {
            window = UIWindow(windowScene: scene)
            window?.rootViewController = UIHostingController(rootView: ToastWindowView())
            window?.windowLevel = .alert + 1
            window?.backgroundColor = .clear
            window?.isUserInteractionEnabled = false
            window?.makeKeyAndVisible()
        }

        if let toastManager = (window?.rootViewController as? UIHostingController<ToastWindowView>)?.rootView.toastManager {
            toastManager.showToast(message: message)
        }
    }

    func hideToast() {
        window?.isHidden = true
        window = nil
    }
}

// Vista para la ventana de superposición del Toast
struct ToastWindowView: View {
    @StateObject var toastManager = ToastManager.shared

    var body: some View {
        VStack {
            Spacer()
            if toastManager.isShowing {
                ToastView(message: toastManager.message)
                    .padding(.bottom, 50)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.clear)
        .onReceive(toastManager.$isShowing) { isShowing in
            if !isShowing {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    ToastWindowController.shared.hideToast()
                }
            }
        }
    }
}

// Función global para mostrar el Toast
func showToast(message: String) {
    ToastWindowController.shared.showToast(message: message)
}

