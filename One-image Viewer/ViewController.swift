//
//  ViewController.swift
//  One-image Viewer
//
//  Created by Chen Yi-Wei on 2019/3/19.
//  Copyright © 2019 Chen Yi-Wei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 2.0
        scrollView.zoomScale = 1.0
		scrollView.contentSize = contentImageView.bounds.size
        scrollView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.delegate = self
        return scrollView
    }()

    let contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1)
		imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 249/255, green: 223/255, blue: 23/255, alpha: 1)
        view.layer.applySketchShadow(color: .black, alpha: 0.5, xPosition: 0, yPosition: 0, blur: 10, spread: 0)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var pickImageButton: UIButton = {
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

		view.backgroundColor = UIColor(red: 43/255, green: 43/255, blue: 43/255, alpha: 1)
		constructViewHierarchy()
        activateConstraints()
    }

	private func updateMinimumZoomScaleForSize() {
		let scrollViewSize = scrollView.bounds.size
		let widthScale = scrollViewSize.width / contentImageView.bounds.width
		let heightScale = scrollViewSize.height / contentImageView.bounds.height
		let minimumScale = min(widthScale, heightScale)

		scrollView.minimumZoomScale = minimumScale
		scrollView.zoomScale = minimumScale
		print("zoom scale updated: ", minimumScale)
	}

	private func constructViewHierarchy() {
		scrollView.addSubview(contentImageView)
		view.addSubview(scrollView)
		bottomView.addSubview(pickImageButton)
		view.addSubview(bottomView)
	}

    private func activateConstraints() {
		NSLayoutConstraint.activate([
			scrollView.topAnchor.constraint(equalTo: view.topAnchor),
			scrollView.bottomAnchor.constraint(equalTo: bottomView.topAnchor),
			scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
			scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
		])

		let safeAreaPadding = UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0
		NSLayoutConstraint.activate([
			bottomView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
			bottomView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
			bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
			bottomView.heightAnchor.constraint(equalToConstant: 77 + safeAreaPadding)
		])

		NSLayoutConstraint.activate([
			pickImageButton.leadingAnchor.constraint(equalTo: bottomView.leadingAnchor, constant: 98),
			pickImageButton.trailingAnchor.constraint(equalTo: bottomView.trailingAnchor, constant: -98),
			pickImageButton.heightAnchor.constraint(equalToConstant: 45),
			pickImageButton.topAnchor.constraint(equalTo: bottomView.topAnchor, constant: 16)
		])
    }

	private func presentErrorAlert() {
		let alert = UIAlertController(
			title: "Can't use this image",
			message: "Please choose another one",
			preferredStyle: .alert
		)

		let ok = UIAlertAction(
			title: "OK",
			style: .cancel,
			handler: nil
		)

		alert.addAction(ok)

		present(alert, animated: true, completion: nil)
	}

	@objc func pickImage() {
		if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
			let imagePicker = UIImagePickerController()
			imagePicker.delegate = self
			imagePicker.sourceType = .photoLibrary
			present(imagePicker, animated: true, completion: nil)
		}
	}
}

extension ViewController: UIScrollViewDelegate {
	func viewForZooming(in: UIScrollView) -> UIView? {
		return contentImageView
	}

	func scrollViewDidZoom(_ scrollView: UIScrollView) {
		let offsetX = max((scrollView.bounds.width - scrollView.contentSize.width) * 0.5, 0.0)
		let offsetY = max((scrollView.bounds.height - scrollView.contentSize.height) * 0.5, 0.0)
		scrollView.contentInset = .init(top: offsetY, left: offsetX, bottom: 0.0, right: 0.0)
		print("scroll view content inset updated: ", scrollView.contentInset, "content size: ", scrollView.contentSize)
	}
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		dismiss(animated: true, completion: nil)

		guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
			presentErrorAlert()
			return
		}
		contentImageView.image = image
		contentImageView.frame = .init(origin: .zero, size: image.size)
		updateMinimumZoomScaleForSize()
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
