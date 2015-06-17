//
//  AIACloseBlockProtocol.h
//  AirAlertView
//
//  Created by Oleg Lobachev aironik@gmail.com on 14.05.14.
//  Copyright © 2014 aironik. All rights reserved.
//


typedef void(^AIAModalViewCloseBlock)();


@protocol AIACloseBlockProtocol<NSObject>


- (void)setCloseBlock:(AIAModalViewCloseBlock)closeBlock;
- (AIAModalViewCloseBlock)closeBlock;


@end

