# Contact-app

Contact App with Local Database configuration For iOS Devices
Using Node JS and MySQL Database as Back-End

Featuers 
get all the contact from the Database 
Create Contact
Delete Contact
Update Contact

Back-End : 
I used Node.Js for backend of an application by making REST APIs.
It Contains all the file in JS and to run you need to create Database in MySQL.
and please install all the following module before you excute back-end code.

For Database you can run this queries as below

Query 1. For creating schema.

CREATE SCHEMA `contacts_app` ;

Query 2. For Creating Table 

CREATE TABLE `contacts_app`.`contacts` (
  `cid` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `firstName` VARCHAR(45) NULL,
  `lastName` VARCHAR(45) NULL,
  `email` VARCHAR(45) NULL,
  `phone number` VARCHAR(45) NULL,
  `photo` VARCHAR(160) NULL,
  PRIMARY KEY (`cid`));

Query 3. For Inserting Some test Data

INSERT INTO `contacts_app`.`contacts` (`firstName`, `lastName`, `email`, `phone`) VALUES ('test', 'test', 'test@gmail.com', '1234567890');
INSERT INTO `contacts_app`.`contacts` (`firstName`, `lastName`, `email`, `phone`) VALUES ('test2', 'test2', 'test2@gmail.com', '1231231234');


for creating server :

Step 1 : Download "Contact-app" folder from Back-end Folder  
Step 2 : Navigate your CMD/Terminal to this folder 
Step 3 : run this Command **_npm install express body-parser mysql_** to install all the modules.
Step 4 : run this command **_node Contacts-app_**
Step 5 : You'll find port number and message that's show server is running 


 Fornt-End :
It contains all the file in Swift for running in iOS Device.

Please follow below steps to excute the code :

Step 1 : download forntend floder and open file "Contacts App.xcodeproj" in XCode.
Step 2 : Select Simulator and Run the Application 

