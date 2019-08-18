
Set-ExecutionPolicy RemoteSigned



#miliseconds
$DEFAULT_WAIT_TIME = 100 
$OPEN_URL_WAIT_TIME = 5500
$NEW_TAB_WAIT_TIME = 1000

$FOUNDATION_URL = "https://googlenest.reevefoundation.org"

$BRAVE_EXE_PATH = "C:\Program Files (x86)\BraveSoftware\Brave-Browser\Application\brave.exe"

$DEFAULT_USER_DATA_PATH = "C:\Users\Brandon\Documents\Personal_Projects\many_minis\scripts\init_submit\User Data"
$BRAVE_APPDATA_PATH = "C:\Users\Brandon\AppData\Local\BraveSoftware\Brave-Browser"
$BRAVE_APPDATA_USER_DATA_PATH = $BRAVE_APPDATA_PATH + "\User Data"

$CONFIG_FILE_PATH   = "C:\Users\Brandon\Documents\Personal_Projects\many_minis\scripts\init_submit\init_sumbit_data.csv"
$FAILED_EMAILS_PATH = "C:\Users\Brandon\Documents\Personal_Projects\many_minis\scripts\init_submit\failed_emails.txt"



function close_round
{
    taskkill /IM "brave.exe" /F /FI "STATUS eq RUNNING"  # close brave window
    
    # YES, YOU NEED BOTH OF THESE!!!
    Remove-Item –path $BRAVE_APPDATA_USER_DATA_PATH –recurse -Force -ErrorAction SilentlyContinue # delete user data
    Remove-Item –path $BRAVE_APPDATA_USER_DATA_PATH –recurse -Force -ErrorAction SilentlyContinue # delete user data

    #rm -r $BRAVE_APPDATA_USER_DATA_PATH -force
    #start-sleep -milliseconds $DEFAULT_WAIT_TIME
    Copy-Item -Path $DEFAULT_USER_DATA_PATH –recurse -Destination $BRAVE_APPDATA_PATH # copy user data with just default in it so the window will appear in the same spot
}




function init_submit_1_acc
{
    param ( [parameter(Mandatory=$true)] [string] $first_name,
            [parameter(Mandatory=$true)] [String] $last_name,
            [parameter(Mandatory=$true)] [String] $email,
            [parameter(Mandatory=$true)] [String] $zip)

    $browser = "brave"




     
    $wshell = New-Object -ComObject wscript.shell;
    $wshell.AppActivate($browser)




    # open new foundation tab
    start-sleep -milliseconds $DEFAULT_WAIT_TIME
    $wshell.SendKeys("^{t}") # open new tab
    start-sleep -milliseconds $NEW_TAB_WAIT_TIME
    $wshell.SendKeys("$FOUNDATION_URL")
    start-sleep -milliseconds $DEFAULT_WAIT_TIME
    $wshell.SendKeys("{ENTER}")
    start-sleep -milliseconds $OPEN_URL_WAIT_TIME


        
    # get to first radio btn
    For ($i=0; $i -le 23 ; $i++) {
        $wshell.SendKeys("{TAB}")
        start-sleep -milliseconds $DEFAULT_WAIT_TIME
        }


    #check radio btns, end on 1st text box, end on 1st rad btn to skip
    For ($i=0; $i -le 2; $i++) 
    {
        $wshell.SendKeys(" ")
        start-sleep -milliseconds $DEFAULT_WAIT_TIME
        $wshell.SendKeys("{TAB}")
        start-sleep -milliseconds $DEFAULT_WAIT_TIME
    }

    #fill text boxes
    $wshell.SendKeys($first_name)

    start-sleep -milliseconds $DEFAULT_WAIT_TIME
    $wshell.SendKeys("{TAB}")
    start-sleep -milliseconds $DEFAULT_WAIT_TIME

    $wshell.SendKeys($last_name)

    start-sleep -milliseconds $DEFAULT_WAIT_TIME
    $wshell.SendKeys("{TAB}")
    start-sleep -milliseconds $DEFAULT_WAIT_TIME

    $wshell.SendKeys($email)

    start-sleep -milliseconds $DEFAULT_WAIT_TIME
    $wshell.SendKeys("{TAB}")
    start-sleep -milliseconds $DEFAULT_WAIT_TIME

    $wshell.SendKeys($zip)

    start-sleep -milliseconds $DEFAULT_WAIT_TIME
    $wshell.SendKeys("{TAB}")
    start-sleep -milliseconds $DEFAULT_WAIT_TIME


    # skip then check I have read req rad btn
    $wshell.SendKeys("{TAB}")
    start-sleep -milliseconds $DEFAULT_WAIT_TIME
    $wshell.SendKeys(" ")
    start-sleep -milliseconds $DEFAULT_WAIT_TIME


    # hit sumbit btn
    $wshell.SendKeys("{TAB}")
    start-sleep -milliseconds $DEFAULT_WAIT_TIME
    $wshell.SendKeys("{TAB}")
    start-sleep -milliseconds $DEFAULT_WAIT_TIME
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


$row_num = 280 #  <------------------------



$wshell = New-Object -ComObject wscript.shell;
$wshell.AppActivate($browser)


while($true)
{
    $user_input = Read-Host
        
    if ($user_input -eq 'f') # fail
    {
        Add-Content $FAILED_EMAILS_PATH $row_l[$row_num - 1].email 
        Write-Output "added email to fail file  " $row_l[$row_num - 1].email 
    }

    elseif ($user_input -eq 'e') # end
    {
        close_round
    }
    else
    {
        if ($user_input -eq 'r') # redo
        {
            $row_num -= 1
        }
        elseif ($user_input -eq 's') # start
        {
            Start-Process $BRAVE_EXE_PATH
            start-sleep -milliseconds 1000
            $wshell.SendKeys("{ENTER}") # get rid of "Restore Pages?"

            # open new foundation tab
            start-sleep -milliseconds $DEFAULT_WAIT_TIME
            $wshell.SendKeys("^{t}") # open new tab
            start-sleep -milliseconds $NEW_TAB_WAIT_TIME
            $wshell.SendKeys("$FOUNDATION_URL")
            start-sleep -milliseconds $DEFAULT_WAIT_TIME
            $wshell.SendKeys("{ENTER}")
            start-sleep -milliseconds 7000

        }


        Write-Host $row_l[$row_num].email
        write-host $row_num

        #start-sleep -milliseconds 2600
        init_submit_1_acc $row_l[$row_num].first_name $row_l[$row_num].last_name $row_l[$row_num].email $row_l[$row_num].zip
        $row_num += 1
    }
}

