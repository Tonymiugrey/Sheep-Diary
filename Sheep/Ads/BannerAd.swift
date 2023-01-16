import GoogleMobileAds
import SwiftUI

class BannerAdVC: UIViewController {
    let adUnitId: String
    
    //Initialize variable
    init(adUnitId: String) {
        self.adUnitId = adUnitId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var bannerView: GADBannerView = GADBannerView() //Creates your BannerView
    override func viewDidLoad() {
        bannerView.adUnitID = adUnitId
        bannerView.rootViewController = self
      
        //Add our BannerView to the VC
        view.addSubview(bannerView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadBannerAd()
    }

    //Allows the banner to resize when transition from portrait to landscape orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate { _ in
            self.bannerView.isHidden = true //So banner doesn't disappear in middle of animation
        } completion: { _ in
            self.bannerView.isHidden = false
            self.loadBannerAd()
        }
    }

    func loadBannerAd() {
        let frame = view.frame.inset(by: view.safeAreaInsets)
        let viewWidth = frame.size.width

        //Updates the BannerView size relative to the current safe area of device (This creates the adaptive banner)
        bannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)

        bannerView.load(GADRequest())
    }
}

struct BannerAd: UIViewControllerRepresentable {
    let adUnitId: String
    
    init(adUnitId: String) {
        self.adUnitId = adUnitId
    }
    
    
    func makeUIViewController(context: Context) -> BannerAdVC {
        return BannerAdVC(adUnitId: adUnitId)
    }

    func updateUIViewController(_ uiViewController: BannerAdVC, context: Context) {
        
    }
}

struct SwiftUIBannerAd: View {
    @State var height: CGFloat = 0 //Height of ad
    @State var width: CGFloat = 0 //Width of ad
    @State var adPosition: AdPosition
    let adUnitId: String
    
    init(adPosition: AdPosition, adUnitId: String) {
        self.adPosition = adPosition
        self.adUnitId = adUnitId
    }
    
    enum AdPosition {
        case top
        case bottom
    }
    
    public var body: some View {
        VStack {
            if adPosition == .bottom {
                Spacer() //Pushes ad to bottom
            }
            
            //Ad
            BannerAd(adUnitId: adUnitId)
                .frame(width: width, height: height, alignment: .center)
                .onAppear {
                    //Call this in .onAppear() b/c need to load the initial frame size
                    //.onReceive() will not be called on initial load
                    setFrame()
                }
                //Changes the frame of the ad whenever the device is rotated.
                //This is what creates the adaptive ad
                .onReceive(NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)) { _ in
                    setFrame()
                }
            
            if adPosition == .top {
                Spacer() //Pushes ad to top
            }
        }
    }
    
    func setFrame() {
      
        //Get the frame of the safe area
        let safeAreaInsets = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.safeAreaInsets ?? .zero
        let frame = UIScreen.main.bounds.inset(by: safeAreaInsets)
        
        //Use the frame to determine the size of the ad
        let adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(frame.width)
        
        //Set the ads frame
        self.width = adSize.size.width
        self.height = adSize.size.height
    }
}
