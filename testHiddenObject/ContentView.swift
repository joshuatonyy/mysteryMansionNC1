import SwiftUI
import SpriteKit
import AVKit
import AVFoundation
import Foundation
import Lottie
import GameplayKit

class MusicPlayer {
    static let shared = MusicPlayer()
    var audioPlayer: AVAudioPlayer?

    func startBackgroundMusic(backgroundMusicFileName: String) {
        if let bundle = Bundle.main.path(forResource: backgroundMusicFileName, ofType: "mp3") {
            let backgroundMusic = NSURL(fileURLWithPath: bundle)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf:backgroundMusic as URL)
                guard let audioPlayer = audioPlayer else { return }
                audioPlayer.numberOfLoops = -1
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch {
                print(error)
            }
        }
    }
    func stopBackgroundMusic() {
        guard let audioPlayer = audioPlayer else { return }
        audioPlayer.stop()
    }
}


struct PlayerView: UIViewRepresentable {
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PlayerView>) {
    }

    func makeUIView(context: Context) -> UIView {
        return LoopingPlayerUIView(frame: .zero)
    }
}
func playmusic(){
    MusicPlayer.shared.startBackgroundMusic(backgroundMusicFileName: "bg")
}


class LoopingPlayerUIView: UIView {
    private let playerLayer = AVPlayerLayer()
    private var playerLooper: AVPlayerLooper?
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        // Load the resource -> h
        let fileUrl = Bundle.main.url(forResource: "Main Page", withExtension: "mp4")!
        let asset = AVAsset(url: fileUrl)
        let item = AVPlayerItem(asset: asset)
        // Setup the player
        let player = AVQueuePlayer()
        let controller = AVPlayerViewController()
        playerLayer.player = player
//        playerLayer.videoGravity = .resizeAspectFill
        controller.videoGravity = .resizeAspectFill
        layer.addSublayer(playerLayer)

        // Create a new player looper with the queue player and template item
        playerLooper = AVPlayerLooper(player: player, templateItem: item)
        // Start the movie
        player.play()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
extension Color {
  init(_ hex: UInt, alpha: Double = 1) {
    self.init(
      .sRGB,
      red: Double((hex >> 16) & 0xFF) / 255,
      green: Double((hex >> 8) & 0xFF) / 255,
      blue: Double(hex & 0xFF) / 255,
      opacity: alpha
    )
  }
}

struct TitleScreenView: View {
    let red = Color(0xFF0000)
    let green = Color(0x578883)
    let translucentMagenta = Color(0xFF00FF, alpha: 0.4)
    @State private var gameEnded = false
    @State private var showCreditsAlert = false
    let backgroundGradient = LinearGradient(
        colors: [Color.red, Color.blue],
        startPoint: .top, endPoint: .bottom)
    
    
    
    var body: some View {
        //LottieView(name: "Main Page", loopMode: .loop)
        //.frame(width: 350, height: 850)
        GeometryReader{ geo in
            ZStack {
                
                PlayerView()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: UIScreen.main.bounds.width, height: geo.size.height+100)
                    .edgesIgnoringSafeArea(.all)
                    .overlay(Color.black.opacity(0.2))
                    .blur(radius: 1)
                    .edgesIgnoringSafeArea(.all)
                
                
                
            }
            
            VStack {
//                Spacer()
//                Text("Mystery Mansion")
//                    .font(.custom("Old Charlotte", size: 41))
//                    .fontWeight(.bold)
//                    .padding(.bottom, 210)
//                    .foregroundColor(green)
//                    .shadow(radius: 17)
//                    .padding(.leading, 60)
                Image("Game Title").resizable()
                    .frame(width: 235, height: 98, alignment: .center)
                    .scaledToFit()
                    .padding(.top, 220).padding(.leading, 90).padding(.bottom, 250)
                Spacer()
                    Button(action: {
                        navigateToPrologueView()
                        playmusic()
                    }){
                        Text("Start Game")
                            .foregroundColor(.white)
                            .font(.custom("Old Charlotte", size: 31))
                            .padding(.vertical, 10)
                            .padding(.horizontal, 50)
                            .background(green)
                        .cornerRadius(10)
                        .padding(.leading, 60)
                    }
                    
                    
                    Button(action: {
                        showCreditsAlert = true
                    }) {
                        Text("Credits")
                            .foregroundColor(.white)
                            .font(.custom("Old Charlotte", size: 27))
                            .padding(.bottom, 20)
                            .padding(.top, 10)
                            .padding(.leading, 60)
                    }
                    .alert(isPresented: $showCreditsAlert) {
                        Alert(title: Text("Developed by:"), message: Text("Joshua Tony, William Kindlien, Edric Christan.Apple Developer Academy Cohort 6"), dismissButton: .default(Text("OK")))
                    }
                

                .padding()
                Spacer()
                

            }
            
            
        }
        
    }
   
}

struct PrologueView: View {
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    @State private var imageIndex = 0
    @State private var currentDialogueIndex = 0
    let dialogues = [
        "You are a detective that has solved many murders in your lifetime. Suddenly you got a call from an unknown caller, where she told you that there is a murder in a mansion located in the southwest area.  The victim is the owner of the mansion. She promised to pay you handsomely if you can solve the murder.",
        "Intrigued by this you marched into the mansion to investigate. You arrived to the mansion and greeted by a horrendous scene. All the items are scattered all around the murder scene.",
        "The victim was Mr. Giovanni Ernesto,a successful real estate businessman who just retired. He was famous for mocking lower wages worker who works for him.",
        "You have to find the missing items to reconstruct the scene and find the killer.",
        "Suspect 1 : Mr.Louis Chandler\n\nOccupation: Chef\n\nBackground: Louis Chandler is an ex 5 star celebrity chef. Right now he works as the mansion sole chef that is responsible for all the food in the mansion. Has a wife and 2 children.",

        "Motive: He was blackmailed out of his last work by Mr Giovanni with the intention of making him work for him by threatening to release pictures of his secret affair.\n\nAlibi: At the time of the murder, Mr. Louis said that he was cooking for Mr Ernesto",
        "Suspect 2 : Mr. Jose Fring\n\nOccupation: Gardener\n\nBackground: Jose Fring is an ex homeless person who has many criminal background. Right now he works as gardener for the mansion",

        "Motive: He owes money to many loan sharks and Mr Giovanni because of morphine addiction, wanting to steal Mr Giovannis money.\n\nAlibi: Mr Jose said that he was in the worker’s bathroom at the time of the murder.",
        "Suspect 3 : Mr. Luca Tony\n\nOccupation: Butler\n\nBackground: Luca Tony is a renown butler who worked in multiple mansions all across the country. He works as Mr. Ernesto’s personal butler.",

        "Motive: Luca Tony is a renown butler who worked in multiple mansions all across the country. He works as Mr. Ernesto’s personal butler.\n\nAlibi: Mr Luca said that he was on a smoking break at the time of the murder.",
        "Suspect 4 : Mrs. Lily Ernesto\n\nThe victim's wife\n\nBackground: Mrs. Ernesto is an ex professional model. She met Mr Ernesto when she walked in a Southwest runaway.",

        "Motive: She was forced to go through abortion by Mr Giovanni because he thought that the child wasn’t his. Stuck in an abusive marriage with Mr Giovanni and is looking for an escape from her unhappy marriage.\n\nAlibi: At the time of the murder Mrs. Lily said that he was sleeping in the main bedroom",
        "Gameplay Tutorial: Find the hidden items to deduce who the killer is.\n\nSlide up the magnifying glass on the bottom right of the screen to check the list of suspect's information and deduce the killer once all 4 hidden items are found.\n\nItem clues can be found on the top right button of the game only after 120 seconds of gameplay. \n\nYour selection of the killer impacts the ending of the game so choose carefully, good luck!"
        
    ]
    
    
    var body: some View {
        let images = [
            "Rectangle","house","house","house","Chef","Chef","Gardener",
                    "Gardener","Butler","Butler","Wife","Wife",
                    "Rectangle"
                ]
        ZStack {
            
            Image(images[imageIndex])
                           .resizable()
                //.scaledToFit()
                           .frame(width:UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            VStack {
                
                
                Spacer()
                Text(dialogues[currentDialogueIndex])
                    .font(.custom("Groteska-Book", size: 17))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                   
                    .padding(.trailing, 70.0)
                
                
                Button(action: {
                    if currentDialogueIndex < dialogues.count - 1 {
                        currentDialogueIndex += 1
                    } else {
                        navigateToGameView()
                    }
                   
                    imageIndex = (imageIndex + 1) % images.count
                }) {
                    Text(currentDialogueIndex < dialogues.count - 1 ? " " : " ")
                    Image(uiImage: self.resizeImage(image: UIImage(named: "knife11")!, targetSize: CGSizeMake(65.0, 65.0)))
                        .padding(.leading, 250.0)
                    
                }
               
            }
            
            
        .padding()
        }
        .background(Image("BG"))
        Spacer()
        
    }
    
    func navigateToGameView() {
        let gameView = GameView()
        let gameViewWrappedInNavigation = NavigationView { gameView }
        UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: gameViewWrappedInNavigation)
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
func navigateToPrologueView() {
    let proView = PrologueView()
    let proViewWrappedInNavigation = NavigationView { proView }
    UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: proViewWrappedInNavigation)
    UIApplication.shared.windows.first?.makeKeyAndVisible()
    
}
struct PopUpView: View {
    @Binding var isPresented: Bool
    @State var selectedSuspect: String?
    @State private var isAlibiViewPresented = false
    @State private var isAllItemsFound = true
    let green = Color(0x578883)
    var itemcount = 4
    let suspects = ["Mr. Louis Chandler(Chef)", "Mr. Jose Fring(Gardener)", "Mr. Luca Tony(Butler)", "Mrs. Lily Ernesto(Wife)"]
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
            VStack {
                Text("Items Clues:")
                    .font(.title).foregroundColor(.black)
                Text("• Memories\n• To Serve Food\n• Medical Instrument\n• Small Piece of Chloth ")
                    .padding(.bottom).foregroundColor(.black)
                Divider()
                HStack {
                    Button(action: {
                                       self.isAlibiViewPresented = true
                                   }, label: {
                                       Text("Check Suspects").font(.headline)
                                   })
                                   .sheet(isPresented: self.$isAlibiViewPresented, content: {
                                       AlibiView()
                                   })
                    .padding()
                    .foregroundColor(.white)
                    .background(green)
                    .cornerRadius(20)
                    .padding(.trailing)
                    
                    Button(action: {
                        // Show the list of suspects for deduction
                        self.selectedSuspect = self.suspects.first
                        
                        
                    }) {
                        Text("Deduct")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.red)
                    .cornerRadius(20)
                    .padding(.leading)
                    .disabled(!isAllItemsFound) // disable the button if not all items are found
                }
                .padding(.bottom)
                
                if let suspect = self.selectedSuspect {
                    VStack {
                        Text("Select the killer:")
                            .font(.title)
                            .padding().foregroundColor(.black)
                        
                        ForEach(suspects, id: \.self) { name in
                            Button(action: {
                                self.selectedSuspect = name
                            }) {
                                HStack {
                                    Text(name)
                                        .font(.headline).foregroundColor(.black)
                                    if name == suspect {
                                        Spacer()
                                        Image(systemName: "checkmark").foregroundColor(.black)
                                    }
                                }
                                .padding()
                                .foregroundColor(.primary)
                            }
                        }
                        Button(action: {
                            if selectedSuspect == "Mr. Louis Chandler(Chef)" {
                           gamegood()
                            } else {
                                // Navigate to bad ending view
                               gamebad()
                            }
                        }) {
                            Text("Choose the killer")
                                .foregroundColor(.white)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 25)
                                .background(green)
                                .cornerRadius(20)
                        }

                    }
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding()
                    
                }
            }
            .background(Color.white)
            .cornerRadius(20)
            .padding()
        }
        .onTapGesture {
            // Dismiss the pop-up if tapped outside
            self.isPresented = false
        }
    }
    private func checkAllItemsFound() {
            if itemcount == 4 //or if object in array is null or 0
        {
                isAllItemsFound = true
            } else {
                isAllItemsFound = false
            }
        }
}
struct AlibiView: View {
    let green = Color(0x578883)
    var body: some View {
        VStack {
            Text("Suspect Information").font(.title)
            Divider()
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Mr. Louis Chandler (Chef)").font(.headline)
                        .padding(.bottom, 2.0)
                        .foregroundColor(green)
                    Text("Background: Louis Chandler is an ex 5 star celebrity chef. Right now he works as the mansion sole chef that is responsible for all the food in the mansion. Has a wife and 2 children\n\nMotive: He was blackmailed out of his last work by Mr Giovanni with the intention of making him work for him by threatening to release pictures of his secret affair.\n\nAlibi: At the time of the murder, Mr. Louis said that he was cooking for Mr Ernesto")
                        .padding(.bottom, 20.0)
                        .foregroundColor(green)
                    Text("Mr. Jose Fring (Gardener)").font(.headline) .padding(.bottom, 2.0)
                        .foregroundColor(green)
                    Text("Background:Jose Fring is an ex homeless person who has many criminal background. Right now he works as gardener for the mansion\n\nMotive:He owes money to many loan sharks and Mr Giovanni because of morphine addiction, wanting to steal Mr Giovannis money.\n\nAlibi:Mr Jose said that he was in the worker’s bathroom at the time of the murder.")
                        .padding(.bottom, 20.0)
                        .foregroundColor(green)
                
                    
                    Text("Mr. Luca Tony(Butler)").font(.headline) .padding(.bottom, 2.0)
                        .foregroundColor(green)
                    Text("Background:Luca Tony is a renown butler who worked in multiple mansions all across the country. He works as Mr. Ernesto’s personal butler.\n\nMotive:Luca Tony is a renown butler who worked in multiple mansions all across the country. He works as Mr. Ernesto’s personal butler.\n\nAlibi:Mr Luca said that he was on a smoking break at the time of the murder.").padding(.bottom, 20.0)
                        .foregroundColor(green)
                    
                    Text("Mrs. Lily Ernesto(Wife)").font(.headline) .padding(.bottom, 2.0)
                        .foregroundColor(green)
                    Text("Background:Mrs. Ernesto is an ex professional model. She met Mr Ernesto when she walked in a Southwest runaway.\n\nMotive:She was forced to go through abortion by Mr Giovanni because he thought that the child wasn’t his. Stuck in an abusive marriage with Mr Giovanni and is looking for an escape from her unhappy marriage.\n\nAlibi:At the time of the murder Mrs. Lily said that she was sleeping in the main bedroom.").padding(.bottom, 20.0)
                        .foregroundColor(green)
                }
                .padding()
            }
            
        }
    }
}

struct GameView: View {
    var scene: SKScene {
        let scene = GameScene()
        scene.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        scene.scaleMode = .fill
        return scene
    }
//    func makeUIView(context: Context) -> SKView {
//            let view = SKView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//            view.ignoresSiblingOrder = true
//            view.showsFPS = true
//            view.showsNodeCount = true
//            return view
//        }
//
//        func updateUIView(_ uiView: SKView, context: Context) {
//            // Load the SKScene from 'GameScene.sks'
//            if let scene = SKScene(fileNamed: "GameScene") {
//                // Set the scale mode to scale to fit the window
//                scene.scaleMode = .aspectFill
//
//                // Present the scene
//                uiView.presentScene(scene)
//            }
//        }

    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    @State var didGuessCorrectSuspect = false
    
    @State private var offset = CGSize.zero
    @State private var isDragging = false
    @State private var isPopUpPresented = false
    @State private var showHintsButton = false
       @State private var showHints = false
       @State private var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
       @State private var secondsElapsed = 0
       
       var hints = ["An object is near the table(Plate)", "An object is near the papers(Photo)", "An object is near the chair(Napkin)", "An object is near the bottom cabinet(Black Syringe)"]
    
    var body: some View {
        ZStack {
//            SpriteKitContainer(scene: SpriteScene())
            SpriteView(scene: scene)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                .ignoresSafeArea()
            
            
            VStack {
                if showHintsButton {
                    HStack {
                        Spacer()
                        Button(action: {
                            showHints.toggle()
                        }, label: {
                            Image(uiImage: self.resizeImage(image: UIImage(named: "Hint Icon")!, targetSize: CGSize(width: 50.0, height: 50.0)))
                                .foregroundColor(.yellow
                                    )
                                
                        })
                       
                        .padding()
                        .padding(.trailing, 7.0).padding(.top, 20)
                        
                    }
                }
                
                
                Spacer()
                
//                Image(uiImage: self.resizeImage(image: UIImage(named: "Swipe Icon")!, targetSize: CGSize(width: 10.0, height: 10.0)))
//                    .multilineTextAlignment(.trailing)
//                    .padding(.leading, 250.0)
//                    .padding(.trailing, 7.0)
                
                Image(uiImage: self.resizeImage(image: UIImage(named: "glass")!, targetSize: CGSize(width: 75.0, height: 75.0)))
                    .padding(.leading, 250.0)
                    .frame(width: 75, height: 75).padding(.bottom, 115)
                    .scaleEffect(isDragging ? 1.5 : 1)
                    .offset(offset)
                    .gesture(
                        DragGesture(minimumDistance: 50)
                            .onChanged { gesture in
                                offset = gesture.translation
                                isDragging = true
                            }
                            .onEnded { gesture in
                                offset = .zero
                                isDragging = false
                                if gesture.translation.height < 0 {
                                    isPopUpPresented = true
                                }
                            }
                    )
                    .sheet(isPresented: $isPopUpPresented) {
                        PopUpView(isPresented: $isPopUpPresented)
                    }
            }
            .onReceive(timer) { _ in
                if secondsElapsed < 120 {
                    secondsElapsed += 1
                } else {
                    showHintsButton = true
                    timer.upstream.connect().cancel()
                }
            }
            .sheet(isPresented: $showHints, content: {
                VStack {
                    List(hints, id: \.self) { hint in
                        Text(hint)
                    }
                    Button(action: {
                        showHints.toggle()
                    }, label: {
                        Text("Close")
                    })
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 10)
            })
        }
    }
}

struct TitleScreenView_Previews: PreviewProvider {
    static var previews: some View {
        TitleScreenView()
        //GameView ()
    }
}

struct GoodEndingPageView: View {
    
        
        func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
            let size = image.size
            
            let widthRatio  = targetSize.width  / size.width
            let heightRatio = targetSize.height / size.height
            
            // Figure out what our orientation is, and use that to form the rectangle
            var newSize: CGSize
            if(widthRatio > heightRatio) {
                newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
            } else {
                newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
            }
            
            // This is the rect that we've calculated out and this is what is actually used below
            let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
            
            // Actually do the resizing to the rect using the ImageContext stuff
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return newImage!
        }
        @State private var imageIndex = 0
        @State private var currentDialogueIndex = 0
        let dialogues = [
            "Mr. Louis Chandler stumbles his words, soon after he tried to run. Luckily you could catch him and apprehend him to the police. He told the police that the reason why he murdered the mansion owner is that he was angry that his life of a celebrity chef was taken from him","Congratulations, you've solved the mystery and brought the culprit to justice! You're a hero!"
            
        ]
        
        
        var body: some View {
            let green = Color(0x578883)
            let images = [
                        "Chef",
                     
                        "house"
                    ]
            ZStack {
                Image(images[imageIndex])
                               .resizable()
                               .scaledToFit()
                               .frame(width:UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                VStack {
                    
                   
                    Spacer()
                    Text(dialogues[currentDialogueIndex])
                        .font(.custom("Groteska-Book", size: 17))
                        .foregroundColor(.white)
                        
                        .multilineTextAlignment(.leading)
                       
                        .padding(.trailing, 70.0)
                    
                    
                    Button(action: {
                        if currentDialogueIndex < dialogues.count - 1 {
                            currentDialogueIndex += 1
                        } else {
                            gameend1()
                        }
                       
                        imageIndex = (imageIndex + 1) % images.count
                    }) {
                        Text(currentDialogueIndex < dialogues.count - 1 ? " " : " ")
                        Image(uiImage: self.resizeImage(image: UIImage(named: "knife11")!, targetSize: CGSizeMake(65.0, 65.0)))
                            .padding(.leading, 250.0)
                        
                    }
                   
                }
                
                
            .padding()
            }
            .background(Image("BG"))
            Spacer()
            
        }
        
        func navigateToGameView() {
            let gameView = GameView()
            let gameViewWrappedInNavigation = NavigationView { gameView }
            UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: gameViewWrappedInNavigation)
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
    


struct BadEndingPageView: View {
    
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    @State private var imageIndex = 0
    @State private var currentDialogueIndex = 0
    let dialogues = [
        "You thought that you had apprehend the right suspect. The evidence found didn't support your verdict and you were relieved from duty, the killer is on the run to claim more lives","You chose the wrong suspect and got the bad ending , better luck next time!"
        
    ]
    
    
    var body: some View {
        let green = Color(0x578883)
        let images = [
                    "win",
                    "house"
                    
                ]
        ZStack {
//            Image(images[imageIndex])
//                           .resizable()
//                           .scaledToFit()
//                           .frame(width:UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            VStack(spacing: 0){
                Image("BG Detective").resizable()
                    .scaledToFill().ignoresSafeArea()
            }
            Image("Detective").resizable()
                .scaledToFill()
            VStack {
                
               
                Spacer()
                Text(dialogues[currentDialogueIndex])
                    .font(.custom("Groteska-Book", size: 17))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading).padding(.trailing, 70.0).padding(.bottom, 60)
                
                
                Button(action: {
                    if currentDialogueIndex < dialogues.count - 1 {
                        currentDialogueIndex += 1
                    } else {
                        gameend1()
                    }
                   
                    imageIndex = (imageIndex + 1) % images.count
                }) {
                    Text(currentDialogueIndex < dialogues.count - 1 ? " " : " ")
                        
                    Image(uiImage: self.resizeImage(image: UIImage(named: "knife11")!, targetSize: CGSizeMake(65.0, 65.0)))
                        .padding(.leading, 250.0)
                    
                    
                }
               
            }
            
            
        .padding()
        }
        .background(Image("BG"))
        Spacer()
        
    }
    
    func navigateToGameView() {
        let gameView = GameView()
        let gameViewWrappedInNavigation = NavigationView { gameView }
        UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: gameViewWrappedInNavigation)
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}


//struct EpiloguePageView: View {
   // @Binding var didGuessCorrectSuspect: Bool
    
   // var body: some View {
     //   VStack {
       //     Text("Congratulations! You've solved the mystery!")
         //   if didGuessCorrectSuspect {
           //     Text("You guessed the correct suspect!")
             //   NavigationLink(destination: GoodEndingPageView()) {
               //     Text("See the good ending")
                //}
            //} else {
              //  Text("You got the wrong person!")
               // NavigationLink(destination: BadEndingPageView()) {
                 //   Text("See the bad ending")
                //}
            //}
      //  }
    //}
//}
func gameend1() {
    
    let tilView = TitleScreenView()
    let tilViewWrappedInNavigation = NavigationView { tilView }
    UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: tilViewWrappedInNavigation)
    UIApplication.shared.windows.first?.makeKeyAndVisible()
}
func gamegood() {
    
    let gudView = GoodEndingPageView()
    let gudViewWrappedInNavigation = NavigationView { gudView }
    UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: gudViewWrappedInNavigation)
    UIApplication.shared.windows.first?.makeKeyAndVisible()
}
func gamebad() {
    
    let badView = BadEndingPageView()
    let badViewWrappedInNavigation = NavigationView { badView }
    UIApplication.shared.windows.first?.rootViewController = UIHostingController(rootView: badViewWrappedInNavigation)
    UIApplication.shared.windows.first?.makeKeyAndVisible()
}

//
