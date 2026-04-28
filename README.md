# TRACER
TRACER (Translating Receipts of Audited Collections to Electronic Records) is an android app designed to streamline the process of recording student receipts by utilizing OCR technology to extract handwritten information to store it in a centralized database.

## Publicly Accessible Link for the Interactive Prototype
Click the link to access TRACER's Interactive Prototype:
https://www.figma.com/proto/UA7hTDAnix6KM5iKor4AOq/TRACER-PROTOTYPE?node-id=368-257&t=YzezWuq04fL7EcJC-1

## Tasks
1. **Access of Records** - Simple Task
    - Access past records to check if a specific student has paid the membership fee or other important financial record. The user navigates to the Records section, searches for the student's name, and successfully locates their digital receipt record.
2. **Scan and Verifying Receipts** - Moderate Task
    - Utilize the app's scanning feature to scan handwritten receipts. After the OCR processes the image, the user reviews the extracted text on the screen and is able to make adjustments to ensure that the data extracted is accurate.
3. **E-Receipt Generation and Email Distribution** - Complex Task
    - Automatically generates an E-Receipt to be distributed to the respective student via email.

## Usage
1. Create an account using your student organization credentials and choose your student organization.
2. Login to your newly created account to access the home screen.
3. Choose the scan

## Features
1. **OCR Integration**
    - TRACER has a scanning feature that uses OCR to automatically extract text from physical, handwritten receipts.
2. **Centralized Database**
    - Securely stores all records of student organizations using Supabase's dedicated database services.
3. **Automated E-Receipts**
    - The app has a feature to send e-receipts directly to the students via email.
4. **Access of Records**
    - Easily track or search through past records for auditing, financial checking or other purposes. 

## Contextual Information for the Evaluator

### Who is your target population?
Our target population are finance officers from student organizations that face struggles in managing financial receipts through traditional means.

### When would someone use your app?
Users would engage with our application in order to:
- Conveniently manage financial records of student organizations anytime and anywhere.
- Digitize a huge sum of handwritten receipts, lifting finance officers of unnecessary burden compared to traditional means. 
- Send a proof of payment to students without the need to manually write receipts through email. 

### What should a user be able to accomplish in this prototype?
Users should be able to:
- Scan physical receipts and extract its data using OCR.
- Store the scanned receipts into a centralized database.
- Send e-receipts to students through email.
- Access records within their respective student organization for checking, tracking and other purposes.

### What are the limitations?
The TRACER application contains limitations such as:
- The app is designed only to cater Android devices.
- The OCR accuracy is purely dependent on Google Cloud's Document AI model.
- The app requires an internet connection in order to sync records and send e-receipts via email.