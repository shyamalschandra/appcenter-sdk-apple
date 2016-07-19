#import "AVADeviceLog.h"
#import "AVADeviceTracker.h"
#import <CoreTelephony/CTCarrier.h>
#import <Foundation/Foundation.h>
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import <OCMock/OCMock.h>
#import <XCTest/XCTest.h>

static NSString *const kAVADeviceManufacturerTest = @"Apple";

@interface AVADeviceHelperTests : XCTestCase

@end

/**
 *  Expose private methods for testing.
 */
@interface AVADeviceTracker (Tests)

- (NSString *)sdkVersion:(const char[])version;
- (NSString *)deviceModel;
- (NSString *)osName:(UIDevice *)device;
- (NSString *)osVersion:(UIDevice *)device;
- (NSString *)locale:(NSLocale *)deviceLocale;
- (NSNumber *)timeZoneOffset:(NSTimeZone *)timeZone;
- (NSString *)screenSize;
- (NSString *)carrierName:(CTCarrier *)carrier;
- (NSString *)carrierCountry:(CTCarrier *)carrier;
- (NSString *)appVersion:(NSBundle *)appBundle;
- (NSString *)appBuild:(NSBundle *)appBundle;
- (NSString *)appNamespace:(NSBundle *)appBundle;

@end

@interface AVADeviceTrackerTests : XCTestCase

@property(nonatomic, strong) AVADeviceTracker *deviceTracker;

@end

@implementation AVADeviceTrackerTests

- (void)setUp {
  [super setUp];
  self.deviceTracker = [[AVADeviceTracker alloc] init];
}

- (void)tearDown {
  [super tearDown];
}

- (void)testDeviceInfo {

  assertThat(self.deviceTracker.device.sdkVersion, notNilValue());
  assertThatInteger([self.deviceTracker.device.sdkVersion length], greaterThan(@(0)));

  assertThat(self.deviceTracker.device.model, notNilValue());
  assertThatInteger([self.deviceTracker.device.model length], greaterThan(@(0)));

  assertThat(self.deviceTracker.device.oemName, is(kAVADeviceManufacturerTest));

  assertThat(self.deviceTracker.device.osName, notNilValue());
  assertThatInteger([self.deviceTracker.device.osName length], greaterThan(@(0)));

  assertThat(self.deviceTracker.device.osVersion, notNilValue());
  assertThatInteger([self.deviceTracker.device.osVersion length], greaterThan(@(0)));
  assertThatFloat([self.deviceTracker.device.osVersion floatValue], greaterThan(@(0.0)));

  assertThat(self.deviceTracker.device.locale, notNilValue());
  assertThatInteger([self.deviceTracker.device.locale length], greaterThan(@(0)));

  assertThat(self.deviceTracker.device.timeZoneOffset, notNilValue());

  assertThat(self.deviceTracker.device.screenSize, notNilValue());

  // Can't access carrier name and country in test context but it's optional and in that case it has to be nil.
  assertThat(self.deviceTracker.device.carrierCountry, nilValue());
  assertThat(self.deviceTracker.device.carrierName, nilValue());

  // Can't access a valid main bundle from test context so we can't test for App namespace (bundle ID), version and
  // build.
}

- (void)testSDKVersion {

  // If
  NSString *expected = @"1.2.3";
  const char *versionMock = [expected UTF8String];

  // When
  NSString *sdkVersion = [self.deviceTracker sdkVersion:versionMock];

  // Then
  assertThat(sdkVersion, is(expected));
}

- (void)testDeviceModel {

  // When
  NSString *model = [self.deviceTracker deviceModel];

  // Then
  assertThat(model, notNilValue());
  assertThatInteger([model length], greaterThan(@(0)));
}

- (void)testDeviceOSName {

  // If
  NSString *expected = @"iMock OS";
  UIDevice *deviceMock = OCMClassMock([UIDevice class]);
  OCMStub([deviceMock systemName]).andReturn(expected);

  // When
  NSString *osName = [self.deviceTracker osName:deviceMock];

  // Then
  assertThat(osName, is(expected));
}

- (void)testDeviceOSVersion {

  // If
  NSString *expected = @"4.5.6";
  UIDevice *deviceMock = OCMClassMock([UIDevice class]);
  OCMStub([deviceMock systemVersion]).andReturn(expected);

  // When
  NSString *osVersion = [self.deviceTracker osVersion:deviceMock];

  // Then
  assertThat(osVersion, is(expected));
}

- (void)testDeviceLocale {

  // If
  NSString *expected = @"en-US";
  UIDevice *deviceMock = OCMClassMock([UIDevice class]);
  OCMStub([deviceMock systemVersion]).andReturn(expected);

  // When
  NSString *osVersion = [self.deviceTracker osVersion:deviceMock];

  // Then
  assertThat(osVersion, is(expected));
}

- (void)testDeviceTimezoneOffset {

  // If
  NSNumber *expected = @(-420);
  NSTimeZone *tzMock = OCMClassMock([NSTimeZone class]);
  OCMStub([tzMock secondsFromGMT]).andReturn(-25200);

  // When
  NSNumber *tz = [self.deviceTracker timeZoneOffset:tzMock];

  // Then
  assertThat(tz, is(expected));
}

- (void)testDeviceScreenSize {

  // When
  NSString *screenSize = [self.deviceTracker screenSize];

  // Then
  assertThat(screenSize, notNilValue());
  assertThatInteger([screenSize length], greaterThan(@(0)));
}

- (void)testCarrierName {

  // If
  NSString *expected = @"MobileParadise";
  CTCarrier *carrierMock = OCMClassMock([CTCarrier class]);
  OCMStub([carrierMock carrierName]).andReturn(expected);

  // When
  NSString *carrierName = [self.deviceTracker carrierName:carrierMock];

  // Then
  assertThat(carrierName, is(expected));
}

- (void)testNoCarrierName {

  // If
  CTCarrier *carrierMock = OCMClassMock([CTCarrier class]);
  OCMStub([carrierMock carrierName]).andReturn(nil);

  // When
  NSString *carrierName = [self.deviceTracker carrierName:carrierMock];

  // Then
  assertThat(carrierName, nilValue());
}

- (void)testCarrierCountry {

  // If
  NSString *expected = @"US";
  CTCarrier *carrierMock = OCMClassMock([CTCarrier class]);
  OCMStub([carrierMock isoCountryCode]).andReturn(expected);

  // When
  NSString *carrierCountry = [self.deviceTracker carrierCountry:carrierMock];

  // Then
  assertThat(carrierCountry, is(expected));
}

- (void)testNoCarrierCountry {

  // If
  CTCarrier *carrierMock = OCMClassMock([CTCarrier class]);
  OCMStub([carrierMock isoCountryCode]).andReturn(nil);

  // When
  NSString *carrierCountry = [self.deviceTracker carrierCountry:carrierMock];

  // Then
  assertThat(carrierCountry, nilValue());
}

- (void)testAppVersion {

  // If
  NSString *expected = @"7.8.9";
  NSDictionary<NSString *, id> *plist = @{ @"CFBundleShortVersionString" : expected };
  NSBundle *bundleMock = OCMClassMock([NSBundle class]);
  OCMStub([bundleMock infoDictionary]).andReturn(plist);

  // When
  NSString *appVersion = [self.deviceTracker appVersion:bundleMock];

  // Then
  assertThat(appVersion, is(expected));
}

- (void)testAppBuild {

  // If
  NSString *expected = @"42";
  NSDictionary<NSString *, id> *plist = @{ @"CFBundleVersion" : expected };
  NSBundle *bundleMock = OCMClassMock([NSBundle class]);
  OCMStub([bundleMock infoDictionary]).andReturn(plist);

  // When
  NSString *appBuild = [self.deviceTracker appBuild:bundleMock];

  // Then
  assertThat(appBuild, is(expected));
}

- (void)testAppNamespace {

  // If
  NSString *expected = @"com.microsoft.test.app";
  NSBundle *bundleMock = OCMClassMock([NSBundle class]);
  OCMStub([bundleMock bundleIdentifier]).andReturn(expected);

  // When
  NSString *appNamespace = [self.deviceTracker appNamespace:bundleMock];

  // Then
  assertThat(appNamespace, is(expected));
}

@end
