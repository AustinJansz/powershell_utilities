<#
AUTHOR: Austin Clayton Jansz
DATE  : 2020-08-19
.SYNOPSIS
    A simple GUI interface so that the user can test connectivity.
.DESCRIPTION
    The user may run the test against pre-defined end points.
.NOTES
    This was built to exercise the use of GUI elements in PowerShell.
#>

using namespace System.Drawing

Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms

[int32]$powershell_version = (Get-Host).Version.Major

# Initializing the form
$app_form = New-Object System.Windows.Forms.Form
$app_form.ClientSize = [Size]::new(300, 285)
$app_form.BackColor = [ColorTranslator]::FromHtml("#DDDDDD")
# Set the title for the window
$app_form.Text = "PowerShell Ping Test"


# Adding title label
$label_title = New-Object System.Windows.Forms.Label
$label_title.AutoSize = $true
$label_title.Location = [Point]::new(20, 20)
# Set the title value
$label_title.Text = "PowerShell Ping Test"
$label_title.Font = [Font]::new("Arial", 13)


# Adding description label
$label_description = New-Object System.Windows.Forms.Label
$label_description.AutoSize = $true
$label_description.Location = [Point]::new(20, 50)
# Set the description value
$label_description.Text = "Select a DNS Provider to Test Connectivity"
$label_description.Font = [Font]::new("Arial", 10)


# Adding DNS dropdown box
$dropdown_connection = New-Object System.Windows.Forms.ComboBox
$dropdown_connection.Size = [Size]::new(200, 20)
$dropdown_connection.Location = [Point]::new(20, 70)
# Adding values to dropdown
$dropdown_connection.Text = "Select a provider [Default: Google]"
@("Google", "Cloudflare", "OpenDNS", "Quad9") | ForEach-Object {
    $dropdown_connection.Items.Add($_) | Out-Null
}


# Adding count box
$dropdown_count = New-Object System.Windows.Forms.ComboBox
$dropdown_count.Size = [Size]::new(40, 20)
$dropdown_count.Location = [Point]::new(240, 70)
# Adding values to dropdown
$dropdown_count.Text = "4"
@("1", "2", "3", "4") | ForEach-Object {
    $dropdown_count.Items.Add($_) | Out-Null
}


# Adding output area label
$label_output = New-Object System.Windows.Forms.Label
$label_output.Size = [Size]::new(260, 125)
$label_output.Location = [Point]::new(20, 100)
$label_output.BackColor = [ColorTranslator]::FromHtml("#FFFFFF")
# Set the output font
$label_output.Font = [Font]::new("Arial", 12)


# Adding submit button
$btn_submit = New-Object System.Windows.Forms.Button
$btn_submit.Size = [Size]::new(60, 30)
$btn_submit.Location = [Point]::new(220, 235)
$btn_submit.BackColor = [ColorTranslator]::FromHtml("#FFFFFF")
# Adding a descriptor for the button
$btn_submit.Text = "Start"
# Adding functionality to the button
$btn_submit.Add_Click(
    {
        # Initialize variables for the ping parameters
        [string]$connection_address = ""
        [int32]$connection_count = 4
        # Address switch based on dropdown
        Switch ($dropdown_connection.Text) {
            "Google" {$connection_address = "8.8.8.8"}
            "OpenDNS" {$connection_address = "208.67.222.222"}
            "CloudFlare" {$connection_address = "1.1.1.1"}
            "Quad9" {$connection_address = "9.9.9.9"}
            default {$connection_address = "8.8.8.8"}
        }
        # Count switch based on dropdown
        Switch ($dropdown_count.Text) {
            "1" {$connection_count = 1}
            "2" {$connection_count = 2}
            "3" {$connection_count = 3}
            "4" {$connection_count = 4}
            default {$connection_count = 4}
        }
        # Output the table headers
        $label_output.Text = ""
        $label_output.Text += "Status          Latency"
        $label_output.Text += "`n"
        $label_output.Text += "***********************"
        $label_output.Text += "`n"
        # Running the connectivity test
        @(1..$connection_count) | ForEach-Object {
            if(Test-Connection $connection_address -Count 1 -Quiet) {
                Test-Connection $connection_address -Count 1 | ForEach-Object {
                    $label_output.Text += "Success"
                    $label_output.Text += "        "
                    # Switch between response time and latency based on version
                    if($powershell_version -lt 7){
                        $label_output.Text += $_.ResponseTime
                    }
                    else {
                        $label_output.Text += $_.Latency
                    }
                    $label_output.Text += "`n"
                }
            }
            else {
                $label_output.Text += "Failure        *`n"
            }
            Start-Sleep -Seconds 1
        }
    }
)


# Add the form controls to the form
$app_form.controls.AddRange(
    @(
        $label_title,
        $label_description,
        $dropdown_connection,
        $dropdown_count,
        $btn_submit,
        $label_output
    )
)
# Show form to the user
$app_form.ShowDialog()