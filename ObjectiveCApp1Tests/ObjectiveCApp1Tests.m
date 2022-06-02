//
//  ObjectiveCApp1Tests.m
//  ObjectiveCApp1Tests
//
//  Created by Hien on 24/05/2022.
//

#import <XCTest/XCTest.h>
@interface ObjectiveCApp1Tests : XCTestCase

@end

@implementation ObjectiveCApp1Tests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    GTMSessionFetcherLogViewController * a = [[GTMSessionFetcherLogViewController alloc] init];
    [a sayHelloAgainAndAgain];
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
