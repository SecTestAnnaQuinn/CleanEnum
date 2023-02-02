# CleanEnum
A tool to take advantage of Null Sessions on a Domain Controller using enum4linux and clean the output for easier parsing.  I wrote this because I noticed how annoying it could be to read the output of enum4linux when running all checks.  This script is currently in its infancy and only producing files for the following:

User Descriptions
Usernames (utilizing the found domain)
Password Policy
Domain Groups
Domain Group Memberships


More features and refinements will be needed, and will be coming in the future.  Currently, the Password Policy is set to only return 18 lines after the grep point, and may cut off some information should the Policy return more information.  I will be diving into the enum4linux code a bit to see what adjustments I may need to make for cases I have yet to see.

## Utilization
Upon finding that null smb sessions are allowed to the domain controller, simply run the script with the IP of the domain controller passed as an argument.  

After doing so, enum4linux will run and the script will parse the data into easier to read sections.  The Username file will use the domain found by the enum4linux command and prepend the domain to the found users to create a usable username list for other tests or exploitation.  Domain Group membership should look much cleaner as well, and was one of the main factors in the decision to create this script.  There are random newlines that occur where they shouldn't at times, and I will work to trim those out in future releases.
