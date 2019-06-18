//
//  UIShadow+UIView.m
//  PageTest
//
//  Created by xiao can on 2019/6/11.
//  Copyright © 2019 xiaocan. All rights reserved.
//

#import "UIShadow+UIView.h"
#import <objc/runtime.h>

//key
static NSString *const XC_SHADOW_LAYER          = @"xc_shadow_layer";
static NSString *const XC_SHADOW_RADIUS         = @"xc_shadow_radius";
static NSString *const XC_SHADOW_CORNER_RADIUS  = @"xc_shadow_corner_radius";
static NSString *const XC_SHADOW_COLOR          = @"xc_shadow_color";
static NSString *const XC_SHADOW_OFFSET         = @"xc_shadow_offset";
static NSString *const XC_SHADOW_PATH           = @"xc_shadow_path";
static NSString *const XC_SHADOW_OPACITY        = @"xc_shadow_opacity";
static NSString *const XC_SHADOW_SHOW           = @"xc_shadow_show";


//default shadow value
#define  XC_RADIUS            3.0f
#define  XC_CORNER_RADIUS     6.0f
#define  XC_OPACITY           1.0f
#define  XC_OFFSET            CGSizeZero
#define  XC_COLOR             [UIColor redColor]



@implementation UIView(UIShadow_UIImageView)

static inline void shadow_image_exchangeMethod(Method m1,Method m2){
    method_exchangeImplementations(m1, m2);
}

static inline BOOL shadow_addInstanceMethod(Class cls,SEL select){
    return class_addMethod(cls, select, class_getMethodImplementation(cls, select), method_getTypeEncoding(class_getInstanceMethod(cls, select)));
}

static inline BOOL shadow_addClassMethod(Class cls,SEL select){
    return class_addMethod(cls, select, class_getMethodImplementation(cls, select), method_getTypeEncoding(class_getClassMethod(cls, select)));
}


+ (void)load{
    Class class = [self class];
    shadow_image_exchangeMethod(class_getInstanceMethod(class, @selector(initWithFrame:)), class_getInstanceMethod(class, @selector(shadow_initWithFrame:)));
    shadow_image_exchangeMethod(class_getInstanceMethod(class, @selector(layoutSubviews)), class_getInstanceMethod(class, @selector(shadow_layoutSubViews)));
    shadow_image_exchangeMethod(class_getInstanceMethod(class, @selector(setHidden:)), class_getInstanceMethod(class, @selector(shadow_setHidden:)));
    
    shadow_image_exchangeMethod(class_getInstanceMethod(class, @selector(didMoveToSuperview)), class_getInstanceMethod(class, @selector(shadow_didMoveToSuperview)));
    shadow_image_exchangeMethod(class_getInstanceMethod(class, @selector(removeFromSuperview)), class_getInstanceMethod(class, @selector(shadow_removeFromSuperview)));
    shadow_image_exchangeMethod(class_getInstanceMethod(class, NSSelectorFromString(@"dealloc")), class_getInstanceMethod(class, @selector(shadow_dealloc)));
    
    shadow_addInstanceMethod(class, @selector(showShadowLayer));
    shadow_addInstanceMethod(class, @selector(removeShadowLayer));
    shadow_addInstanceMethod(class, @selector(showDefaultShadow));
}


#pragma mark- values
- (void)setShadow_layer:(CALayer *)shadow_layer{
    objc_setAssociatedObject(self, &XC_SHADOW_LAYER, shadow_layer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CALayer *)shadow_layer{
    return objc_getAssociatedObject(self, &XC_SHADOW_LAYER);
}

- (void)setShadow_color:(UIColor *)shadow_color{
    self.shadow_layer.shadowColor = shadow_color.CGColor;
    objc_setAssociatedObject(self, &XC_SHADOW_COLOR, shadow_color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)shadow_color{
    return objc_getAssociatedObject(self, &XC_SHADOW_COLOR);
}

- (void)setShadow_path:(CGPathRef)shadow_path{
    self.shadow_layer.shadowPath = shadow_path;
    objc_setAssociatedObject(self, &XC_SHADOW_PATH, (__bridge id _Nullable)(shadow_path), OBJC_ASSOCIATION_ASSIGN);
}

- (CGPathRef)shadow_path{
    return (__bridge CGPathRef _Nullable)(objc_getAssociatedObject(self, &XC_SHADOW_PATH));
}

- (void)setShadow_offset:(CGSize)shadow_offset{
    self.shadow_layer.shadowOffset = shadow_offset;
    objc_setAssociatedObject(self, &XC_SHADOW_OFFSET, NSStringFromCGSize(CGSizeZero), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGSize)shadow_offset{
    NSString *size = objc_getAssociatedObject(self, &XC_SHADOW_OFFSET);
    CGSize offset = CGSizeZero;
    if (size && [size isKindOfClass:[NSString class]]) {
        offset = CGSizeFromString(size);
    }
    return offset;
}

- (void)setShadow_radius:(CGFloat)shadow_radius{
    self.shadow_layer.shadowRadius = shadow_radius;
    objc_setAssociatedObject(self, &XC_SHADOW_OFFSET, [NSNumber numberWithFloat:shadow_radius], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)shadow_radius{
    return [objc_getAssociatedObject(self, &XC_SHADOW_OFFSET) floatValue];
}

- (void)setShadow_opacity:(CGFloat)shadow_opacity{
    self.shadow_layer.shadowOpacity = shadow_opacity;
    objc_setAssociatedObject(self, &XC_SHADOW_OPACITY, [NSNumber numberWithFloat:shadow_opacity], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)shadow_opacity{
    return [objc_getAssociatedObject(self, &XC_SHADOW_OPACITY) floatValue];
}

- (void)setShadow_corner_radius:(CGFloat)shadow_corner_radius{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = shadow_corner_radius;
    self.shadow_layer.cornerRadius = shadow_corner_radius;
    objc_setAssociatedObject(self, &XC_SHADOW_CORNER_RADIUS, [NSNumber numberWithFloat:shadow_corner_radius], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)shadow_corner_radius{
    return [objc_getAssociatedObject(self, &XC_SHADOW_CORNER_RADIUS) floatValue];
}

- (void)setShowShadowLayer:(BOOL)showShadowLayer{
    objc_setAssociatedObject(self, &XC_SHADOW_SHOW, [NSNumber numberWithBool:showShadowLayer], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    showShadowLayer?[self showShadowLayer]:[self removeShadowLayer];
}

#pragma mark- functions

- (BOOL)isShowShadowLayer{
    return [objc_getAssociatedObject(self, &XC_SHADOW_SHOW) boolValue];
}

- (void)shadow_setHidden:(BOOL)hid{
    [self shadow_setHidden:hid];
    self.shadow_layer.hidden = hid;
}

- (void)shadow_layoutSubViews{
    [self shadow_layoutSubViews];
    [self shadow_layer_valchanged];
}

- (void)shadow_didMoveToSuperview{
    [self shadow_didMoveToSuperview];
    if ([self isShowShadowLayer]) {
        [self showShadowLayer];
    }else{
        [self removeShadowLayer];
    }
}

- (void)shadow_dealloc{
    if (self.shadow_layer) {
        [self.shadow_layer removeFromSuperlayer];
        self.shadow_layer = nil;
    }
    [self shadow_dealloc];
}

- (void)shadow_removeFromSuperview{
    if (self.shadow_layer) {
        [self.shadow_layer removeFromSuperlayer];
    }
    [self shadow_removeFromSuperview];
}


- (instancetype)shadow_initWithFrame:(CGRect)frame{
    
    //init shadow_layer
    self.shadow_layer = [CALayer layer];
    self.shadow_layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.shadow_layer.frame = frame;
    
    //set default value
    self.shadow_color = [UIColor clearColor];
    self.shadow_opacity = 0.0f;
    self.shadow_offset = CGSizeZero;
    self.shadow_radius = 0.0f;
    self.shadow_corner_radius = 0.0f;
    
    return [self shadow_initWithFrame:frame];
    
}

//set default shadow
- (void)showDefaultShadow{
    //set default value
    self.shadow_color = XC_COLOR;
    self.shadow_opacity = XC_OPACITY;
    self.shadow_offset = XC_OFFSET;
    self.shadow_radius = XC_RADIUS;
    self.shadow_corner_radius = XC_CORNER_RADIUS;

    self.shadow_layer.frame = self.frame;
    self.showShadowLayer = YES;
}


//show shadow
- (void)showShadowLayer{
    self.shadow_layer.frame = self.frame;
    [self.shadow_layer removeFromSuperlayer];
    if (self.superview) {
        [self.superview.layer insertSublayer:self.shadow_layer below:self.layer];
    }
}

//remove shadow
- (void)removeShadowLayer{
    if (self.shadow_layer) {
        [self.shadow_layer removeFromSuperlayer];
    }
}

- (void)shadow_layer_valchanged{
    if (self.shadow_layer) {
        self.shadow_layer.frame = self.frame;
    }
}


@end
