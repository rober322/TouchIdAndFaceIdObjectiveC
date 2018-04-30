//
//  ViewController.m
//  TouchIdAndFaceIdObjectiveC
//
//  Created by Rober Martinez on 30/04/18.
//  Copyright © 2018 Rober Martinez. All rights reserved.
//

#import "ViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
}

- (IBAction)buttonAction:(id)sender {
    
    LAContext *myContext = [[LAContext alloc] init];
    NSError *authError = nil;
    NSString *biometryType = @"autenticador biometrico";
    NSString *myLocalizedReasonString = @"Queremos logiarnos con tu %@";
    
    if ([myContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {
        
        switch (myContext.biometryType) {
            case LABiometryTypeTouchID:
                biometryType = @"Touch ID";
                break;
            case LABiometryTypeFaceID:
                biometryType = @"Face ID";
                break;
            default:
                break;
        }
        
        [myContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                  localizedReason:[NSString stringWithFormat: myLocalizedReasonString, biometryType]
                            reply:^(BOOL success, NSError *error) {
                                if (success) {
                                    NSLog(@"Es correcto");
                                } else {
                                    NSLog(@"No es correcto");
                                    switch (error.code) {
                                        case LAErrorAuthenticationFailed:
                                            NSLog(@"Fallo la autenticación");
                                            break;
                                        case LAErrorUserCancel:
                                            NSLog(@"El usuario presiono el boton Cancelar");
                                            break;
                                        case LAErrorUserFallback:
                                            NSLog(@"El usuario presiono el boton Enter Password");
                                            break;
                                        default:
                                            NSLog(@"El Touch ID no esta configurado");
                                            break;
                                    }
                                }
                            }];
    } else {
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Información"
                                     message:@"Su dispositivo no cuenta con un autenticador touchId ni faceId"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                    }];
        
        [alert addAction:okButton];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

@end
