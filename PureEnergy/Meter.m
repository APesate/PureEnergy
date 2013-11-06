//
//  Meter.m
//  PureEnergy
//
//  Created by Andrés Pesate on 11/5/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import "Meter.h"

#define ANGLE 180;
#define ANGLE_DIFFERENCE 15;
#define DEGREES_TO_RADIANS(x) (x*M_PI)/(180);

@implementation Meter{
    NSMutableArray* dotsDisplayedArray;
    
    CGPoint coordinatesToDraw;
    CGFloat radius;
    CGFloat angle;
    int actualConsume;
    int pastMonthConsume;
    int costPerHour;
    int maxNumberOfImages;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        int insetPadding = 30;
        maxNumberOfImages = 12;
        angle = ANGLE;
        dotsDisplayedArray = [NSMutableArray arrayWithCapacity:maxNumberOfImages];
        radius = (self.frame.size.height - insetPadding) / 2;
        [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(dataFromDB) userInfo:Nil repeats:YES];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSMutableArray* pastConsumeArray = [NSMutableArray arrayWithCapacity:maxNumberOfImages];
    int meterDotSize = 30;
    CGFloat angleInRadians;
    CGPoint coordinates;
    CGFloat anglePast = 180.0;

    for (int i = 0; i <= maxNumberOfImages; i++) {
        angleInRadians = DEGREES_TO_RADIANS(anglePast);
        
        coordinates.x = (self.frame.size.height / 2) + ((radius - 30) * (float)cos(angleInRadians));
        coordinates.y = (self.frame.size.height / 2) + ((radius - 30) * (float)sin(angleInRadians));
        
        UIImageView* newImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Dot.png"]];
        [newImage setFrame:CGRectMake(coordinates.x, coordinates.y, meterDotSize - 10, meterDotSize - 10)];
        [newImage setAlpha:0.0];
        
        [self addSubview:newImage];
        
        [UIView animateWithDuration:1.0f animations:^{
            [newImage setAlpha:1.0];
        }];
        
        [pastConsumeArray addObject:newImage];
        
        anglePast += ANGLE_DIFFERENCE;
    }
}


-(void)redrawMeterForActualConsume{
    if ([dotsDisplayedArray count] <= maxNumberOfImages) {
        int meterDotSize = 30;
        CGFloat angleInRadians = DEGREES_TO_RADIANS(angle);
        
        coordinatesToDraw.x = (self.frame.size.height / 2) + (radius * (float)cos(angleInRadians));
        coordinatesToDraw.y = ((self.frame.size.height - 30) / 2) + (radius * (float)sin(angleInRadians));
        
        UIImageView* newImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Dot.png"]];
        [newImage setFrame:CGRectMake(coordinatesToDraw.x, coordinatesToDraw.y, meterDotSize, meterDotSize)];
        [newImage setAlpha:0.0];
        
        [self addSubview:newImage];
        
        [UIView animateWithDuration:1.0f animations:^{
            [newImage setAlpha:1.0];
        }];
        
        [dotsDisplayedArray addObject:newImage];
        
        angle += ANGLE_DIFFERENCE;
    }
}

#pragma mark - Get Data From Server

-(void)dataFromDB{
    //Make Request for consumes
    
    //Meanwhile
    
    [self redrawMeterForActualConsume];
}

@end
