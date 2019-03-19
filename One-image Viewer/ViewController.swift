//
//  ViewController.swift
//  One-image Viewer
//
//  Created by Chen Yi-Wei on 2019/3/19.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var myScrollView: UIScrollView = {

        let scrollView = UIScrollView()

//        scrollView.frame = CGRect(x: 0, y: 0, width: 375, height: 590)

        scrollView.contentSize = CGSize.init(width: 2000.0, height: 2000.0)

        scrollView.minimumZoomScale = 1.0

        scrollView.maximumZoomScale = 4.0

        scrollView.zoomScale = 1.0

        scrollView.translatesAutoresizingMaskIntoConstraints = false

        return scrollView
    }()

    var placeHolderImageView: UIImageView = {

        let imageView = UIImageView()

        imageView.contentMode = .center

        imageView.backgroundColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1)

        imageView.tintColor = .white

        imageView.image = UIImage(named: "icon_photo")

        imageView.frame = CGRect(x: 0, y: 0, width: 375, height: 590)

        return imageView

    }()

    var bottomView: UIView = {

        let view = UIView()

        view.backgroundColor = UIColor(red: 249/255, green: 223/255, blue: 23/255, alpha: 1)

        view.layer.applySketchShadow(color: .black, alpha: 0.5, xPosition: 0, yPosition: 0, blur: 10, spread: 0)

        view.translatesAutoresizingMaskIntoConstraints = false

        return view

    }()

    var pickImageButton: UIButton = {

        let button = UIButton()

        button.layer.cornerRadius = 2.0

        button.backgroundColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1)

        button.layer.applySketchShadow(color: .black, alpha: 0.26, xPosition: 0, yPosition: 2, blur: 4, spread: 0)

        button.setTitle("Pick an Image", for: .normal)

        button.setTitleColor(.white, for: .normal)

        button.addTarget(self, action: #selector(pickImage), for: .touchUpInside)

        let textAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 20.0, weight: .heavy)
        ]

        let attributedString = NSAttributedString.init(string: "Pick an Image", attributes: textAttributes as [NSAttributedString.Key : Any])

        button.setAttributedTitle(attributedString, for: .normal)

        button.translatesAutoresizingMaskIntoConstraints = false


        return button

    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        myScrollView.delegate = self

        view.addSubview(bottomView)

        view.addSubview(placeHolderImageView)

        view.addSubview(pickImageButton)

        view.addSubview(myScrollView)

        self.setUpAutoLayout()
    }

    func viewForZooming(in: UIScrollView) -> UIView? {

        return self.placeHolderImageView

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage

        self.placeHolderImageView.image = image

        self.placeHolderImageView.contentMode = .scaleAspectFit

        self.dismiss(animated: true, completion: nil)
    }

    @objc func pickImage() {

        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {

            let imagePicker = UIImagePickerController()

            imagePicker.delegate = self

            imagePicker.sourceType = .photoLibrary

            self.present(imagePicker, animated: true, completion: nil)

        }
    }

    func setUpAutoLayout() {

        myScrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true

        myScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -77).isActive = true

        myScrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true

        myScrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true


        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true

        bottomView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true

        bottomView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true

        bottomView.heightAnchor.constraint(equalToConstant: 77).isActive = true



        placeHolderImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true

        placeHolderImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -77).isActive = true

        placeHolderImageView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true

        placeHolderImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true

        pickImageButton.bottomAnchor.constraint(equalTo: bottomView.bottomAnchor, constant: -16).isActive = true

        pickImageButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 98).isActive = true

        pickImageButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -97).isActive = true

        pickImageButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 17).isActive = true

    }
}

extension CALayer {
    func applySketchShadow(
        color: UIColor = .black,
        alpha: Float = 0.5,
        xPosition: CGFloat = 0,
        yPosition: CGFloat = 2,
        blur: CGFloat = 4,
        spread: CGFloat = 0) {
        shadowColor = color.cgColor
        shadowOpacity = alpha
        shadowOffset = CGSize(width: xPosition, height: yPosition)
        shadowRadius = blur / 2.0
        if spread == 0 {
            shadowPath = nil
        } else {
            let dxValue = -spread
            let rect = bounds.insetBy(dx: dxValue, dy: dxValue)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
