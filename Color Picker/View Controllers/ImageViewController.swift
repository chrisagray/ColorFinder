//
//  CameraViewController.swift
//  Color Picker
//
//  Created by Chris Gray on 1/9/18.
//  Copyright © 2018 Chris Gray. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var colorBarButton: UIBarButtonItem!
    @IBOutlet weak var hexBarButton: UIBarButtonItem!
    @IBOutlet weak var rgbBarButton: UIBarButtonItem!
    @IBOutlet weak var pixelTargetView: PixelTargetView!
    @IBOutlet weak var imageButton: UIButton!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem! {
        didSet {
            cameraButton.isEnabled = cameraIsAvailable || photoLibraryIsAvailable
        }
    }
    
    private var backgroundImageView = UIImageView()
    private let reader = ImagePixelReader()
    private let minimumZoomScale: CGFloat = 0.25
    private let maximumZoomScale: CGFloat = 1.0
    
    private var centerColor = HexColor() {
        didSet {
            centerColorWasSet = true
        }
    }
    private var centerColorWasSet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pixelTargetView.isHidden = true
    }
    
    //duplicated with CustomCameraVC
    @IBAction func copyColor(_ sender: UIBarButtonItem) {
        if centerColorWasSet {
            if let hexValue = centerColor.hexValue {
                copyHexColorWithBanner(hex: "#\(hexValue)")
            }
        }
    }
    
    //MARK: - Image
    
    private var centerPixelLocation: CGPoint! {
        return CGPoint(x: Int((scrollView.contentOffset.x)/scrollView.zoomScale), y: Int((scrollView.contentOffset.y)/scrollView.zoomScale))
    }
    
    private var userChosePhoto = false {
        didSet {
            imageButton.isHidden = true
            pixelTargetView.isHidden = false
            view.bringSubview(toFront: pixelTargetView)
        }
    }
    
    private var backgroundImage: UIImage? {
        didSet {
            if !userChosePhoto {
                userChosePhoto = true
            }
            reader.image = backgroundImage!.fixOrientation()
            
            backgroundImageView.image = backgroundImage
            backgroundImageView.sizeToFit()
            setContentSizes()
        }
    }
    
    private func setContentSizes() {
        scrollView.zoomScale = minimumZoomScale
        
        backgroundImageView.frame = CGRect(x: scrollView.frame.width/2, y: scrollView.frame.height/2, width: backgroundImageView.frame.width, height: backgroundImageView.frame.height)
        
        scrollView.contentSize = backgroundImageView.frame.size
        
        scrollView.contentOffset.x = (backgroundImage!.size.width/2)*scrollView.zoomScale
        scrollView.contentOffset.y = (backgroundImage!.size.height/2)*scrollView.zoomScale
    }
    
    private func getColorFromCenter() {
        //dividing scollView's offsets by the zoomScale if we're zoomed in/out
        
        if (centerPixelLocation.x >= 0 && centerPixelLocation.x < backgroundImage!.size.width) && (centerPixelLocation.y >= 0 && centerPixelLocation.y < backgroundImage!.size.height) {
            if let color = reader.getColorFromPixel(centerPixelLocation) {
                centerColor.uiColor = color
            }
        } else {
            centerColor.uiColor = .white
        }
        
        colorBarButton.tintColor = centerColor.uiColor
        hexBarButton.title = "#\(centerColor.hexValue!)"
        
        let (red, green, blue, _) = centerColor.rgb255Values
        
        rgbBarButton.title = String(describing: (Int(red), Int(green), Int(blue)))
    }
    
    //MARK: - Scroll View
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.minimumZoomScale = minimumZoomScale
            scrollView.maximumZoomScale = maximumZoomScale
            scrollView.addSubview(backgroundImageView)
        }
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return backgroundImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        
        let offsetX = scrollView.frame.width
        let offsetY = scrollView.frame.height
        
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: offsetY, right: offsetX)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        getColorFromCenter()
    }
    
    //MARK: - Camera
    
    private var cameraIsAvailable: Bool {
        return UIImagePickerController.isSourceTypeAvailable(.camera)
    }
    private var photoLibraryIsAvailable: Bool {
        return UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
    }
    
    
    @IBAction func presentImageChoices(_ sender: Any) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        if cameraIsAvailable {
            alert.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
                self.takePhoto()
            }))
        }
        if photoLibraryIsAvailable {
            alert.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { _ in
                self.choosePhoto()
            }))
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            alert.dismiss(animated: true)
        }))
        alert.modalPresentationStyle = .popover
        alert.popoverPresentationController?.barButtonItem = cameraButton
        present(alert, animated: true)
    }
    
    //MARK: - ImagePickerController
    
    private func takePhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true)
    }
    
    private func choosePhoto() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true)
        if let image = (info[UIImagePickerControllerEditedImage] as? UIImage ?? info[UIImagePickerControllerOriginalImage]) as? UIImage {
            backgroundImage = image
        }
        getColorFromCenter()
    }
}
