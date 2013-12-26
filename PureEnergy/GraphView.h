//
//  GraphView.h
//  Plot
//
//  Created by Andres Ormaechea on 11/13/13.
//  Copyright (c) 2013 Andres Ormaechea. All rights reserved.
//
#define kGraphHeight 350
#define kDefaultGraphWidth 2000
#define kOffsetX 0
#define kStepX 70
#define kGraphBottom 360 //460
#define kGraphTop 0
#define kStepY 50
#define kOffsetY 10
#define kBarTop 10
#define kBarWidth 40
#define kCircleRadius 3

#import <UIKit/UIKit.h>
#import "Delegate.h"

@interface GraphView : UIView

@property(strong,nonatomic)id<Delegate>delegate;
@property(assign,nonatomic)int scrollerWidth;
@property(strong, nonatomic) NSString* ident;
@property(strong, nonatomic) NSString* serviceType;

-(void)GetInfo;

@end
