# import logger
# 
# import subprocess
# 
# csv_path = "C:\\Users\\Brandon\\Documents\\Personal_Projects\\many_mini\\scripts\\init_sumbit_data.csv"
# powershell_script_path = 'init_submit.ps1'
# 
# 
# row_dl = logger.readCSV(csv_path)
# 
# 
# 
# 
# 
# for row in row_dl:
#     wait_for_user_input = input()
# 
#     print(row)
#     
#     cmd = "powershell "
    
    
    
# -*- coding: iso-8859-1 -*-
import subprocess, sys
PS_FILE_PATH = "C:\\Users\\Brandon\\Documents\\Personal_Projects\\many_mini\\scripts\\init_submit\\init_submit.ps1"

# 
# p = subprocess.Popen(["powershell -ExecutionPolicy ByPass", 
#               "" + PS_FILE_PATH ])#+ " joe man 111@gmal 10001"], 
# #               stdout=sys.stdout)
# p.communicate()
cmd = "powershell -ExecutionPolicy ByPass -File C:\\Users\\Brandon\\Documents\\Personal_Projects\\many_mini\\scripts\\init_submit\\init_submit.ps1"
    
subprocess.call(cmd, shell=True)
    
    
