//
//  GraphView.m
//  Plot
//
//  Created by Andres Ormaechea on 11/13/13.
//  Copyright (c) 2013 Andres Ormaechea. All rights reserved.
//

#import "GraphView.h"
#import"Delegate.h"

@implementation GraphView
{
    
    NSMutableArray * array;
    NSMutableArray * array2;
    NSMutableArray * array3;
    NSMutableArray * monthArray;
    NSMutableArray * realMonthArray;
    int number;
    NSTimer * timer;
    float maxConsume;
    BOOL getData;
    BOOL done;
    int firstMonth;
//    int kDefaultGraphWidth;//1800
//    int kOffsetX ;//0
//    int kStepX;// 70
}
@synthesize delegate;
@synthesize scrollerWidth;
@synthesize ident = _ident;
@synthesize serviceType = _serviceType;


- (id)initWithCoder:(NSCoder*)aCoder{
    self = [super initWithCoder:aCoder];
    if(self){
       // kStepX=70;
        getData = NO;
        done=NO;
        maxConsume=0;
        number=0;
        firstMonth=0;
        
        array= [[NSMutableArray alloc]init];
        array2= [[NSMutableArray alloc]init];
        array3= [[NSMutableArray alloc]init];
        monthArray= [[NSMutableArray alloc]init];
        realMonthArray= [[NSMutableArray alloc]init];

        [monthArray addObject:[NSString stringWithFormat:@"%i",number]];
        [monthArray addObject:[NSString stringWithFormat:@"%i",number]];
        [monthArray addObject:[NSString stringWithFormat:@"%i",number]];

        [monthArray addObject:@"JAN"];
        [monthArray addObject:@"FEB"];
        [monthArray addObject:@"MAR"];
        [monthArray addObject:@"APR"];
        [monthArray addObject:@"MAY"];
        [monthArray addObject:@"JUNE"];
        [monthArray addObject:@"JULY"];
        [monthArray addObject:@"AUG"];
        [monthArray addObject:@"SEP"];
        [monthArray addObject:@"OCT"];
        [monthArray addObject:@"NOV"];
        [monthArray addObject:@"DIC"];
        [monthArray addObject:@"JAN"];
        [monthArray addObject:@"FEB"];
        [monthArray addObject:@"MAR"];
        [monthArray addObject:@"APR"];
        [monthArray addObject:@"MAY"];
        [monthArray addObject:@"JUNE"];
        [monthArray addObject:@"JULY"];
        [monthArray addObject:@"JULY"];
        [monthArray addObject:@"AUG"];
        [monthArray addObject:@"SEP"];
        [monthArray addObject:@"OCT"];
        [monthArray addObject:@"NOV"];
        [monthArray addObject:@"DIC"];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
//-(void)setServiceType:(int)serviceTypeNumber
//{
//    _serviceType = serviceTypeNumber;
//    [self GetInfo];
//}

-(void)GetInfo
{
    firstMonth=0;
    [array removeAllObjects];
    [array2 removeAllObjects];
    [array3 removeAllObjects];
    [realMonthArray removeAllObjects];
    

    [array2 addObject:[NSString stringWithFormat:@"%i",number]];
    [array2 addObject:[NSString stringWithFormat:@"%i",number]];



    
    
    NSURL * url = [NSURL URLWithString: [NSString stringWithFormat:@"http://ceis.unimet.edu.ve/WebService/Andres/monthlyConsume.php?appKey=Key&id=%@&serviceType=%@", _ident, _serviceType]];
    
    NSURLRequest * request =[NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        NSDictionary *firstDictionary =[NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        NSDictionary * firstMonthDic=[firstDictionary objectForKey:@"0"];
        
        firstMonth=((NSString*)[firstMonthDic objectForKey:@"date"]).floatValue;
        maxConsume=((NSString*)[firstDictionary objectForKey:@"maxConsume"]).floatValue;
        self.scrollerWidth=[firstDictionary count]*90;
        
        [delegate receiveLength:[firstDictionary count]*80];
        for(int i=0;i<12;i++)
        {
            [realMonthArray addObject:[monthArray objectAtIndex:firstMonth]];
            firstMonth++;
        }
        
        
        for(int i=0; i<[firstDictionary count]-1;i++)
        {
            NSDictionary * dic= [firstDictionary objectForKey:[NSString stringWithFormat:@"%i",i]];
            [array2 addObject:[dic valueForKey:@"consume"]];
            
            
        }
        
        for(int i=0; i< [array2 count];i++)
        {
            float oldData= ((NSString*)[array2 objectAtIndex:i]).floatValue;
            float newData= (oldData/maxConsume);
            [array3 addObject:[NSString stringWithFormat:@"%f",newData]];
            
        }
        
        getData= YES;
        [self setNeedsDisplay];
    }];
    
    
}




- (void)drawLineGraphWithContext:(CGContextRef)ctx
{
    //Linea del grafico
    CGContextSetLineWidth(ctx, 2.0);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor grayColor] CGColor]);
    int maxGraphHeight = kGraphHeight - kOffsetY;
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, kOffsetX, kGraphHeight - maxGraphHeight *((NSString *)[array3 objectAtIndex:0]).floatValue);
    
    for (int i = 1; i < [array3 count]; i++)
    {
        CGContextAddLineToPoint(ctx, kOffsetX + i * kStepX, kGraphHeight - maxGraphHeight * ((NSString*)[array3 objectAtIndex:i]).floatValue);
    }
    
    CGContextDrawPath(ctx, kCGPathStroke);
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:0 green:0.5 blue:1 alpha:1.0] CGColor]);
    
    //Fill in graph
    CGGradientRef gradient;
    CGColorSpaceRef colorspace;
    size_t num_locations = 2;
    CGFloat locations[2] = {0.0, 1.0};
    CGFloat components[8] = {0.5, 1, 0.6, 0.5,  // Start color
        1.0, 0.5, 0.0, 1.0}; // End color
    colorspace = CGColorSpaceCreateDeviceRGB();
    gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
    
    CGPoint startPoint, endPoint;
    startPoint.x = kOffsetX;
    startPoint.y = kGraphHeight;
    endPoint.x = kOffsetX;
    endPoint.y = kOffsetY;
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:0 green:0.5 blue:1 alpha:0.5] CGColor]);
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, kOffsetX, kGraphHeight);
    CGContextAddLineToPoint(ctx, kOffsetX, kGraphHeight - maxGraphHeight * ((NSString*)[array3 objectAtIndex:0]).floatValue);
    for (int i = 1; i < [array3 count]; i++)
    {
        CGContextAddLineToPoint(ctx, kOffsetX + i * kStepX, kGraphHeight - maxGraphHeight * ((NSString*)[array3 objectAtIndex:i]).floatValue);
    }
    CGContextAddLineToPoint(ctx, kOffsetX + ([array3 count]-1) * kStepX, kGraphHeight);
    CGContextClosePath(ctx);
    
    CGContextSaveGState(ctx);
    CGContextClip(ctx);
    CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
    
    CGContextRestoreGState(ctx);
    CGColorSpaceRelease(colorspace);
    CGGradientRelease(gradient);
    
    
    // CGContextDrawPath(ctx, kCGPathFill);
    
    
    //Puntos de referencia
    for (int i = 1; i < [array3 count]; i++)
    {
        float x = (kOffsetX + i * kStepX);
        float y =( kGraphHeight - maxGraphHeight * ((NSString *)[array3 objectAtIndex:i]).floatValue);
        CGRect rect = CGRectMake(x - kCircleRadius, y - kCircleRadius, 2 * kCircleRadius, 2 * kCircleRadius);
        CGContextAddEllipseInRect(ctx, rect);
    }
    CGContextDrawPath(ctx, kCGPathFillStroke);
    
    
}


- (void)drawRect:(CGRect)rect
{
    
  if(getData)
      
  {
    
 CGContextRef context = UIGraphicsGetCurrentContext();
    UIImage *image = [UIImage imageNamed:@"background.png"];
    CGRect imageRect = CGRectMake(0, 0, 2000, 500);
    CGContextDrawImage(context, imageRect, image.CGImage);
      
//      UIImage *image2 = [UIImage imageNamed:@"background.png"];
//      CGRect imageRect2 = CGRectMake(900, 0, image2.size.width, 500);
//      CGContextDrawImage(context, imageRect2, image.CGImage);

 
 CGContextSetLineWidth(context, 0.6);
 CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
 
 // How many lines?
 int howMany = (kDefaultGraphWidth - kOffsetX) / kStepX;
 
 // Here the lines go
 for (int i = 0; i <= howMany; i++)
 {
 CGContextMoveToPoint(context, kOffsetX + i * kStepX, kGraphTop);
 CGContextAddLineToPoint(context, kOffsetX + i * kStepX, kGraphBottom);
 }
    
 int howManyHorizontal = (kGraphBottom - kGraphTop - kOffsetY) / kStepY;
    for (int i = 0; i <= howManyHorizontal; i++)
    {
        CGContextMoveToPoint(context, kOffsetX, kGraphBottom - kOffsetY - i * kStepY);
        CGContextAddLineToPoint(context, kDefaultGraphWidth, kGraphBottom - kOffsetY - i * kStepY);
    }
    
    CGFloat dash[] = {2.0, 2.0};
    CGContextSetLineDash(context, 0.0, dash, 2);
 
 CGContextStrokePath(context);
    
    CGContextSetLineDash(context, 0, NULL, 0); // Remove the dash
    [self drawLineGraphWithContext:context];
    
    //Drawing text
    CGContextSetTextMatrix (context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
    //    CGContextSetTextMatrix(context, CGAffineTransformRotate(CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0), M_PI / 2));
    
    
    
    CGContextSelectFont(context, "Gill Sans", 44, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor]);

    
    CGContextSetTextMatrix(context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
    CGContextSelectFont(context, "Gill Sans", 14, kCGEncodingMacRoman);
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor]);
    for (int i = 1; i < [realMonthArray count]; i++)
    {
       // NSString *theText = [NSString stringWithFormat:@"%d", i];
        NSString *theText= [realMonthArray objectAtIndex:i];
        CGContextShowTextAtPoint(context, kOffsetX + i * kStepX, kGraphBottom +15, [theText cStringUsingEncoding:NSUTF8StringEncoding], [theText length]);
    }
      for (int i = 1; i < [realMonthArray count]; i++)//display text
      {
          NSString *theText = [realMonthArray objectAtIndex:i];
          CGContextShowTextAtPoint(context, kOffsetX + i * kStepX+840, kGraphBottom +15, [theText cStringUsingEncoding:NSUTF8StringEncoding], [theText length]);
      }
      
      CGContextSetTextMatrix(context, CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0));
      CGContextSelectFont(context, "Gill Sans", 14, kCGEncodingMacRoman);
      CGContextSetTextDrawingMode(context, kCGTextFill);
      CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0 green:0 blue:0 alpha:1.0] CGColor]);
      for (int i = 1; i < [array2 count]; i++)
      {
          int maxGraphHeight = kGraphHeight - kOffsetY;
          NSString *theText = [array2 objectAtIndex:i];
          float x = (kOffsetX + i * kStepX)+5;
          float y =( kGraphHeight - maxGraphHeight * ((NSString *)[array3 objectAtIndex:i]).floatValue)+10;
          CGContextShowTextAtPoint(context, x, y, [theText cStringUsingEncoding:NSUTF8StringEncoding], [theText length]);
      }
    
}


}


@end
