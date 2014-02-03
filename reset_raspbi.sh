#!/bin/bash
cd /home/pi/git/Repo1
for t in `git tag`
	do
		git push origin :$t  >/dev/null 2>&1
		git tag -d $t  >/dev/null 2>&1
	done

rm version_record.txt
rm version_record_2.txt
