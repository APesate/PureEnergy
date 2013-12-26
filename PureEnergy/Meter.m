//
//  Meter.m
//  PureEnergy
//
//  Created by Andrés Pesate on 11/5/13.
//  Copyright (c) 2013 Andrés Pesate. All rights reserved.
//

#import "Meter.h"

#define ANGLE 0;
#define ANGLE_DIFFERENCE 15;
#define DEGREES_TO_RADIANS(x) (x*M_PI)/(180);

@implementation Meter{
    
    UIImageView* meterMaskImage;
    UILabel* actualConsumeLabel;
    UILabel* consumeUnit;
    UILabel* actualConsumeConstLabel;
    CGPoint coordinatesToDraw;
    CGFloat radius;
    CGFloat angle;
    int serviceType;
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
        UIImageView* meterImage;
        UIImageView* meterCenterImage;
        UIImageView* maskForMask;
        UIImageView* meterLogoImage;
        
        angle = ANGLE;
        
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:30];
        
        actualConsumeLabel = [[UILabel alloc] initWithFrame:CGRectMake(135 - (70 /2), 115, 70, 20)];
        [actualConsumeLabel setText:@"0"];
        [actualConsumeLabel setTextAlignment:NSTextAlignmentRight];
        
        consumeUnit = [[UILabel alloc] initWithFrame:CGRectMake(137 + (70/2), 115, 30, 20)];
        [consumeUnit setText:[NSString stringWithFormat:@"%@", (self.tag == 1)?@"Kw":@"Lts"]];
        
        actualConsumeConstLabel = [[UILabel alloc] initWithFrame:CGRectMake(136, 189, 89, 20)];
        [actualConsumeConstLabel setText:@"0.0"];
        [actualConsumeConstLabel setTextAlignment:NSTextAlignmentRight];

        meterMaskImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"maskMeter.png"]];

        maskForMask = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"maskForMask.png"]];
        [maskForMask setFrame:CGRectMake(63, 115, 154, 77)];
        
        if (self.tag == 1) {
            serviceType = 1;
            meterImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lightYellow.png"]];
            meterCenterImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"darkYellow.png"]];
            meterLogoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lightColor.png"]];
        }else{
            serviceType = 2;
            meterImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lightBlue.png"]];
            meterCenterImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"darkBlue.png"]];
            meterLogoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropColor.png"]];
        }
        
        [meterMaskImage setFrame:CGRectMake(63, 38, 154, 77)];
        [meterMaskImage.layer setAnchorPoint:CGPointMake(0.5, 0.0)];
        [meterMaskImage.layer setPosition:CGPointMake(140, 115)];
        [meterMaskImage setTransform: CGAffineTransformMakeRotation(M_PI)];
        
        [meterImage setFrame:CGRectMake(63, 38, 154, 77)];
        [meterCenterImage setFrame:CGRectMake(63, 38, 154, 77)];
        [meterLogoImage setFrame:CGRectMake(130, 80, 23, 31)];
        
        [self addSubview:meterImage];
        [self addSubview:meterMaskImage];
        [self addSubview:meterCenterImage];
        [self addSubview:maskForMask];
        [self addSubview:actualConsumeLabel];
        [self addSubview:consumeUnit];
        [self addSubview:actualConsumeConstLabel];
        [self addSubview:meterLogoImage];
        
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(dataFromDB) userInfo:Nil repeats:YES];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect
//{
//
//}



-(void)redrawMeterForActualConsume{
    angle = [self determinateAngleOfRotation];
    CGFloat angleInRadians = DEGREES_TO_RADIANS(angle);
    
    [UIView animateWithDuration:1.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         meterMaskImage.transform = CGAffineTransformMakeRotation((-1)*angleInRadians);
                     }
                     completion:^(BOOL finished) {
                     }];
}

-(CGFloat)determinateAngleOfRotation{
    NSUserDefaults* userDefaults =[NSUserDefaults standardUserDefaults];
    double maxConsume = ((NSString*)[userDefaults objectForKey:[NSString stringWithFormat:@"maxConsume%i", self.tag]]).integerValue;
    
    return ((maxConsume - actualConsume)*180)/maxConsume;
}

#pragma mark - Get Data From Server

-(void)dataFromDB{
    //Make Request for consumes
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ceis.unimet.edu.ve/WebService/Andres/consume.php?appKey=KEY&serviceType=%i&id=%@", self.tag, [userDefaults objectForKey:@"id"]]];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];

    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSString* answer = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        
        if (![answer isEqualToString:@"0"]) {
            NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            
            actualConsume = ((NSString*)[jsonDictionary objectForKey:@"consumo"]).integerValue;
            [actualConsumeLabel setText:[NSString stringWithFormat:@"%i", actualConsume]];
            [actualConsumeConstLabel setText:[jsonDictionary objectForKey:@"costo"]];
            [userDefaults setObject:[jsonDictionary objectForKey:@"maxConsume"] forKey:[NSString stringWithFormat:@"maxConsume%i", self.tag]];
            [userDefaults synchronize];
            [self redrawMeterForActualConsume];
        }
        
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

@end
