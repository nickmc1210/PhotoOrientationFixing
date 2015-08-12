//Code for handling rotating images.
//CIFilters will strip the orientation data from your UIImage. If you have a phot that is spinning after you apply a filter, use this code to preserve the orientation and apply it to the newly filtered image
//The orientation data is in the type of an enumeration UIImageOrientation, with 4 different possibilities: .Up, .Right, .Left, .Down

import UIKit

//myImage has an orientation based on the camera's orientation
var myImage: UIImage? = nil

//preserve the orientation for later
let orientation = myImage?.imageOrientation

//convert to CIImage for filtering
let baseCIImage = myImage?.CIImage

//create my filter
var filter = CIFilter(name: "CISepiaTone")

//set the image value of the filter to my CIImage
filter.setValue(baseCIImage, forKey: kCIInputImageKey)

//set up the context and apply the filter. THIS IS THE SAME CODE FROM CLASS
let context = CIContext(options: nil)

let options = [kCIContextWorkingColorSpace: NSNull()]
let eaglContext = EAGLContext(API: EAGLRenderingAPI.OpenGLES2)
let gpuContext = CIContext(EAGLContext: eaglContext, options: options)

let outputImage = filter.outputImage
let extent = outputImage!.extent()
let cgImage = gpuContext.createCGImage(outputImage, fromRect: extent)

//handle the filtered image
if let filteredImage = UIImage(CGImage: cgImage) {
  
  //create an blank image object
  var rotatedImage = UIImage()
  
  //switch over the possible cases of orientation.
  switch orientation! {
  case .Down: rotatedImage = UIImage(CGImage: filteredImage.CGImage, scale: 1.0, orientation: UIImageOrientation.Down)!
  case .Left: rotatedImage = UIImage(CGImage: filteredImage.CGImage, scale: 1.0, orientation: UIImageOrientation.Left)!
  case .Right: rotatedImage = UIImage(CGImage: filteredImage.CGImage, scale: 1.0, orientation: UIImageOrientation.Right)!
  default: rotatedImage = filteredImage
  }
  
//use the newly rotated image where you need
  rotatedImage
}
