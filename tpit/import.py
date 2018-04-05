#!/usr/bin/env python3

import datetime
import openpyxl
import re
import sqlite3
import sys

con = sqlite3.connect('tpit.db')

tpit_file = sys.argv[1]
tpit_date = re.search('[0-9]+', tpit_file).group(0)
tpit_date = '20' + tpit_date[4:6] + '-' + tpit_date[0:2]

wb = openpyxl.load_workbook(filename=tpit_file)

sheets = wb.get_sheet_names()

for sheet in sheets:
	if not 'NoCost' in sheet:
		continue

	ws = wb[sheet]
	status = sheet.split('TPIT')[0]
	column_count = 31

	tup = []
	for i, rows in enumerate(ws):
		tuprow = []
		if i < 2:
			continue
		for row in rows:
			if type(row.value) is datetime.datetime:
				tuprow.append(row.value.strftime('%Y-%m-%d'))
			else:
				tuprow.append(str(row.value).strip()) if row.value != None else tuprow.append('')
		if len(tuprow) != 31:
			continue
		tup.append(tuple(tuprow))

	print('INSERT INTO tpit VALUES (?' + (',?' * (column_count - 1)) + ',' + tpit_date + ',' + status + ')')
	con.executemany('INSERT INTO tpit VALUES (?' + (',?' * (column_count - 1)) + ',"' + tpit_date + '","' + status + '")', tup)
	con.commit()

con.close()
