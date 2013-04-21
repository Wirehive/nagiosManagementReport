Adjust the FROM and DESTINATIONS values to match requirements.

To send to multiple destinations, seperate with comma and no space. For example:

    DESTINATIONS="user1@company.com,user2@company.com,user3@comapny.com"
    
Adjust the NAGIOSCGI value, change "monitoring.company.com/nagios" for the base URL of your nagios install.

Enter your nagios credentials in USERNAME and PASSWORD.

If you want the links to function in your emails, you will need to use regex to replace the href in the HTML. This is because Nagios uses relative links on the cgi output. The following is an example, swap in your own base Nagios URL. Notice that the foward slahes are escaped.

    FIXUPREGEX="s/extinfo.cgi/http:\/\/monitoring.company.com\/nagios\/cgi-bin\/extinfo.cgi/g"
    
You shouldn't need to change anything else.

Should be installed in crontab as:

    #Nagios Alert Reports
    59 7 * * * /path/to/nagiosReport.sh
