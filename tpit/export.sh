#!/bin/bash
sqlite3 tpit.db <<!
.headers on
.mode csv
.output out.csv
select t1.*
FROM tpit t1 LEFT OUTER JOIN tpit t2
ON t1.id = t2.id AND t1.sheet_date < t2.sheet_date
WHERE t2.id IS NULL AND t1.id != ""
ORDER BY CASE WHEN t1.sheet_status='Complete' THEN 0 WHEN t1.sheet_status='Future' THEN 1 WHEN t1.sheet_status='Cancelled' THEN 2 END, t1.projected_in_service;
!
echo -n 'var tpit_projects = ' > tpit.js
csvtojson out.csv >> tpit.js
