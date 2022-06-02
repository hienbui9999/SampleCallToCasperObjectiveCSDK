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
