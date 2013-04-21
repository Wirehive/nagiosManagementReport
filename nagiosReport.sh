#!/bin/bash

###START CUSTOMISING#############

FROM="nagios@company.com"
DESTINATIONS="salesteam.company.com"

NAGIOSCGI="http://monitoring.company.com/nagios/cgi-bin/summary.cgi?report=1&displaytype=3&alerttypes=3&statetypes=2&hoststates=1&servicestates=56&limit=1000&noheader&timeperiod="

USERNAME="nagiosuser"
PASSWORD="nagiospass"

#Used to make links in the email work
FIXUPREGEX="s/extinfo.cgi/http:\/\/monitoring.company.com\/nagios\/cgi-bin\/extinfo.cgi/g"

###END CUSTOMISING###############

DAILYPERIOD="last24hours"
WEEKLYPERIOD="last7days"
MONTHLYPERIOD="last31days"

#Used to make HTML email render correctly
CONTENTTYPE="Content-Type: text/html"
MIMEVERSION="MIME-Version: 1.0"


#DAILY - Always runs
curl --silent --user $USERNAME:$PASSWORD --url "$NAGIOSCGI$DAILYPERIOD" \
| sed -e "$FIXUPREGEX" \
| mail -a "From:$FROM" -a "$CONTENTTYPE" -a "$MIMEVERSION" -s "Alerts Report: `date "+%A %b %d %Y" --date=yesterday`" $DESTINATIONS

#WEEKLY - Only runs on Monday
if [[ $(date +%u) == 1 ]]; then
        curl --silent --user $USERNAME:$PASSWORD --url "$NAGIOSCGI$WEEKLYPERIOD" \
        | sed -e "$FIXUPREGEX" \
        | mail -a "From:$FROM" -a "$CONTENTTYPE" -a "$MIMEVERSION" -s "Alerts Report: Week `date +%V --date=yesterday`" $DESTINATIONS
fi

#MONTHLY - Only runs on 1st of month
if [[ $(date +%d) == 1 ]]; then
        curl --silent --user $USERNAME:$PASSWORD --url "$NAGIOSCGI$MONTHLYPERIOD" \
        | sed -e "$FIXUPREGEX" \
        | mail -a "From:$FROM" -a "$CONTENTTYPE" -a "$MIMEVERSION" -s "Alerts Report: `date "+%b %Y" --date=yesterday`" $DESTINATIONS
fi
