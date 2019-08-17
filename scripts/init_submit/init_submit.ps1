



$DEFAULT_WAIT_TIME = 100 #miliseconds



function init_submit_1_acc
{
    param ( [parameter(Mandatory=$true)] [string] $first_name,
            [parameter(Mandatory=$true)] [String] $last_name,
            [parameter(Mandatory=$true)] [String] $email,
            [parameter(Mandatory=$true)] [String] $zip)

    try
    {
     
        $wshell = New-Object -ComObject wscript.shell;
        $wshell.AppActivate('Chrome')
        #$wshell.AppActivate('notepad')

        #sleep .5

        # get to first radio btn
        For ($i=0; $i -le 23; $i++) {
    
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
    catch [System.Exception]
    {
        Write-Both -Foreground "Red" "$($_.Exception.GetType().FullName)"
        Write-Both -Foreground "Red" $($MyInvocation.MyCommand.ToString() + " line " +  $MyInvocation.ScriptLineNumber.ToString()`
                   + " " + [string]$Error[0])
    }
}











init_submit_1_acc "bob" "man" "111@gmail.com" "10001"

