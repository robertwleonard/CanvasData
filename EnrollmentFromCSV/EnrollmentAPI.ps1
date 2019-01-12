# Set up your initializers
$url="https://yourschool.instructure.com/api/v1"
$security_token= $Env:CanvasAPI # API Key stored as a windows environment variable
$header = @{"Authorization"="Bearer $security_token"}
$userfile = Import-Csv -Path "C:\dev\canvas\computer_science_club.csv"
$courseNumber = "96148" # Make this match your course from Canvas

# Loop through every line in our CSV file
foreach ($u in $userfile)
{
    $userId = $u.InternalId
    $status = $u.Status

    # Set the API body with the enrollment information
    $body=  @{
        "enrollment[user_id]"="sis_user_id:$userId"
        "enrollment[type]"="StudentEnrollment"
        "enrollment[notify]"="false"
        "enrollment[enrollment_state]"=$status
    }

    Write-Host Add student $userId; #Log the user ID to the screen
    Invoke-WebRequest -Headers $header -Body $body -Method Post -Uri ("$url/courses/$courseNumber/enrollments")
}
