//
//  ViewController.m
//  MenuDelDia
//
//  Created by Anand Kumar on 6/15/15.
//  Copyright (c) 2015 anand. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>



@interface DefaultSettingsViewController : UIViewController

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    

        
    }
    


    
    
    
    
    // Do any additional setup after loading the view, typically from a nib.


- (IBAction)loginButton:(id)sender {
    
  
    [PFUser logInWithUsernameInBackground:self.usernameField.text
                                 password:self.passwordField.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                            // Do stuff after successful login.
                                            self.view.backgroundColor = [UIColor redColor];

                                    
                                            UITabBarController *obj = (UITabBarController *)self.presentingViewController;
                                            obj.selectedIndex = 0;
                                            
                                            [self dismissViewControllerAnimated:YES completion:nil];
                                            

                                            
                                            
                                        } else {
                                            
                                            
                                            
                                            
                                            
                                            // The login failed. Check error to see why.
                                           
                                            UIAlertController * alert=   [UIAlertController
                                                                          alertControllerWithTitle:@"Wrong Credentials"
                                                                          message:@"Incorrect Credentials, Please try again"
                                                                          preferredStyle:UIAlertControllerStyleAlert];
                                            
                                            UIAlertAction* ok = [UIAlertAction
                                                                 actionWithTitle:@"OK"
                                                                 style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction * action)
                                                                 {
                                                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                                                     
                                                                 }];
                                            
                                            [alert addAction:ok];
                                            
                                            
                                            [self presentViewController:alert animated:YES completion:nil];
                                         NSString *errorString = [error userInfo][@"error"];
                                            NSLog(@"error: %@", errorString);
                                            
                                            
                                            
                                        }
                                    }];
    
    
 
    //resign first responder and go back to first viewcontroller...
    
    [self.passwordField resignFirstResponder];

   
    
 }




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
//use this to link the main window to the detail viewcontroller window

{
    
    if ([segue.identifier isEqualToString:@"checklogin"]) {
        
        
    } else {
        
            }
    
    
    
}










- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
