// UIImage+Resize.h
// Created by Trevor Harmon on 8/5/09.
// Free for personal or commercial use, with or without modification.
// No warranty is expressed or implied.

// Extends the UIImage class to support resizing/cropping
@interface UIImage (Resize)

- (UIImage *)croppedImage:(CGRect)bounds;

- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImage:(CGSize)newSize
                transform:(CGAffineTransform)transform
           drawTransposed:(BOOL)transpose
     interpolationQuality:(CGInterpolationQuality)quality;
- (CGAffineTransform)transformForOrientation:(CGSize)newSize;

/**
 *  获取当前图片的以当前中心点的正方形图片
 *
 *  @return 截取的目标正方形的图片
 */
- (UIImage *)getSquareImageWith:(CGFloat)maxWidth;
- (UIImage *)getImageBigWidth:(CGSize)pSize;
- (UIImage *)getImageBigHeight:(CGSize)pSize;
/*
 *根据图片url获取图片尺寸
 *
 */
+(CGSize)getImageSizeWithURL:(id)imageURL;
/*
 *主要功能是对于不合规定大小或者比例的图片裁剪中间部分，或者按比例缩小
 * originalImage： 原始图片  size： 需要大小
 */
+ (UIImage *)handleImage:(UIImage *)originalImage withSize:(CGSize)size;

/*
 * 限制图片大小
 */
+ (UIImage *)reSizeImageData:(UIImage *)sourceImage maxImageSize:(CGFloat)maxImageSize maxSizeWithKB:(CGFloat) maxSize;

@end
