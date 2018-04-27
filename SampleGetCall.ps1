# Enter your school's credentials, API Key is stored in a
# Window's environment variable called "CanvasAPI"
#
# You could also paste the code here in quotes, but be careful
# NEVER to share that code. IE: "enter-api-key-here"
$url="https://EnterYourSchool.instructure.com/api/v1"
$security_token = $Env:CanvasAPI
$header = @{"Authorization"="Bearer $security_token"}

# Create an ArrayList to manage the API information
$CourseList = New-Object System.Collections.ArrayList($null)

# Make the API call to list all the courses you're enrolled in
$courses = Invoke-RestMethod -Uri "$url/users/self/courses/" -Headers $header

# Loop through each course
foreach($course in $courses) {
    # Create an object to store the information
    $newRecord = [PSCustomObject]@{
        'id' = $course.id
        'account_id'=$course.account_id
        'calendar'=$course.calendar.ics
        'name'=$course.name
    }

    # Add the custom object to our ArrayList
    $CourseList.Add($newRecord) | Out-Null
}

# Export this array into a CSV file, timestamp the file (2018-03 for instance)
$CourseList | Export-Csv -NoTypeInformation "./sample/MyCourseListing_$((Get-Date).ToString('yyyy-MM')).csv"
