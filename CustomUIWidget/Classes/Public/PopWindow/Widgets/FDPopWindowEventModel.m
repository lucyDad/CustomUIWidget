//
//  FDPopWindowEventModel.m
//  CustomUIWidget
//
//  Created by hexiang on 2021/8/23.
//

#import "FDPopWindowEventModel.h"

@implementation FDPopWindowEventModel

- (instancetype)copyWithZone:(NSZone *)zone {
    FDPopWindowEventModel *model = [FDPopWindowEventModel new];
    model.sequenceId = self.sequenceId;
    model.receiveTime = self.receiveTime;
    model.showTime = self.showTime;
    model.handler = self.handler;
    model.priorityLevel = self.priorityLevel;
    model.userData = self.userData;
    
    return model;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%p, sequenceId = %ld, showTime = %zd, currentShowPage = %@", self, (long)self.sequenceId, self.showTime, self.currentShowPage];
}

@end
