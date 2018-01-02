//
//  TextToolView.swift
//  guanggoo-iOS
//
//  Created by 覃恳 on 31/12/2017.
//  Copyright © 2017 tdx. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import MBProgressHUD

class TextToolView: UIView ,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    fileprivate var atSomeOneButton:UIButton!;
    fileprivate var atSomeoneView:DropdownView?
    fileprivate var atSomeoneViewHeight = 30;
    fileprivate var showAtSomeoneView = false;
    fileprivate var nameList = [String]();
    fileprivate var navController:UINavigationController?;
    weak var vcDelegate:GuangGuVCDelegate?
    
    fileprivate var _imagePicker:UIImagePickerController!
    fileprivate var imagePicker:UIImagePickerController {
        get {
            guard _imagePicker == nil else {
                return _imagePicker;
            }
            _imagePicker = UIImagePickerController.init();
            _imagePicker.delegate = self;
            
            return _imagePicker;
        }
    }

    init(nameArray:[String]?,nav:UINavigationController?) {
        super.init(frame: CGRect.zero);
        
        self.navController = nav;
        if let count = nameArray?.count,count > 0 {
            self.nameList = nameArray!;
        }
        
        let stackView = UIStackView.init();
        stackView.axis         = .horizontal
        stackView.alignment    = .center
        stackView.distribution = .equalSpacing
        self.addSubview(stackView);
        stackView.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
            make.top.bottom.equalTo(self);
        }
        
        self.atSomeOneButton = UIButton.init();
        self.atSomeOneButton.setBackgroundImage(UIImage.init(named: "ic_atsomeone"), for: .normal);
        self.atSomeOneButton.addTarget(self, action: #selector(TextToolView.AtSomeoneClick(sender:)), for: UIControlEvents.touchUpInside)
        self.addSubview(atSomeOneButton);
        stackView.addArrangedSubview(self.atSomeOneButton);
        self.atSomeOneButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(stackView);
            make.width.equalTo(self.atSomeOneButton.snp.height);
        }
        
        let audioButton = UIButton.init();
        audioButton.setBackgroundImage(UIImage.init(named: "ic_audio"), for: .normal);
        audioButton.addTarget(self, action: #selector(TextToolView.AudioClick(sender:)), for: UIControlEvents.touchUpInside)
        self.addSubview(audioButton);
        stackView.addArrangedSubview(audioButton);
        audioButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(stackView);
            make.width.equalTo(audioButton.snp.height);
        }
        
        let takePhotoButton = UIButton.init();
        takePhotoButton.setBackgroundImage(UIImage.init(named: "ic_takePhoto"), for: .normal);
        takePhotoButton.addTarget(self, action: #selector(TextToolView.TakePhotoClick(sender:)), for: UIControlEvents.touchUpInside)
        self.addSubview(takePhotoButton);
        stackView.addArrangedSubview(takePhotoButton);
        takePhotoButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(stackView);
            make.width.equalTo(takePhotoButton.snp.height);
        }
        
        let photoButton = UIButton.init();
        photoButton.setBackgroundImage(UIImage.init(named: "ic_image"), for: .normal);
        photoButton.addTarget(self, action: #selector(TextToolView.UploadPhotoClick(sender:)), for: UIControlEvents.touchUpInside)
        self.addSubview(photoButton);
        stackView.addArrangedSubview(photoButton);
        photoButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(stackView);
            make.width.equalTo(photoButton.snp.height);
        }
        
        let commitButton = UIButton.init();
        commitButton.setBackgroundImage(UIImage.init(named: "ic_submit"), for: .normal);
        commitButton.addTarget(self, action: #selector(TextToolView.SubmitClick(sender:)), for: UIControlEvents.touchUpInside)
        self.addSubview(commitButton);
        stackView.addArrangedSubview(commitButton);
        commitButton.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(stackView);
            make.width.equalTo(commitButton.snp.height);
        }
        
        self.isUserInteractionEnabled = true;
        self.reloadAtSomeoneView();
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func AtSomeoneClick(sender: UIButton) {
        if self.showAtSomeoneView {
            self.atSomeoneView?.snp.updateConstraints({ (make) in
                make.height.equalTo(0);
            })
        }
        else {
            self.atSomeoneView?.snp.updateConstraints({ (make) in
                make.height.equalTo(self.atSomeoneViewHeight);
            })
        }
        self.showAtSomeoneView = !self.showAtSomeoneView;
        self.setNeedsLayout();
    }
    
    @objc func AudioClick(sender: UIButton) {
    }
    
    @objc func TakePhotoClick(sender: UIButton) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
        self.imagePicker.allowsEditing = false;
        self.navController?.present(self.imagePicker, animated: true, completion: nil);
    }
    
    @objc func UploadPhotoClick(sender: UIButton) {
        self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
        self.imagePicker.allowsEditing = false;
        self.navController?.present(self.imagePicker, animated: true, completion: nil);
    }
    
    @objc func SubmitClick(sender: UIButton) {
    }
    
    //处理点击@某人时不响应的问题
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if (self.atSomeoneView?.bounds.contains(self.convert(point, to: self.atSomeoneView)))! {
            return true;
        }
        return super.point(inside: point, with: event);
    }
    
    func reloadAtSomeoneView() -> Void {
        self.atSomeoneView?.removeFromSuperview();
        self.atSomeoneView = nil;
        let nameArray = Array(self.nameList)
        if nameArray.count > 0 {
            self.atSomeoneView = DropdownView.init(array: nameArray, handle: { [weak self](tableView, indexPath) in
                if indexPath.row < nameArray.count {
                    let name = nameArray[indexPath.row];
                    let msg = NSMutableDictionary.init();
                    msg["MSGTYPE"] = "InsertContent";
                    msg["PARAM1"] = "@" + name + " ";
                    self?.vcDelegate?.OnPushVC(msg: msg);
                }
                self?.showAtSomeoneView = false;
                self?.atSomeoneView?.snp.updateConstraints({ (make) in
                    make.height.equalTo(0);
                })
            })
            if nameArray.count > 7 {
                self.atSomeoneViewHeight = 200;
            }
            else {
                self.atSomeoneViewHeight = 30 * nameArray.count;
            }
            self.showAtSomeoneView = false;
            self.addSubview(self.atSomeoneView!);
            self.atSomeoneView!.snp.makeConstraints({ (make) in
                make.left.equalTo(self);
                make.bottom.equalTo(self.snp.top);
                make.width.equalTo(100);
                make.height.equalTo(0);
            })
        }
    }
    
    //MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            if let data = UIImagePNGRepresentation(chosenImage) as NSData? {
                Alamofire.upload(multipartFormData: { (multipartFormData) in
                    multipartFormData.append(data as Data!, withName: "smfile", fileName: "1.png", mimeType: "image/jpeg")
                }, to: "https://sm.ms/api/upload", encodingCompletion: { (result) in
                    switch result {
                    case .success(let upload, _, _):
                        print(result)
                        
                        let hudProgress = MBProgressHUD.showAdded(to: self.superview!, animated: true);
                        hudProgress.mode = MBProgressHUDMode.determinateHorizontalBar
                        hudProgress.label.text = "正在上传";
                        upload.uploadProgress(closure: { (progress) in
                            hudProgress.progress = Float(progress.completedUnitCount);
                        })
                        
                        upload.responseJSON { response in
                            //print response.result
                            if let json = response.result.value as? NSDictionary {
                                if let data = json["data"] as? NSDictionary {
                                    hudProgress.hide(animated: true);
                                    if let url = data["url"] as? String {
                                        let markDownURL = "\n[![1.png](" + url + ")](" + url + ")";
                                        let msg = NSMutableDictionary.init();
                                        msg["MSGTYPE"] = "InsertContent";
                                        msg["PARAM1"] = markDownURL;
                                        self.vcDelegate?.OnPushVC(msg: msg);
                                        return;
                                    }
                                }
                            }
                            hudProgress.hide(animated: true);
                            self.makeToast("上传图片失败!",duration:1.0,position:.center);
                        }
                        
                    case .failure(let encodingError):
                        print(encodingError);
                        self.makeToast("上传图片失败!",duration:1.0,position:.center);
                    }
                })
                
                
            }
        }
        self.navController?.dismiss(animated: true, completion: nil);
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.navController?.dismiss(animated: true, completion: nil);
    }
}
