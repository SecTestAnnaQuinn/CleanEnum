# CleanEnum
A tool to take advantage of Null Sessions on a Domain Controller using enum4linux and clean the output for easier parsing.  I wrote this because I noticed how annoying it could be to read the output of enum4linux when running all checks.  This script is currently in its infancy and only producing files for the following:

User Descriptions
Usernames (utilizing the found domain)
Password Policy
Domain Groups
Domain Group Memberships


More features and refinements will be needed, and will be coming in the future.  I have not tested this against DCs that return multiple domains, and there may be issues that arise from that.  In addition, the Password Policy is set to only return 18 lines after the grep point, and may cut off some information should the Policy return more information.  This is very much a first draft.

## Utilization
Upon finding that null smb sessions are allowed to the domain controller, simply run the script with the IP of the domain controller passed as an argument.  enum4linux will run, then the script will parse the data into easier to read sections.  The Username file will use the domain found by the enum4linux command and prepend the domain to the found users to create a usable username list for other tests or exploitation.  Domain Group membership should look much cleaner as well, and was one of the main factors in this decision.  There are random newlines that occur where they shouldn't there, and I will work to trim those out in future releases.
