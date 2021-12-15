//
//  ViewController.swift
//  qr-coder
//
//  Created by Avijeet Sachdev on 12/14/21.
//

import UIKit
import SnapKit

enum UI {
    static let textFieldTopPadding: CGFloat = 22
    static let leading: CGFloat = 22
    static let trailing: CGFloat = 22
    static let padding: CGFloat = 14
    static let textFieldHeight: CGFloat = 400
    static let imageSize: CGFloat = 200
    static let fontSize: CGFloat = 28
}

class ViewController: UIViewController {
    
    // MARK: - Attributes -
    var textField: UITextField!
    var imageView: UIImageView!

    // MARK: - Lifecycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
    }
    
    
    // MARK: - Helper Functions -
    func generateQRCode(with text: String) -> UIImage? {
        let data = text.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }

    // MARK: - Setup UI -
    func setupUI() {
        textField = UITextField()
        textField.addTarget(self, action: #selector(updateImage), for: .editingChanged)
        textField.delegate = self
        textField.placeholder = "Enter text here..."
        textField.textAlignment = .center
        textField.font =  UIFont(name: ("Avenir"), size: UI.fontSize)
        
        imageView = UIImageView()
        imageView.image = generateQRCode(with: "") ?? UIImage()
        
        view.addSubview(textField)
        view.addSubview(imageView)
        
        addConstraints()
    }
    
    @objc
    func updateImage() {
        guard let text = textField.text else { return }
        imageView.image = generateQRCode(with: text) ?? UIImage()
    }
    
    func addConstraints() {
        textField.snp.makeConstraints { make in
            make.height.equalTo(UI.textFieldHeight)
            make.top.equalToSuperview().offset(UI.textFieldTopPadding)
            make.leading.equalToSuperview().offset(UI.leading)
            make.trailing.equalToSuperview().inset(UI.trailing)
        }
        
        imageView.snp.makeConstraints { make in
            make.top.equalTo(textField.snp.bottom).offset(UI.padding)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(UI.imageSize)
        }
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
