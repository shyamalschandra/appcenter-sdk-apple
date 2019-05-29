// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.

#import "MSAbstractLogInternal.h"
#import "MSModel.h"
#import "MSSerializableObject.h"

@class MSCSExtensions;
@class MSCSData;

// Keys
static NSString *const kMSCSCV = @"cV";
static NSString *const kMSCSData = @"data";
static NSString *const kMSCSExt = @"ext";
static NSString *const kMSCSFlags = @"flags";
static NSString *const kMSCSIKey = @"iKey";
static NSString *const kMSCSName = @"name";
static NSString *const kMSCSPopSample = @"popSample";
static NSString *const kMSCSTime = @"time";
static NSString *const kMSCSVer = @"ver";

// Values
static NSString *const kMSCSVerValue = @"3.0";

/**
 * Common schema has one event type with extensions, everything is called an event.
 */
@interface MSCommonSchemaLog : MSAbstractLog <MSSerializableObject, MSModel>

/**
 * The version of the schema. The format is a string with major and minor such as 3.0.
 */
@property(nonatomic, copy) NSString *ver;

/**
 * The event name.
 */
@property(nonatomic, copy) NSString *name;

/**
 * The effective sample rate for this event at the time it was generated by a client. The valid range is from a minimum value of one out of
 * every 100 million devices which is "0.000001", all the way up to all devices which is "100". The default value is 100.
 */
@property(nonatomic) double popSample;

/**
 * An identifier used to identify applications or other logical groupings of events.
 */
@property(nonatomic, copy) NSString *iKey;

/**
 * Event Property flags contain a collection of bits that describe how the event should be processed by the One Collector pipeline.
 */
@property(nonatomic) int64_t flags;

/**
 * Correlation Vector: A single field for tracking partial order of related telemetry events across component boundaries.
 */
@property(nonatomic, copy) NSString *cV;

/**
 * Part A extensions.
 */
@property(nonatomic) MSCSExtensions *ext;

/**
 * Part C
 */
@property(nonatomic) MSCSData *data;

@end