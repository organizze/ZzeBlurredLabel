//
//  ZzeBlurredLabel.m
//  ZzeBlurredLabel
//
//  Created by Victor Cechinel da Silva Libralato Rabelo on 30/05/17.
//  Copyright © 2017 Organizze. All rights reserved.
//

#import "ZzeBlurredLabel.h"

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
    CGContextRef contextNew = CGBitmapContextCreate(NULL, self.bounds.size.width, self.bounds.size.height,
                                                 CGImageGetBitsPerComponent(cgimg),
                                                 CGImageGetBytesPerRow(cgimg),
                                                 colorspace,
                                                 CGImageGetAlphaInfo(cgimg));
    CGColorSpaceRelease(colorspace);
    
    if (contextNew == NULL) {
        [self.layer setContents:(__bridge id)cgimg];
        CGImageRelease(cgimg);
    } else {
        CGContextDrawImage(contextNew, CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height), cgimg);
        CGImageRef imgRef = CGBitmapContextCreateImage(contextNew);
        CGContextRelease(contextNew);
        [self.layer setContents:(__bridge id)imgRef];
        CGImageRelease(imgRef);
    }
    
}

@end
