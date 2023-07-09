//
//  ViewController.swift
//  RectangleGradient
//
//  Created by Pavel Parshutkin on 02.07.2023.
//

import UIKit

class ViewController: UIViewController {

    private lazy var rectangle: UIView = configureRectangle()
    private lazy var rectangleWrapper: UIView = configureRectangleWrapper()
    private lazy var slider: UISlider = configureSlider()
    private lazy var stack: UIStackView = configureMainStack()
    
    private var animator: UIViewPropertyAnimator!
    
    let rectangleScale: CGFloat = 1.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        self.view.addSubview(stack)

        self.animator = UIViewPropertyAnimator(duration: 0.35, curve: .linear) { [weak self] in
            guard let self = self else { return }

            var transform = CGAffineTransform.identity
            
            transform = transform.rotated(by: .pi/2)
            transform = transform.scaledBy(x: rectangleScale, y: rectangleScale)
            
            self.rectangle.transform =  transform
            self.rectangle.frame.origin.x = rectangleWrapper.frame.width - rectangle.frame.width
        
            self.view.layoutIfNeeded()
        }
        
        self.animator.pausesOnCompletion = true

        self.setupConstraints()
        
    }


    private func setupConstraints() {
        rectangleWrapper.translatesAutoresizingMaskIntoConstraints = false
        rectangle.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        stack.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            rectangleWrapper.heightAnchor.constraint(greaterThanOrEqualTo: self.rectangle.heightAnchor, multiplier: rectangleScale),
            
            rectangle.heightAnchor.constraint(equalToConstant: 100),
            rectangle.widthAnchor.constraint(equalToConstant: 100),
            rectangle.centerYAnchor.constraint(equalTo: rectangleWrapper.centerYAnchor),
            
            stack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            stack.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            stack.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            
        ])
        
    }
    

    
    private func configureMainStack() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.layoutMargins =  UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        stack.isLayoutMarginsRelativeArrangement = true
        stack.addArrangedSubview(rectangleWrapper)
        stack.addArrangedSubview(slider)
        stack.distribution = .fill
        stack.spacing = 16
        
        return stack
    }
    
    
    private func configureSlider() -> UISlider {
        let view = UISlider()
        view.addTarget(self, action: #selector(onSliderValChanged), for: .valueChanged)
        return view
    }
    
    @objc func onSliderValChanged(slider: UISlider, event: UIEvent) {
        if let touchEvent = event.allTouches?.first {
            switch touchEvent.phase {
            case .ended:
                slider.setValue(1.0, animated: true)
                self.animator.startAnimation()
                
            default:
                self.animator.fractionComplete = CGFloat(slider.value)
            }
        }
    }

    private func configureRectangle() -> UIView {
        let view = UIView()
        view.backgroundColor = .systemIndigo
        view.layer.cornerRadius = 8
        return view
    }
            
    private func configureRectangleWrapper() -> UIView {
        let view = UIView()
        view.addSubview(rectangle)
        return view
    }
}

