# import-workitems.ps1
param(
    [string]$PAT_TOKEN,
    [string]$STUDENT_INITIALS
)

$organization = "https://devopsclassroom.visualstudio.com"
$projectName = "Week4-Lab-Demo$STUDENT_INITIALS"
$csvPath = "./Additional_User_Stories_and_Tasks_SpareChangeApp.csv"
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$PAT_TOKEN"))

# Check existing stories
$checkUrl = "$organization/$projectName/_apis/wit/wiql?api-version=6.0"
$query = @{
    query = "SELECT [System.Id] FROM WorkItems WHERE [System.WorkItemType] = 'User Story' AND [System.TeamProject] = '$projectName'"
} | ConvertTo-Json -Depth 3

Write-Host "Using project name Local Var: $projectName"
Write-Host "Using project name PARAMETER: $PROJECT_NAME"
Write-Host "Query URL: https://devopsclassroom.visualstudio.com/$projectName/_apis/wit/wiql?api-version=6.0"

$response = Invoke-RestMethod -Uri $checkUrl -Method Post -Headers @{Authorization=("Basic $base64AuthInfo")} -ContentType "application/json" -Body $query
if ($response.workItems.Count -gt 10) {
    Write-Host $response.workItems.Count
    Write-Host "More than 10 user stories exist. ($response.workItems.Count) Skipping import."
    exit 0
}

# Parse CSV and group tasks under stories
$data = Import-Csv $csvPath
$stories = @{}

Write-Host "Stories and tasks to add: $($data.Count)"

foreach ($row in $data) {
    $storyId = $row.'User Story ID'
    if (-not $stories.ContainsKey($storyId)) {
        $stories[$storyId] = @{
            title = $row.'User Story Title'
            points = $row.'Story Points'
            tasks = @()
        }
    }
    $stories[$storyId].tasks += @{
        title = $row.'Task Title'
        estimate = $row.'Original Estimate (hrs)'
    }
}


Write-Host "Stories and tasks to add: $($stories.Count)"

foreach ($storyKey in $stories.Keys) {
    $story = $stories[$storyKey]
    $storyBody = @(
        @{ op = "add"; path = "/fields/System.Title"; value = $story.title },
        @{ op = "add"; path = "/fields/System.WorkItemType"; value = "User Story" },
        @{ op = "add"; path = "/fields/Microsoft.VSTS.Scheduling.StoryPoints"; value = [int]$story.points }
    ) | ConvertTo-Json -Depth 5

    $storyResponse = Invoke-RestMethod -Uri "$organization/$projectName/_apis/wit/workitems/%24User%20Story?api-version=6.0" `
        -Method Patch -Headers @{Authorization=("Basic $base64AuthInfo")} -ContentType "application/json-patch+json" -Body $storyBody

    $parentId = $storyResponse.id
    
    Write-Host "Created story ${parentId}: $($story['title'])"

    foreach ($task in $story.tasks) {
        $taskBody = @(
            @{ op = "add"; path = "/fields/System.Title"; value = $task.title },
            @{ op = "add"; path = "/fields/System.WorkItemType"; value = "Task" },
            @{ op = "add"; path = "/fields/Microsoft.VSTS.Scheduling.OriginalEstimate"; value = [int]$task.estimate },
            @{ op = "add"; path = "/relations/-"; value = @{ rel = "System.LinkTypes.Hierarchy-Reverse"; url = "$organization/_apis/wit/workItems/$parentId" } }
        ) | ConvertTo-Json -Depth 5

        $taskResponse = Invoke-RestMethod -Uri "$organization/$projectName/_apis/wit/workitems/%24Task?api-version=6.0" `
            -Method Patch -Headers @{Authorization=("Basic $base64AuthInfo")} -ContentType "application/json-patch+json" -Body $taskBody

        Write-Host "Created task $($taskResponse.id): $($task.title)"
    }
}
