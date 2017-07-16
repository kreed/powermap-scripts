#!/bin/bash
sqlite3 tpit.db <<!
.headers on
.mode csv
.output out.csv
select * from tpit ORDER BY CASE WHEN sheet_status='Complete' THEN 0 WHEN sheet_status='Future' THEN 1 WHEN sheet_status='Cancelled' THEN 2 END, projected_in_service;
!
echo -n 'var tpit_projects = ' > tpit.js
./node_modules/.bin/csvtojson out.csv >> tpit.js
