//
//  DocumentScanView.swift
//  BufetecAppPrototipo
//
//  Created by Enrique Macias on 9/5/24.
//

import SwiftUI
import AVFoundation

struct DocumentScanView: View {
    @StateObject private var cameraModel = CameraViewModel()
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            // Live Camera Feed
            CameraPreview(session: cameraModel.session)
                .edgesIgnoringSafeArea(.all)

            VStack {
                HStack {
                    Button(action: {
                        // Close the camera view
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Cancelar")
                            .foregroundColor(.blue)
                    }
                    Spacer()
                }
                .padding()

                Spacer()

                // Scanning frame
                Rectangle()
                    .strokeBorder(Color.white, lineWidth: 4)
                    .frame(width: 300, height: 180)
                    .cornerRadius(5)
                    .background(
                        Color.black.opacity(0.7)
                            .mask(Rectangle()
                                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                                .overlay(Rectangle().frame(width: 300, height: 180)
                                    .foregroundColor(.clear)
                                    .cornerRadius(5), alignment: .center)
                            )
                    )

                Spacer()

                // Instruction text
                Text("Escanea el Frente de tu ID")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top)

                Text("Coloca el frente de tu identificación o licencia dentro del marco.\nUsa un área bien iluminada y un fondo oscuro simple.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)
                    .padding(.horizontal)
                    .padding(.bottom, 30)
            }
        }
        .onAppear {
            cameraModel.startSession()
        }
        .onDisappear {
            cameraModel.stopSession()
        }
    }
}

// ViewModel to manage camera session
class CameraViewModel: ObservableObject {
    @Published var session = AVCaptureSession()

    func startSession() {
        let device = AVCaptureDevice.default(for: .video)

        guard let deviceInput = try? AVCaptureDeviceInput(device: device!), session.canAddInput(deviceInput) else {
            return
        }

        session.beginConfiguration()
        session.addInput(deviceInput)

        let output = AVCaptureVideoDataOutput()
        session.addOutput(output)

        session.commitConfiguration()
        session.startRunning()
    }

    func stopSession() {
        session.stopRunning()
    }
}

// SwiftUI wrapper for the camera preview
struct CameraPreview: UIViewRepresentable {
    class CameraPreviewView: UIView {
        override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }

        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
    }

    let session: AVCaptureSession

    func makeUIView(context: Context) -> CameraPreviewView {
        let view = CameraPreviewView()
        view.videoPreviewLayer.session = session
        view.videoPreviewLayer.videoGravity = .resizeAspectFill
        return view
    }

    func updateUIView(_ uiView: CameraPreviewView, context: Context) {}
}


#Preview {
    DocumentScanView()
}
