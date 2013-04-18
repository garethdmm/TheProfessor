//
//  BLEUtility.m
//
//  Created by Ole Andreas Torvmark on 9/22/12.
//  Copyright (c) 2012 Texas Instruments. All rights reserved.
//

#import "BLEUtility.h"

#ifndef LE_Transfer_TransferService_h
#define LE_Transfer_TransferService_h

#define TRANSFER_SERVICE_UUID           @"E20A39F4-73F5-4BC4-A12F-17D1AD07A961"
#define TRANSFER_CHARACTERISTIC_UUID    @"08590F7E-DB05-467E-8757-72F6FAEB13D4"

#endif

@implementation BLEUtility


+ (CBMutableCharacteristic *)characteristicWithCBUUID:(CBUUID *)cbuuid inArray:(NSArray *)array {
    
    for (CBMutableCharacteristic *characteristic in array) {
        if (characteristic.UUID == cbuuid) {
            return characteristic;
        }
    }
}

#pragma mark -
#pragma mark Data Parsing Methods
/****************************************************************************/
/*						Data Parsing Methods                                */
/****************************************************************************/

-(float) calcXValue:(NSData *)data {
    char scratchVal[data.length];
    [data getBytes:&scratchVal length:3];
    return ((scratchVal[0] * 1.0) / (256 / 4.0 ));
}

-(float) calcYValue:(NSData *)data {
    //Orientation of sensor on board means we need to swap Y (multiplying with -1)
    char scratchVal[data.length];
    [data getBytes:&scratchVal length:3];
    return ((scratchVal[1] * 1.0) / (256 / 4.0)) * -1;
}

-(float) calcZValue:(NSData *)data {
    char scratchVal[data.length];
    [data getBytes:&scratchVal length:3];
    return ((scratchVal[2] * 1.0) / (256 / 4.0));
}

+ (NSString *)xyzStringFromData:(NSData *)data {
    float x = [BLEUtility calcXValue:data];
    float y = [self calcYValue:data];
    float z = [self calcZValue:data];
    
    return [NSString stringWithFormat:@"%0.1f, %0.1f, %0.1f", x,y,z];
}

#pragma mark - data formatting methods

+ (NSString *)byteStringFromData:(NSData *)data {
    uint8_t bytes[data.length];
    
    [data getBytes:&bytes length:data.length];
    
    NSMutableString * strBytes = [[NSMutableString alloc] initWithCapacity:10];
    
    if (data.length >0) {
        [strBytes appendFormat:@"%d", bytes[0]];
    }
    
    for (int i = 1; i < data.length; i++) {
        [strBytes appendFormat:@", %d", bytes[i]];
    }
    
    return strBytes;
}

+ (NSString *)hexStringFromData:(NSData *)data {
    uint8_t bytes[data.length];
    
    [data getBytes:&bytes length:data.length];
    
    NSMutableString * str = [[NSMutableString alloc] initWithCapacity:10];
    
    if (data.length > 0) {
        [str appendFormat:@"0x%02x", bytes[0]];
    }
    
    for (int i = 1; i < data.length; i++) {
        [str appendFormat:@"%02x", bytes[i]];
    }
    
    return str;
}

+ (NSString *)stringFromData:(NSData *)data {
    uint8_t bytes[data.length];
    
    [data getBytes:&bytes length:data.length];
    
    NSMutableString * str = [[NSMutableString alloc] initWithCapacity:10];
    
    if (data.length > 0) {
        [str appendFormat:@"%c", (char)bytes[0]];
    }
    
    for (int i = 1; i < data.length; i++) {
        [str appendFormat:@"%c", (char)bytes[i]];
    }
    
    return str;
}

+(CBUUID *)generateCBUUID {
    // Create universally unique identifier (object)
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    
    // Get the string representation of CFUUID object.
    NSString *uuidStr = [(NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuidObject) autorelease];
    
    CFUUIDBytes bytes = CFUUIDGetUUIDBytes(uuidObject);

    NSData *data = [[NSData alloc] initWithBytes:&bytes length:16];
    
    CFRelease(uuidObject);
  
    CBUUID *cbuuid = [CBUUID UUIDWithData:data];
    
    NSLog(@"CBUUID: %@", [self CBUUIDToString:cbuuid]);
    
    return cbuuid;
}

+(void)writeCharacteristic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID data:(NSData *)data {
    // Sends data to BLE peripheral to process HID and send EHIF command to PC
    for ( CBService *service in peripheral.services ) {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:sUUID]]) {
            for ( CBCharacteristic *characteristic in service.characteristics ) {
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:cUUID]]) {
                    /* EVERYTHING IS FOUND, WRITE characteristic ! */
                    [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
                    
                }
            }
        }
    }
}

+(void)writeCharacteristic:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *)cCBUUID data:(NSData *)data {
    // Sends data to BLE peripheral to process HID and send EHIF command to PC
    for ( CBService *service in peripheral.services ) {
        if ([service.UUID isEqual:sCBUUID]) {
            for ( CBCharacteristic *characteristic in service.characteristics ) {
                if ([characteristic.UUID isEqual:cCBUUID]) {
                    /* EVERYTHING IS FOUND, WRITE characteristic ! */
                    [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
                    
                }
            }
        }
    }
}


+(void)readCharacteristic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID {
    for ( CBService *service in peripheral.services ) {
        if([service.UUID isEqual:[CBUUID UUIDWithString:sUUID]]) {
            for ( CBCharacteristic *characteristic in service.characteristics ) {
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:cUUID]]) {
                    /* Everything is found, read characteristic ! */
                    [peripheral readValueForCharacteristic:characteristic];
                }
            }
        }
    }
}

+(void)readCharacteristic:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *)cCBUUID {
    for ( CBService *service in peripheral.services ) {
        if([service.UUID isEqual:sCBUUID]) {
            for ( CBCharacteristic *characteristic in service.characteristics ) {
                if ([characteristic.UUID isEqual:cCBUUID]) {
                    /* Everything is found, read characteristic ! */
                    [peripheral readValueForCharacteristic:characteristic];
                }
            }
        }
    }
}

+(void)setNotificationForCharacteristic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID enable:(BOOL)enable {
    for ( CBService *service in peripheral.services ) {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:sUUID]]) {
            for (CBCharacteristic *characteristic in service.characteristics ) {
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:cUUID]])
                {
                    /* Everything is found, set notification ! */
                    [peripheral setNotifyValue:enable forCharacteristic:characteristic];
                    
                }
                
            }
        }
    }
}

+(void)setNotificationForCharacteristic:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *)cCBUUID enable:(BOOL)enable {
    for ( CBService *service in peripheral.services ) {
        if ([service.UUID isEqual:sCBUUID]) {
            for (CBCharacteristic *characteristic in service.characteristics ) {
                if ([characteristic.UUID isEqual:cCBUUID])
                {
                    /* Everything is found, set notification ! */
                    [peripheral setNotifyValue:enable forCharacteristic:characteristic];
                    
                }
                
            }
        }
    }
}


+(bool) isCharacteristicNotifiable:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *) cCBUUID {
    for ( CBService *service in peripheral.services ) {
        if ([service.UUID isEqual:sCBUUID]) {
            for (CBCharacteristic *characteristic in service.characteristics ) {
                if ([characteristic.UUID isEqual:cCBUUID])
                {
                    if (characteristic.properties & CBCharacteristicPropertyNotify) return YES;
                    else return NO;
                }
                
            }
        }
    }
    return NO;
}


+(bool) isCharacteristicWrite:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *) cCBUUID {
    for ( CBService *service in peripheral.services ) {
        if ([service.UUID isEqual:sCBUUID]) {
            for (CBCharacteristic *characteristic in service.characteristics ) {
                if ([characteristic.UUID isEqual:cCBUUID])
                {
                    if (characteristic.properties & CBCharacteristicPropertyWrite)
                        return true;
                    else return NO;
                }
                
            }
        }
    }
    return NO;
}

+(bool) isCharacteristicRead:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *) cCBUUID {
    for ( CBService *service in peripheral.services ) {
        if ([service.UUID isEqual:sCBUUID]) {
            for (CBCharacteristic *characteristic in service.characteristics ) {
                if ([characteristic.UUID isEqual:cCBUUID])
                {
                    if (characteristic.properties & CBCharacteristicPropertyRead)
                        return true;
                    else return NO;
                }
                
            }
        }
    }
    return NO;
}

+(bool) isCharacteristicBroadcasted:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *) cCBUUID {
    for ( CBService *service in peripheral.services ) {
        if ([service.UUID isEqual:sCBUUID]) {
            for (CBCharacteristic *characteristic in service.characteristics ) {
                if ([characteristic.UUID isEqual:cCBUUID])
                {
                    if (characteristic.properties & CBCharacteristicPropertyBroadcast)
                        return true;
                    else return NO;
                }
                
            }
        }
    }
    return NO;
}


+(CBUUID *) expandToTIUUID:(CBUUID *)sourceUUID {
    CBUUID *expandedUUID = [CBUUID UUIDWithString:TI_BASE_LONG_UUID];
    unsigned char expandedUUIDBytes[16];
    unsigned char sourceUUIDBytes[2];
    [expandedUUID.data getBytes:expandedUUIDBytes];
    [sourceUUID.data getBytes:sourceUUIDBytes];
    expandedUUIDBytes[2] = sourceUUIDBytes[0];
    expandedUUIDBytes[3] = sourceUUIDBytes[1];
    expandedUUID = [CBUUID UUIDWithData:[NSData dataWithBytes:expandedUUIDBytes length:16]];
    return expandedUUID;
}


+(NSString *) CBUUIDToString:(CBUUID *)inUUID {
    unsigned char i[16];
    [inUUID.data getBytes:i];
    if (inUUID.data.length == 2) {
        return [NSString stringWithFormat:@"%02hhx%02hhx",i[0],i[1]];
    }
    else {
        uint32_t g1 = ((i[0] << 24) | (i[1] << 16) | (i[2] << 8) | i[3]);
        uint16_t g2 = ((i[4] << 8) | (i[5]));
        uint16_t g3 = ((i[6] << 8) | (i[7]));
        uint16_t g4 = ((i[8] << 8) | (i[9]));
        uint16_t g5 = ((i[10] << 8) | (i[11]));
        uint32_t g6 = ((i[12] << 24) | (i[13] << 16) | (i[14] << 8) | i[15]);
        return [NSString stringWithFormat:@"%08x-%04hx-%04hx-%04hx-%04hx%08x",g1,g2,g3,g4,g5,g6];
    }
    return nil;
}

+ (NSString *)nameForCharacteristic:(CBCharacteristic *)characteristic {
    NSString *uuid = [BLEUtility CBUUIDToString:characteristic.UUID];
    
    if ([uuid isEqualToString:@"2a00"]) {
        return @"Device Name (0x2a00)";
    } else if ([uuid isEqualToString:@"2a01"]) {
        return @"Appearance (0x2a01)";
    } else if ([uuid isEqualToString:@"2a02"]) {
        return @"Peripheral Privacy Flag (0x2a02)";
    } else if ([uuid isEqualToString:@"2a03"]) {
        return @"Reconnection Address (0x2a03)";
    } else if ([uuid isEqualToString:@"2a04"]) {
        return @"Peripheral Preferred Connection Parameters (0x2a04)";
    } else if ([uuid isEqualToString:@"2a05"]) {
        return @"Service Changed (0x2a05)";
    } else if ([uuid isEqualToString:@"2a23"]) {
        return @"Serial Number String (0x2a23)";
    } else if ([uuid isEqualToString:@"2a25"]) {
        return @"Serial Number String (0x2a25)";
    } else if ([uuid isEqualToString:@"2a28"]) {
        return @"Software Revision String (0x2a28)";
    } else if ([uuid isEqualToString:@"2a29"]) {
        return @"Manufacturer Name String (0x2a29)";
    } else if ([uuid isEqualToString:@"2a24"]) {
        return @"Model Number String (0x2a24)";
    } else if ([uuid isEqualToString:@"2a26"]) {
        return @"Firmware Revision String (0x2a26)";
    } else if ([uuid isEqualToString:@"2a27"]) {
        return @"Hardware Revision String (0x2a27)";
    } else if ([uuid isEqualToString:@"2a50"]) {
        return @"PnP ID (0x2a50)";
    } else if ([uuid isEqualToString:@"2a2a"]) {
        return @"Regulatory Data (0x2a2a)";
    }
    
    return uuid;
}

+ (NSString *)nameForService:(CBService *)service {
    NSString *uuid = [BLEUtility CBUUIDToString:service.UUID];
    
    NSLog(@"nameForService: %d", uuid);
    
    if ([uuid isEqualToString:@"180a"]) {
        return @"Access Profile Service (0x180a)";
    } else if ([uuid isEqualToString:@"1800"]) {
        return @"Attribute Profile Service (0x1800)";
    } else if ([uuid isEqualToString:@"1801"]) {
        return @"Device Info Service (0x1801)";
    }
    
    return uuid;
}

@end
