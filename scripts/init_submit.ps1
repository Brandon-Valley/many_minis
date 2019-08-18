
Set-ExecutionPolicy RemoteSigned

<#

param ( [parameter(Mandatory=$true)] [string] $first_name,
        [parameter(Mandatory=$true)] [String] $last_name,
        [parameter(Mandatory=$true)] [String] $email,
        [parameter(Mandatory=$true)] [String] $zip)
        #>

#miliseconds
$DEFAULT_WAIT_TIME = 100 
$OPEN_URL_WAIT_TIME = 4500
$NEW_TAB_WAIT_TIME = 1000

$BRAVE_SHORTCUT_PATH = "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Brave.lnk"
$FOUNDATION_URL = "https://googlenest.reevefoundation.org"

$BRAVE_EXE_PATH = "C:\Program Files (x86)\BraveSoftware\Brave-Browser\Application\brave.exe"

$DEFAULT_USER_DATA_PATH = "C:\Users\Brandon\Documents\Personal_Projects\many_minis\scripts\init_submit\User Data"
$BRAVE_APPDATA_PATH = "C:\Users\Brandon\AppData\Local\BraveSoftware\Brave-Browser"
$BRAVE_APPDATA_USER_DATA_PATH = $BRAVE_APPDATA_PATH + "\User Data"

$CONFIG_FILE_PATH   = "C:\Users\Brandon\Documents\Personal_Projects\many_minis\scripts\init_submit\second_trys.csv" #"C:\Users\Brandon\Documents\Personal_Projects\many_mini\scripts\init_submit\init_sumbit_data.csv"
$FAILED_EMAILS_PATH = "C:\Users\Brandon\Documents\Personal_Projects\many_minis\scripts\init_submit\failed_emails.txt"
$NUM_TABS_TO_LINK = 19
$NUM_TABS_TO_FIRST_RAD_BTN_D = @{"chrome"    = 23 #12:41 - 1st time hit 2:44
                                 "firefox"   = 29
                                 "opera"     = 23
                                 "edge"      = 23 # :(
                                 "brave"     = 23 # caught 1st try 3:04
                                 "icedragon" = 29
                                 "Maxthon (32 bit)" = 23 # :( - hit 1st time with notepad
                                 "tor browser"      = 29
                                 "slimbrowser"      = 29
                                 "notepad"           = 31
                                 "internet explorer" = 33} # got foucus once but never again, caught on 2nd try with notepad


function close_round
{

    #taskkill /S /IM "brave.exe" /F  # close brave window
    #START /wait taskkill  /im "brave.exe" /f
    taskkill /IM "brave.exe" /F /FI "STATUS eq RUNNING"  # close brave window
    
    # YES, YOU NEED BOTH OF THESE!!!
    Remove-Item –path $BRAVE_APPDATA_USER_DATA_PATH –recurse -Force -ErrorAction SilentlyContinue # delete user data
    Remove-Item –path $BRAVE_APPDATA_USER_DATA_PATH –recurse -Force -ErrorAction SilentlyContinue # delete user data

    #rm -r $BRAVE_APPDATA_USER_DATA_PATH -force
    #start-sleep -milliseconds $DEFAULT_WAIT_TIME
    Copy-Item -Path $DEFAULT_USER_DATA_PATH –recurse -Destination $BRAVE_APPDATA_PATH # copy user data with just default in it so the window will appear in the same spot
}



# must start from https://googlenest.reevefoundation.org/ after getting to it by clicking link on
# https://www.christopherreeve.org/about-us/press-releases/google-nest-partners-with-the-christopher-dana-reeve-foundation-to-improve-independence-for-individuals-living-with-paralysis

function init_submit_1_acc
{
    param ( [parameter(Mandatory=$true)] [string] $first_name,
            [parameter(Mandatory=$true)] [String] $last_name,
            [parameter(Mandatory=$true)] [String] $email,
            [parameter(Mandatory=$true)] [String] $zip)

    $browser = "brave"




     
    $wshell = New-Object -ComObject wscript.shell;
    #$wshell.AppActivate('Chrome')
    $wshell.AppActivate($browser)
    #$wshell.AppActivate('notepad')



    # open new foundation tab
    $wshell.SendKeys("^{t}") # open new tab
    start-sleep -milliseconds $NEW_TAB_WAIT_TIME
    $wshell.SendKeys("$FOUNDATION_URL")
    start-sleep -milliseconds $DEFAULT_WAIT_TIME
    $wshell.SendKeys("{ENTER}")
    start-sleep -milliseconds $OPEN_URL_WAIT_TIME



    # for unknown browser, activate notepad and click on the browser befor the delay is up
    # might only be for Yandex but need to use tabs to get to link, not click, or else 
    # you cant open the page again with ENTER
    if ($browser -eq "notepad")
    {
        $wshell.SendKeys("about to start")
        start-sleep -milliseconds 1000

    }

    <#
    #close current tab then open a new one from the link
    start-sleep -milliseconds 1000 # not sure if this needs to be longer than default
    $wshell.SendKeys("^{w}") #close cur tab
    start-sleep -milliseconds $DEFAULT_WAIT_TIME
    $wshell.SendKeys("{ENTER}")
    start-sleep -milliseconds $OPEN_URL_WAIT_TIME # need to wait a bit longer for page to load
    #start-sleep 50000 #`````````````````````````````````````````````````````````````````````````````````````
    #>

        
    # get to first radio btn
    For ($i=0; $i -le $NUM_TABS_TO_FIRST_RAD_BTN_D[$browser] ; $i++) {
    
        $wshell.SendKeys("{TAB}")
        #$wshell.SendKeys("A")
        #Write-Output "sent tab"
        start-sleep -milliseconds $DEFAULT_WAIT_TIME
        #sleep .1

        #Start-Sleep -s 0.5

        }


    #check radio btns, end on 1st text box, end on 1st rad btn to skip
    For ($i=0; $i -le 2; $i++) 
    {
        $wshell.SendKeys(" ")
        #$wshell.SendKeys("A")
        start-sleep -milliseconds 300
        $wshell.SendKeys("{TAB}")
        start-sleep -milliseconds 300
    }

    #fill text boxes
    $wshell.SendKeys($first_name)

    start-sleep -milliseconds 300
    $wshell.SendKeys("{TAB}")
    start-sleep -milliseconds 300

    $wshell.SendKeys($last_name)

    start-sleep -milliseconds 300
    $wshell.SendKeys("{TAB}")
    start-sleep -milliseconds 300

    $wshell.SendKeys($email)

    start-sleep -milliseconds 300
    $wshell.SendKeys("{TAB}")
    start-sleep -milliseconds 300

    $wshell.SendKeys($zip)

    start-sleep -milliseconds 300
    $wshell.SendKeys("{TAB}")
    start-sleep -milliseconds 300


    # skip then check I have read req rad btn
    $wshell.SendKeys("{TAB}")
    start-sleep -milliseconds 300
    $wshell.SendKeys(" ")
    start-sleep -milliseconds 300


    # hit sumbit btn
    $wshell.SendKeys("{TAB}")
    start-sleep -milliseconds 300
    $wshell.SendKeys("{TAB}")
    start-sleep -milliseconds 300
    $wshell.SendKeys("{ENTER}")


}






function read_init_submit_data
{
    $row_l = @()
    $configCSV = import-csv $CONFIG_FILE_PATH

    ForEach( $row in $configCSV )
    {
        $row_l += $row
    }
    return $row_l
}









$row_l = read_init_submit_data
Write-Output $row_l[0]
Write-Output $row_l[1].first_name
Write-Output $row_l[2]
$row_num = 10

while($true)
{
    $user_input = Read-Host
    
    if ($user_input -eq 'f')
    {
        Add-Content $FAILED_EMAILS_PATH $row_l[$row_num - 1].email 
        Write-Output "added email to fail file  " $row_l[$row_num - 1].email 
    }
    elseif ($user_input -eq 's')
    {
        #cmd /c $BRAVE_SHORTCUT_PATH # open new brave window
        Start-Process $BRAVE_EXE_PATH
    }
    elseif ($user_input -eq 'e')
    {
        close_round
    }
    else
    {
        Write-Output "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
        Write-Host $row_l[$row_num].email
        write-host $row_num

        #start-sleep -milliseconds 2600
        init_submit_1_acc $row_l[$row_num].first_name $row_l[$row_num].last_name $row_l[$row_num].email $row_l[$row_num].zip
        $row_num += 1
    }



    
}


#Write-Output $row_l





#init_submit_1_acc "bob" "man" "111@gmail.com" "10001"
#init_submit_1_acc $first_name $last_name $email $zip
