//
//  SignupViewController.m
//  
//
//  Created by Anand Kumar on 6/15/15.
//
//

#import "SignupViewController.h"



@interface SignupViewController ()


@property (strong, nonatomic) IBOutlet UITextField *emailField;

@property (strong, nonatomic) IBOutlet UITextField *usernameField;

@property (strong, nonatomic) IBOutlet UITextField *passwordField;





@end

@implementation SignupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)signupButton:(id)sender {
    
    
    PFUser *user = [PFUser user];
    user.username = self.usernameField.text;
    user.password = self.passwordField.text;
    user.email = self.emailField.text;
    //user.email = @"email@example.com";
    
    // other fields can be set if you want to save more information
    //user[@"phone"] = @"650-555-0000";
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            self.view.backgroundColor = [UIColor greenColor];
        } else {
            NSString *errorString = [error userInfo][@"error"];
            NSLog(@"error: %@", errorString);
            // Show the errorString somewhere and let the user try again.
        }
    }];
   
    
    
   [self.emailField resignFirstResponder];
   [self dismissViewControllerAnimated:YES completion:nil];
    
}










- (IBAction)closeSignupWindow:(id)sender {

    [self dismissViewControllerAnimated:YES completion:^{
        
        //everything that goes here get executed after the viewconteller disappears
        
        //do something with saving and whatever
        
        
        
    }];



}







/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
