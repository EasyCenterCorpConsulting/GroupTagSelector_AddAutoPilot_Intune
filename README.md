# Group Tag Selector "Autopilot Registration". 

We customized the Microsoft script "Get-WindowsAutoPilotInfo.ps1".<br />
https://techcommunity.microsoft.com/t5/windows-management/get-windowsautopilotinfo-a-quicker-way/m-p/212393<br />

We created a GUI "Graphical User Interface" using PowerShell that includes a list selector for Group Tags.<br />
The list of Group Tags for your organization must be entered in the "GroupTaglist.txt" file.<br />
Then place the "GroupTaglist.txt" file in the same directory as the script.<br /> 
After running the script, you can select the desired Group Tags.<br /> 
The script will then manage your CSV file by processing the hash of your device associated with the selected Group Tags.<br />




# Description of the procedure.
- **Requirement.**<br />
Have the "SelectGroupTag.ps1" script and the "GroupTaglist.txt" file on a USB key.<br />
<br />

- **Workflow overview.**<br />
![image](https://github.com/EasyCenterCorpConsulting/GroupTagSelector_AddAutoPilot_Intune/assets/136331253/a1d10fcd-e5ba-4894-aee1-c034378bc081)

- **Follow the steps.**<br />
     - Plug in the USB drive.<br />
     - When this "Continue in selected language" screen is displayed, press: Shift + F10 or fn + F10.<br />
   
       ![image](https://github.com/EasyCenterCorpConsulting/GroupTagSelector_AddAutoPilot_Intune/assets/136331253/952e060d-eda1-4414-b89f-946b0e62d383)
       
       
     - A cmd Windows appears.<br />
       

     ![image](https://github.com/EasyCenterCorpConsulting/GroupTagSelector_AddAutoPilot_Intune/assets/136331253/f4f34c20-4936-40b7-852a-7c5294e5ab65)

     - Type the command : explorer. <br />
     
        ![image](https://github.com/EasyCenterCorpConsulting/GroupTagSelector_AddAutoPilot_Intune/assets/136331253/6f8fdbbc-73c4-4a89-b514-6bfb3af94533)
        
     - A file explorer opens, and you can click on your USB flash drive.<br />

        ![image](https://github.com/EasyCenterCorpConsulting/GroupTagSelector_AddAutoPilot_Intune/assets/136331253/7cfb10e3-88d7-475a-843d-ae1f49a06836)
        
    - Right click on the script then click on Run with PowerShell.<br />
    
 ```diff 
 -In red, the Powershell script.
 +In green, the text file containing the organization's Group Tags.
``` 
In the context of a virtual machine, it is possible to mount a network share containing its files.<br />
Then, you can create a 'Temp' folder at the root of your C drive, place the files in it, and execute the script.<br />
Don't forget to transfer the generated CSV file.<br />
      
   ![image](https://github.com/EasyCenterCorpConsulting/GroupTagSelector_AddAutoPilot_Intune/assets/136331253/0576fcd0-84a1-469e-8c49-578e137f7d71)
 
- A Windows pop-up appears, click Yes.<br />

 ![image](https://github.com/EasyCenterCorpConsulting/GroupTagSelector_AddAutoPilot_Intune/assets/136331253/fb9caa5f-edfb-483d-ae37-cc9c25c73033)
 
 - The script ran successfully and the csv file is generated, click Enter to shut down the PC.<br />

![image](https://github.com/EasyCenterCorpConsulting/GroupTagSelector_AddAutoPilot_Intune/assets/136331253/0f856f47-f74f-4213-9b91-b61d85540342)

![image](https://github.com/EasyCenterCorpConsulting/GroupTagSelector_AddAutoPilot_Intune/assets/136331253/4723626a-9c71-4324-8b6e-c473890ef6de)


-    For this last step, go to the Autopilot section of Intune and import the .CSV file starting with the name "AutoPilotHWID-****".<br />

![image](https://github.com/EasyCenterCorpConsulting/GroupTagSelector_AddAutoPilot_Intune/assets/136331253/7a25a584-2f21-4dc0-82a3-8564f12128df)



