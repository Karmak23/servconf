#!/bin/bash

# This is done globally via the crontab job.
#BOGOFILTER="nice -n 19 ionice -c 3 bogofilter"

TMPFILE=`mktemp --tmpdir bogolearn.XXXXXXXXXX`

echo "> bogofilter learn wrapper starting @ `date`."

#echo "===> finding all mboxes..."
find ~/.Maildir -name cur -type d -print | grep -v -i -E '(archive|deleted|trash|unsure|v&AOk-rifier)' > ${TMPFILE}

#cat ${TMPFILE}

while read LINE
do
	SPAM=`echo "$LINE" | grep -i -E '(spam|junk|learn)'`

	if [ -z "$SPAM" ]; then
		echo -n ">> Ham in $LINE…"
		bogofilter -n -vt -B "$LINE/" 2>&1 | sed -e "s/[#]//g" -e "s/\$/./g"

	else
		echo -n ">> SPAM in $LINE…"
		bogofilter -s -vt -B "$LINE/" 2>&1 | sed -e "s/[#]//g" -e "s/\$/./g"
	fi
done < ${TMPFILE}

echo "> bogofilter learn wrapper terminated @ `date`."

rm -f ${TMPFILE}
