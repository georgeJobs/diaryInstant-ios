//
//  MyScrollView.m
//  DiaryInstant
//
//  Created by George on 2019/3/19.
//  Copyright © 2019 George. All rights reserved.
//

#import "MyScrollView.h"

@implementation MyScrollView

#pragma mark - 解决手势冲突
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer.state != 0) {
        return YES;
    } else {
        return NO;
    }
}

@end
