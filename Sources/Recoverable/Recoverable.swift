//
//  Recoverable.swift
//  SkeletonView
//
//  Created by Juanpe Catalán on 13/05/2018.
//  Copyright © 2018 SkeletonView. All rights reserved.
//

import UIKit

protocol Recoverable {
    func saveViewState()
    func recoverViewState(forced: Bool)
}

extension UIView: Recoverable {
    var viewState: RecoverableViewState? {
        get { return ao_get(pkey: &ViewAssociatedKeys.viewState) as? RecoverableViewState }
        set { ao_setOptional(newValue, pkey: &ViewAssociatedKeys.viewState) }
    }
    
    @objc func saveViewState() {
        viewState = RecoverableViewState(view: self)
    }
    
    @objc func recoverViewState(forced: Bool) {
        guard let storedViewState = viewState else { return }
        
        startTransition { [weak self] in
            self?.layer.cornerRadius = safeViewState.cornerRadius
            self?.layer.masksToBounds = safeViewState.clipToBounds
            self?.isUserInteractionEnabled = safeViewState.isUserInteractionEnabled
            
            if self?.backgroundColor == .clear || forced {
                self?.backgroundColor = storedViewState.backgroundColor
            }
            if safeViewState.isHidden != self?.isHidden || forced {
                self?.isHidden = safeViewState.isHidden
            }
        }
    }
}

extension UILabel {
    var labelState: RecoverableTextViewState? {
        get { return ao_get(pkey: &ViewAssociatedKeys.labelViewState) as? RecoverableTextViewState }
        set { ao_setOptional(newValue, pkey: &ViewAssociatedKeys.labelViewState) }
    }
    
    override func saveViewState() {
        super.saveViewState()
        labelState = RecoverableTextViewState(view: self)
    }
    
    override func recoverViewState(forced: Bool) {
        super.recoverViewState(forced: forced)
        guard let safeLabelState = labelState else { return }

        startTransition { [weak self] in
            self?.isUserInteractionEnabled = safeLabelState.isUserInteractionsEnabled

            if safeLabelState.textColor != self?.textColor || forced {
                self?.textColor = self?.labelState?.textColor
            }
        }
    }
}

extension UITextView {
    var textState: RecoverableTextViewState? {
        get { return ao_get(pkey: &ViewAssociatedKeys.labelViewState) as? RecoverableTextViewState }
        set { ao_setOptional(newValue, pkey: &ViewAssociatedKeys.labelViewState) }
    }
    
    override func saveViewState() {
        super.saveViewState()
        textState = RecoverableTextViewState(view: self)
    }
    
    override func recoverViewState(forced: Bool) {
        super.recoverViewState(forced: forced)
        guard let safeTextState = textState else { return }

        startTransition { [weak self] in
            self?.isUserInteractionEnabled = safeTextState.isUserInteractionsEnabled

            if safeTextState.textColor != self?.textColor || forced {
                self?.textColor = safeTextState.textColor
            }
        }
    }
}

extension UIImageView {
    var imageState: RecoverableImageViewState? {
        get { return ao_get(pkey: &ViewAssociatedKeys.imageViewState) as? RecoverableImageViewState }
        set { ao_setOptional(newValue, pkey: &ViewAssociatedKeys.imageViewState) }
    }
    
    override func saveViewState() {
        super.saveViewState()
        imageState = RecoverableImageViewState(view: self)
    }
    
    override func recoverViewState(forced: Bool) {
        super.recoverViewState(forced: forced)
        startTransition { [weak self] in
            self?.image = self?.image == nil || forced ? self?.imageState?.image : self?.image
        }
    }
}

extension UIButton {
    var buttonState: RecoverableButtonViewState? {
        get { return ao_get(pkey: &ViewAssociatedKeys.buttonViewState) as? RecoverableButtonViewState }
        set { ao_setOptional(newValue, pkey: &ViewAssociatedKeys.buttonViewState) }
    }
    
    override func saveViewState() {
        super.saveViewState()
        buttonState = RecoverableButtonViewState(view: self)
    }
    
    override func recoverViewState(forced: Bool) {
        super.recoverViewState(forced: forced)
        startTransition { [weak self] in
            if self?.title(for: .normal) == nil {
                self?.setTitle(self?.buttonState?.title, for: .normal)
            }
        }
    }
}
