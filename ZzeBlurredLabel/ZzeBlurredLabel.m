//
//  ZzeBlurredLabel.m
//  ZzeBlurredLabel
//
//  Created by Victor Cechinel da Silva Libralato Rabelo on 30/05/17.
//  Copyright © 2017 Organizze. All rights reserved.
//

#import "ZzeBlurredLabel.h"
#import <Accelerate/Accelerate.h>

@implementation ZzeBlurredLabel

- (void)blurryText {
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CIFilter * blurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [blurFilter setDefaults];
    
    CIImage * imageToBlur = [CIImage imageWithCGImage: image.CGImage];
    [blurFilter setValue: imageToBlur forKey: kCIInputImageKey];
    [blurFilter setValue: @(self.blurRadius) forKey:@"inputRadius"];
    
    CIImage * outputImage = blurFilter.outputImage;
    CIContext * context = [CIContext contextWithOptions: nil];
    CGImageRef cgimg = [context createCGImage: outputImage fromRect: [outputImage extent]];
    
    // Resize
    CGColorSpaceRef colorspace = CGImageGetColorSpace(cgimg);
    CGContextRef contextNew = CGBitmapContextCreate(NULL, self.bounds.size.width*2, self.bounds.size.height*2,
                                                 CGImageGetBitsPerComponent(cgimg),
                                                 CGImageGetBytesPerRow(cgimg),
                                                 colorspace,
                                                 CGImageGetAlphaInfo(cgimg));
    CGColorSpaceRelease(colorspace);
    
    if (contextNew == NULL) {
        [self.layer setContents:(__bridge id)cgimg];
        CGImageRelease(cgimg);
    } else {
        CGContextDrawImage(contextNew, CGRectMake(0, 0, self.bounds.size.width*2, self.bounds.size.height*2), cgimg);
        CGImageRef imgRef = CGBitmapContextCreateImage(contextNew);
        CGContextRelease(contextNew);
        [self.layer setContents:(__bridge id)imgRef];
        CGImageRelease(imgRef);
    }
    
}

- (void)newBlurryText {
    
    int boxSize = (int)(self.blurRadius * 100);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL) {
        NSLog(@"No pixelbuffer");
    }
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer,
                                       &outBuffer,
                                       NULL,
                                       0,
                                       0,
                                       boxSize,
                                       boxSize,
                                       NULL,
                                       kvImageEdgeExtend);
    
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    
    [self.layer setContents:(__bridge id)imageRef];
    
    //clean up
    CGImageRelease(imageRef);
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    
}

@end
