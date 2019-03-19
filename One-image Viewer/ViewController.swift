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

        scrollView.frame = CGRect(x: 0, y: 0, width: 375, height: 590)

        scrollView.contentSize = CGSize.init(width: 2000.0, height: 2000.0)

        scrollView.minimumZoomScale = 1.0

        scrollView.maximumZoomScale = 4.0

        scrollView.zoomScale = 1.0

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

        view.frame = CGRect(x: 0, y: 590, width: 375, height: 77)

        view.backgroundColor = UIColor(red: 249/255, green: 223/255, blue: 23/255, alpha: 1)

        view.layer.applySketchShadow(color: .black, alpha: 0.5, xPosition: 0, yPosition: 0, blur: 10, spread: 0)

        return view

    }()

    var pickImageButton: UIButton = {

        let button = UIButton()

        button.frame = CGRect(x: 98, y: 17, width: 180, height: 44)

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

        return button

    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        myScrollView.delegate = self

        view.addSubview(bottomView)

        myScrollView.addSubview(placeHolderImageView)

        bottomView.addSubview(pickImageButton)

//        placeHolderImageView.image = UIImage(named: "image-landing")

        view.addSubview(myScrollView)
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
