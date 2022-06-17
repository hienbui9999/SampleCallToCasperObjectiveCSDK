# SampleCallToCasperObjectiveCSDK

This is  a sample project used to demonstrate how to use Casper ObjectiveC SDK from other Objective C Project.

The Casper ObjectiveC SDK is at this address:

https://github.com/tqhuy2018/Casper-ObjectiveC-sdk

This project is just a very simple IOS App with StoryBoard interface, but the interface is just do nothing. Only the code behind the scene does the work of calling the Casper ObjectiveC SDK.

The main call is done in file 

https://github.com/hienbui9999/SampleCallToCasperObjectiveCSDK/blob/main/ObjectiveCApp1/ViewController.m

There are 3 sample RPC calls in this sample project:

1) chain_get_state_root_hash 
2) info_get_peers
3) account_put_deploy

You can easily implement other methods just by importing the corresponding library of the ObjectiveC SDK and make the call some how like the three above methods.

**Note: For account_put_deploy task, you need to configuration the path for the Pem file of Ed25519 and Secp256k1 crypto.**

First you have to choose 1 folder in your Mac device to read/write the Public/Private key for both Ed25519 and Secp256k1 when build/run the Package from Xcode. You if do not do this step. The test will sure fail.

This step is just an example for the setting up the Pem file path and place, you can put create your own folder, put the Pem file and then point the path to the Pem file in that folder. As long as these things is set up correctly, the SDK will build and run without error. If you are not sure of what to do, just follow these steps below.

Under folder "Users" in your Mac create 1 folder with name "CasperObjectiveCCryptoTest"
Under folder "ObjectiveCApp1" in the project you will see a folder with name "PemFiles". Copy this folder to the already created "CasperObjectiveCCryptoTest" folder above.

Somehow the structure of the folder will be like this

<img width="1107" alt="Screen Shot 2022-06-17 at 19 54 46" src="https://user-images.githubusercontent.com/94465107/174302501-dd93f864-6bc4-4aff-ac20-9fa893f67320.png">


The path for the key Ed25519 can change in this line of the file "ViewController.m" file

 ```ObjectiveC
NSString * privateKeyPath = @"Users/CasperObjectiveCCryptoTest/PemFiles/PrivateKeyEd25519.pem";
```

 and for Secp256k1 the code is:
 
  ```ObjectiveC
 NSString * privateKeyPath = @"Users/CasperObjectiveCCryptoTest/PemFiles/PrivateKeySecp256k1.pem";
  ```
 
Make sure that you point to the correct pem file path and Xcode has the right to read the file. 

After making these steps, you can Run the project and see the result in the Log panel of Xcode. Press Cmd + Shift + Y to view the Log panel.

After Runing the Project (By hitting Product->Run) you will see the result in the log like this:

<img width="1440" alt="Screen Shot 2022-06-02 at 21 12 05" src="https://user-images.githubusercontent.com/94465107/171652627-3481e6fe-075f-4044-9bce-cfdad2e5ad0a.png">

