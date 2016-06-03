import xlrd
import csv
import os



xlsdirectory = 'xlxs'
for subdir, dirs, files in os.walk(xlsdirectory):
    for file in files:
        if (file != ".DS_Store"):

            print "working with: " + os.path.join(subdir, file)  
            book = xlrd.open_workbook(os.path.join(subdir, file)  )
            output = file.split(".")[0] + ".csv"

            fp = open( os.path.join('outputs',output ), 'wb')
            print "Writing to: " + output
            
            wr = csv.writer(fp, quoting=csv.QUOTE_ALL)
            
            #for all the sheets
            for sheet in book.sheets():
                header = 0
                currentsubject = sheet.row(0)[0].value
                if (currentsubject != "Ranking") and ("HOW TO DOWNLOAD"  not in currentsubject):
                    #for all the rows
                        for rownum in range(sheet.nrows):
                            
                            #for all remining that aren't blank and aren't 
                            if (sheet.row(rownum)[1].value != "Name of Institution") :
                               
                                #print sheet.row_values(rownum)
                                rowArray =[] 
                                rowArray = sheet.row_values(rownum);
                                rowArray[0] = currentsubject
                                #print rowArray
                                sheet.row(rownum)[0] = sheet.row(0)[1].value
                                wr.writerow([unicode(val).encode('utf8') for val in rowArray])