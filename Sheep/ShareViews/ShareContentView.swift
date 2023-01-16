//
//  ShareContentView.swift
//  Example
//
//  Created by miuGrey on 2020/7/15.
//

import SwiftUI
import ScreenshotableView
import StoreKit

struct ShareContentView<Content: View>: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var screenImage: ScreenImage?
    @State var share = false
    @State private var showSheet = false
    let viewToShot: Content
    let title: String
    var deviceHeight = UIScreen.main.bounds.height
    var deviceWidth = UIScreen.main.bounds.width
    
    @State var reviewHasShown = false
    func RandomRate(input: CGFloat) {
        //let luckyNum = input.truncatingRemainder(dividingBy: 7)
        if input >= 30 || reviewHasShown == false{
            print("Please Rate")
            reviewHasShown = true
            if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
            }
        }
    }
    
    struct ScreenImage: Identifiable {
        let id = UUID()
        let image: UIImage
    }
    
    var body: some View {
            ZStack {
                ScreenshotableView(shotting: self.$share,
                                   completed: { screenshot in
                    screenImage = ScreenImage(image: screenshot)
                    share = false
                    showSheet = true
                    if screenImage?.image != nil {
                        save(img: screenImage!.image, title: title)
                        share(img: screenImage!.image, title: title)
                    }
                }) {
                    viewToShot
                }
                
                ZStack{
                    VStack {
                        ScrollView {
                            viewToShot
                                .cornerRadius(16)
                        }
                        .frame(height: deviceHeight/1.3)
                        .cornerRadius(16)
                        .scaleEffect(0.8, anchor: .bottom)
                        .padding(.bottom, deviceHeight/25)
                        
                        HStack (spacing: deviceWidth/20) {
                            Button {
                                self.presentationMode.wrappedValue.dismiss()
                            } label: {
                                Text("取消")
                                    .fontWeight(.medium)
                                    .frame(width: deviceWidth/3, height: 60)
                                    .background(Color("BGColor"))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            
                            Button {
                                self.presentationMode.wrappedValue.dismiss()
                                share = true
                            } label: {
                                Text("保存并分享")
                                    .fontWeight(.medium)
                                    .frame(width: deviceWidth/3, height: 60)
                                    .foregroundColor(.white)
                                    .background(Color("AccentColor"))
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                    }
                    .padding(.bottom, deviceHeight/15)
                    HStack {
                        Text("分享预览")
                            .fontWeight(.heavy)
                            .font(.system(size: 36))
                            .padding(.leading, deviceWidth/20)
                            .padding(.top, -deviceHeight/2.4)
                        Spacer()
                    }
                }
                .background(.thinMaterial)
                .frame(width: deviceWidth, height: deviceHeight)
            }
    }
    
    class ImageSaver: NSObject {
        func writeToPhotoAlbum(image: UIImage) {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveError), nil)
        }

        @objc func saveError(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            print("Save finished!")
        }
    }
    
    func save(img: UIImage, title: String) {
        let imageSaver = ImageSaver()
        imageSaver.writeToPhotoAlbum(image: img)
    }
    
    
    func share(img:UIImage, title:String) {
        let fileManager = FileManager.default
        let rootPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first! as NSString
        let filePath = "\(rootPath)/\(title).jpg"
        let imageData = img.jpegData(compressionQuality: 0.8)
        fileManager.createFile(atPath: filePath, contents: imageData, attributes: nil)
        let url:URL = URL.init(fileURLWithPath: filePath)
        let av = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController!.present(av, animated: true, completion: nil)
        //RandomRate(input: CGFloat.random(in: 0...35))
    }
}

struct ShareContentView_Previews: PreviewProvider {
    static var previews: some View {
        ShareContentView(viewToShot: SheepShare(times: 3)
            .environmentObject(TodoListViewModel(testData: false)), title: "小羊日记")
    }
}
