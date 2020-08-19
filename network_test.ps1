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


# Adding dropdown box
$dropdown_connection = New-Object System.Windows.Forms.ComboBox
$dropdown_connection.Size = [Size]::new(260, 20)
$dropdown_connection.Location = [Point]::new(20, 70)
# Adding values to dropdown
$dropdown_connection.Text = ""
@("Google", "Cloudflare", "OpenDNS", "Quad9") | ForEach-Object {
    $dropdown_connection.Items.Add($_) | Out-Null
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
        $label_output.Text = ""
        $label_output.Text += "Status          Latency"
        $label_output.Text += "`n"
        $label_output.Text += "***********************"
        $label_output.Text += "`n"
        $connection_address = ""
        # IP Address switch based on the dropdown value selected
        Switch ($dropdown_connection.Text)
        {
            "Google" {$connection_address = "8.8.8.8"}
            "OpenDNS" {$connection_address = "208.67.222.222"}
            "CloudFlare" {$connection_address = "1.1.1.1"}
            "Quad9" {$connection_address = "9.9.9.9"}
        }
        # Run test and output values to the output label
        Test-Connection $connection_address | ForEach-Object {
            $label_output.Text += $_.Status
            $label_output.Text += "        "
            $label_output.Text += $_.Latency
            $label_output.Text += "`n"
        }
    }
)


# Add the form controls to the form
$app_form.controls.AddRange(
    @(
        $label_title,
        $label_description,
        $dropdown_connection,
        $btn_submit,
        $label_output
    )
)
# Show form to the user
$app_form.ShowDialog()