# Week 12 Lab: Advanced Dashboard with Terraform-Driven Metrics

## Lab Overview

**Purpose**  
In Week 12 of the "DevOps for Executive Leadership" workshop, you’ll integrate a prebuilt Terraform configuration into your Week 8 Azure DevOps project at `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX` (replace `XX` with your initials). This configuration provisions an AWS EC2 instance and deploys a basic web app, intentionally introducing deployment failures and slow deploys. You’ll enhance your Week 8 dashboard to visualize deployment frequency, history, failure rates, and estimate accuracy, providing a comprehensive view for executive oversight. An Azure alternate version will follow once the AWS setup is validated.

**What You’ll Accomplish**  
- Import Stories and Tasks with varying estimates
- Integrate a Terraform config to deploy an EC2 instance and web app with failures and delays.  
- Update your pipeline to trigger Terraform and log advanced metrics.  
- Enhance your Week 8 dashboard with deployment history, frequency, and estimate accuracy.  
- Interpret results for strategic insights, preparing an Azure alternate.

**Estimated Time**  
About **90-120 minutes**:  
- 20 min: Prepare environment & integrate Terraform  
- 25 min: Configure & run pipeline with failures  
- 30 min: Enhance & test dashboard  
- 25 min: Validate & interpret results  
- 10-15 min: Wrap-up & Azure planning  

**Lab Structure**  
Step-by-step instructions to extend your Week 8 project, detailed at [https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week12Lab.md](https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week12Lab.md). Refer to Week 4 at [labs/Week4Lab.md](https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week4Lab.md) and Week 8 at [labs/Week8Lab.md](https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week8Lab.md). Download the completed AWS solution from [https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week12/solution](https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week12/solution).

---

## Prerequisites

- **Azure DevOps Project**: Your Week 8 project at `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX`.  
- **AWS Account**: With IAM credentials (Access Key ID, Secret Access Key) for Terraform.  
- **Terraform Installed**: Download from [terraform.io](https://www.terraform.io/downloads.html).  
- **Week 8 Sample App**: [https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8](https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8).  
- **Git Basics**: Familiarity with cloning, branching, merging.

---
# Exercise 1: Populate Project Board
## Step 1: Download Import Script and Stories csv
## 📥 Upload Required Lab Files to Azure DevOps Project Repository

These steps will guide you through downloading the necessary files from GitHub and uploading them to your own Azure DevOps repository (`Week4-Lab-DemoXX`), using your initials in the project name.

---

## 🔹 Step 1: Download Files from GitHub

1. Open the following GitHub folder in your browser:  
   👉 https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week12/files

2. Download both of the following files:
   - `import-workitems.ps1`
   - `Additional_User_Stories_and_Tasks_SpareChangeApp.csv`

   You can do this by:
   - Clicking each filename.
   - Clicking the **“Download raw file”** button (right-click > “Save as...” recommended).

---

## 🔹 Step 2: Go to Your Azure DevOps Repo

1. Open your browser and sign in to:  
   👉 https://devopsclassroom.visualstudio.com

2. Navigate to your project:  
   💡 `Week4-Lab-DemoXX` — where `XX` is your initials (e.g., `Week4-Lab-DemoJD`).

3. In the left sidebar, click **Repos** → **Files**.

---

## 🔹 Step 3: Upload the Files

1. Click the **“Upload file(s)”** button (upper right).
2. Drag and drop or browse to select both downloaded files:
   - `import-workitems.ps1`
   - `Additional_User_Stories_and_Tasks_SpareChangeApp.csv`
3. Confirm that the **Target folder** is `/` (root of the repo).
4. In the **Commit message**, enter something like:  
   `Added import script and user stories/tasks CSV for Week 12`
5. Click **“Commit”**.

---

## ✅ Done!

You have now uploaded the required lab files to your Azure DevOps project. The pipeline will be able to access these files in the next steps.

Next: Proceed to review or update your `azure-pipelines.yml` to run the script if needed.

# 🛠️ Exercise 2: Update Your Azure Pipeline

These steps will guide you through updating your pipeline YAML file to include importing user stories and updating estimate accuracy in your Azure DevOps project.

---

## 🔹 Step 1: Go to Your Project Repo in Azure DevOps

1. Open your browser and go to:  
   👉 https://devopsclassroom.visualstudio.com

2. Click on your project:  
   💡 Example: `Week4-Lab-DemoXX` — where `XX` are your initials.

3. In the left menu, select:  
   **Repos** → **Files**

---

## 🔹 Step 2: Edit the `azure-pipelines.yml` File

1. In the file list, click on `azure-pipelines.yml`.

2. Click the **“Edit”** button (top right).

3. Delete the existing YAML content.

4. Copy and paste the full code below:

<details>
<summary>📋 Click to expand and copy YAML</summary>

```yaml
trigger:
  - main

pool:
  vmImage: 'ubuntu-latest'

variables:
  PROJECT_NAME: 'Week4-Lab-Demo$(STUDENT_INITIALS)'

steps:
- checkout: self
  displayName: 'Checkout Code'

- task: PowerShell@2
  name: CheckAndImportStories
  displayName: 'Check for Work Items and Import if Needed'
  inputs:
    targetType: 'inline'
    script: |
      Write-Host "Checking for existing User Stories in project: $(PROJECT_NAME)"

      $uri = "https://devopsclassroom.visualstudio.com/$(PROJECT_NAME)/_apis/wit/wiql?api-version=6.0"
      $query = @{
        query = "SELECT [System.Id] FROM WorkItems WHERE [System.WorkItemType] = 'User Story' AND [System.TeamProject] = '$(PROJECT_NAME)'"
      } | ConvertTo-Json -Depth 5

      $headers = @{
        Authorization = "Basic " + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$(PAT_TOKEN)"))
        "Content-Type" = "application/json"
      }

      $response = Invoke-RestMethod -Uri $uri -Method Post -Headers $headers -Body $query -ErrorAction Stop

      if ($response.workItems.Count -lt 6) {
        Write-Host "Less than 6 User Stories found. Importing now..."
        ./import-workitems.ps1 -ProjectName "$(PROJECT_NAME)" -PatToken "$(PAT_TOKEN)"
      } else {
        Write-Host "$($response.workItems.Count) User Stories already exist. Skipping import."
      }

- script: |
    echo "Starting build and test..."
    START_TIME=$(date +%s)
    npm install
    npm test
    END_TIME=$(date +%s)
    BUILD_DURATION=$(( END_TIME - START_TIME ))
    echo "##vso[task.setvariable variable=BuildDurationSeconds]$BUILD_DURATION"
    echo "Build duration: $BUILD_DURATION seconds"
    if [ $? -eq 0 ]; then
      echo "##vso[task.setvariable variable=TestSuccess]true"
      echo "Tests passed"
    else
      echo "##vso[task.setvariable variable=TestSuccess]false"
      echo "Tests failed"
    fi
  displayName: 'Build and Test'
  continueOnError: true

- script: |
    echo "Packaging application..."
    mkdir -p dist
    cp index.js package.json dist/
    zip -r app.zip dist/
  displayName: 'Package Application'

- publish: $(System.DefaultWorkingDirectory)/app.zip
  artifact: 'app'
  displayName: 'Publish Artifact'

- script: |
    echo "Fetching tasks and updating Estimate Accuracy..."
    echo "PAT_TOKEN is set to: [REDACTED]"
    RESPONSE=$(curl -u :"$PAT_TOKEN" -H "Content-Type: application/json"       "https://devopsclassroom.visualstudio.com/$(PROJECT_NAME)/_apis/wit/wiql?api-version=6.0"       -d "{"query": "SELECT [System.Id], [System.Title], [Microsoft.VSTS.Scheduling.OriginalEstimate], [Microsoft.VSTS.Scheduling.CompletedWork] FROM WorkItems WHERE [System.WorkItemType] = 'Task' AND [System.State] = 'Closed' AND [System.TeamProject] = '$(PROJECT_NAME)'"}"       --silent --show-error)
    echo "API Response: $RESPONSE"
    if echo "$RESPONSE" | grep -q "<html>"; then
      echo "Error: Received HTML redirect, PAT may be invalid or expired"
      exit 1
    fi
    echo "$RESPONSE" | jq -r '.workItems[] | [.id] | join(" ")' > task_ids.txt || { echo "Failed to parse JSON response"; exit 1; }
    for TASK_ID in $(cat task_ids.txt); do
      TASK_DATA=$(curl -u :"$PAT_TOKEN" -H "Content-Type: application/json"         "https://devopsclassroom.visualstudio.com/$(PROJECT_NAME)/_apis/wit/workitems/$TASK_ID?api-version=6.0"         --silent --show-error)
      echo "Task $TASK_ID Data: $TASK_DATA"
      ORIGINAL_ESTIMATE=$(echo "$TASK_DATA" | jq -r '.fields["Microsoft.VSTS.Scheduling.OriginalEstimate"] // 0')
      COMPLETED_WORK=$(echo "$TASK_DATA" | jq -r '.fields["Microsoft.VSTS.Scheduling.CompletedWork"] // 0')
      ESTIMATE_ACCURACY=$(echo "scale=2; $ORIGINAL_ESTIMATE - $COMPLETED_WORK" | bc)
      echo "Task $TASK_ID: Original=$ORIGINAL_ESTIMATE, Completed=$COMPLETED_WORK, Accuracy=$ESTIMATE_ACCURACY"
      curl -u :"$PAT_TOKEN" -X PATCH -H "Content-Type: application/json-patch+json"         "https://devopsclassroom.visualstudio.com/$(PROJECT_NAME)/_apis/wit/workitems/$TASK_ID?api-version=6.0"         -d "[{"op": "add", "path": "/fields/Custom.EstimateAccuracy", "value": $ESTIMATE_ACCURACY}]"         --silent --show-error || echo "Failed to update Task $TASK_ID"
    done
  displayName: 'Update Task Estimate Accuracy'
  env:
    PAT_TOKEN: $(PAT_TOKEN)
    STUDENT_INITIALS: $(STUDENT_INITIALS)

- script: |
    echo "Pipeline Metrics:"
    echo "BuildDurationSeconds=$(BuildDurationSeconds)"
    echo "TestSuccess=$(TestSuccess)"
  displayName: 'Log Metrics'
```

</details>

---

## 🔹 Step 3: Save and Commit Changes

1. Scroll to the bottom of the editor.
2. Enter a commit message like:  
   `Updated pipeline to include story/task import and accuracy updates`
3. Click **“Commit”**.

---

## ✅ Done!

Your pipeline is now updated. The next time it runs, it will:
- Check for existing User Stories.
- Import new stories and tasks only if needed.
- Run the build/test process.
- Update task estimate accuracy.

# Exercise 3:  Dashboard Updates

## Step 1: Enhance the Dashboard

1. **Create New Queries**  
   - At `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX`, go to "Boards" > "Queries":  
     - **Query 1: Deployment History**  
       - Name: "Deployment History".  
       - Filter: Build, Pipeline = Week4Lab, last 10 runs.  
       - Columns: Build Number, Status, Duration.  
       - Save.  
     - **Query 2: Task Estimates** (from Week 8, reused).  

2. **Update Week 8 Dashboard**  
   - Go to "Overview" > "Dashboards", open "Week4Lab Dashboard".  
   - Click "Edit":  
     - **Keep Existing**: Build History, Lead Time, Pipeline Overview, Task Estimates.  
     - **Add Deployment History**:  
       - Add "Query Results" widget.  
       - Query: "Deployment History".  
       - Chart Type: Table (shows run status, duration).  
       - Size: 4x2.  
     - **Update Pipeline Overview**: Adjust to show last 10 runs for frequency trends.  
   - Save.  
   - **Why**: Adds deployment history and leverages Week 4 estimate data.

3. **Test Dashboard**  
   - Trigger another pipeline run.  
   - Refresh dashboard:  
     - Deployment History shows run successes/failures.  
     - Frequency increases, Lead Time reflects delays, Task Estimates remain static.  
   - Compare with [https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week12/solution](https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week12/solution).

---

## Step 2: Validate and Interpret

1. **Validate Metrics**  
    - Check logs and dashboard:  
      - Deployment Frequency: ~5-10 runs, varying success.  
      - Failure Rate: ~50% from Terraform, plus Node.js test failures.  
      - Lead Time: ~40s+ due to delays.  
      - Estimate Accuracy: Task 1 (100%), Task 2 (67%) from Week 4.  
    - **Why**: Confirms rich data for analysis.

2. **Interpret Results**  
    - Strategic insights:  
      - High failure rate (50%) suggests deployment reliability issues.  
      - Long lead times (40s+) indicate optimization needs.  
      - Estimate accuracy shows planning gaps (Task 2 overrun).  
    - Executive summary: "Frequent but unreliable deploys with planning inaccuracies require process refinement."  
    - **Why**: Provides actionable leadership insights.

# Exercise 3: Terraform (Advanced / Optional)

## Step 1: Prepare Your Environment

1. **Log In to Your Week 8 Project**  
   - Go to `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX`, log in as `DevOpsStudent@Outlook.com` (ask the instructor for the password).  
   - Verify Week 8 setup: repo with Node.js app, pipeline with DORA metrics, dashboard with estimate accuracy.

2. **Clone Your Week 8 Repo Locally**  
   - In a terminal:  
     ```bash
     git clone https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX/_git/Week4Lab
     cd Week4Lab
     ```

3. **Add Terraform Config**  
   - Create a `terraform/` folder in your repo.  
   - Add `main.tf` with this prebuilt config (from [https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week12](https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week12)):  
     ```hcl
     provider "aws" {
       region = "us-west-2"
     }

     resource "aws_instance" "web_app" {
       ami           = "ami-0c55b159cbfafe1f0" # Ubuntu 20.04
       instance_type = "t2.micro"
       user_data     = <<-EOF
         #!/bin/bash
         apt-get update
         apt-get install -y nginx
         # Simulate slow deploy (30s delay)
         sleep 30
         echo "<h1>Hello from Week 12</h1>" > /var/www/html/index.html
         # Random failure (50% chance)
         if [ $((RANDOM % 2)) -eq 0 ]; then
           echo "Simulated deployment failure" >&2
           exit 1
         fi
         systemctl restart nginx
       EOF
       tags = {
         Name = "Week12-WebApp"
       }
     }

     output "instance_ip" {
       value = aws_instance.web_app.public_ip
     }
     ```
   - **Why**: Provisions an EC2 instance with a web app, introduces a 30-second delay, and fails 50% of the time.

4. **Commit Terraform Config**  
   - Run:  
     ```bash
     git add terraform/
     git commit -m "Added Week 12 Terraform config"
     git push origin main
     ```

---

## Step 2: Update Pipeline with Terraform

5. **Modify `azure-pipelines.yml`**  
   - At `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX`, update your pipeline:  
     ```yaml
     trigger:
       - main

     pool:
       vmImage: 'ubuntu-latest'

     steps:
     - checkout: self
       displayName: 'Checkout Code'

     - script: |
         curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
         sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
         sudo apt-get update && sudo apt-get install terraform
       displayName: 'Install Terraform'

     - script: |
         cd terraform
         terraform init
         terraform apply -auto-approve
       displayName: 'Deploy EC2 with Terraform'
       env:
         AWS_ACCESS_KEY_ID: $(AWS_ACCESS_KEY_ID)
         AWS_SECRET_ACCESS_KEY: $(AWS_SECRET_ACCESS_KEY)
       continueOnError: true

     - script: |
         echo "Deploying Node.js app..."
         START_TIME=$(date +%s)
         npm install
         npm test || echo "TestsFailed=1" >> $GITHUB_ENV
         sleep 10  # Simulate additional delay
         END_TIME=$(date +%s)
         echo "LeadTimeMinutes=$(( (END_TIME - START_TIME) / 60 ))" >> $GITHUB_ENV
         echo "Availability=99" >> $GITHUB_ENV
       displayName: 'Deploy Node.js App'
       condition: eq(variables['TestsFailed'], '')

     - script: |
         echo "Pipeline Metrics:"
         echo "LeadTimeMinutes=${{ variables.LeadTimeMinutes }}"
         echo "ChangeFailureRate=5"  # Static for Node.js, Terraform failures vary
         echo "MTTRMinutes=0"       # Simplified for demo
         echo "Availability=${{ variables.Availability }}"
       displayName: 'Log Metrics'
     ```
   - Add AWS credentials as pipeline variables (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`) in Azure DevOps under "Pipelines" > "Library".  
   - Commit: "Updated pipeline with Terraform deploy".  
   - **Why**: Integrates Terraform, adds delays, and allows failures to propagate.

6. **Run Pipeline Multiple Times**  
   - Trigger 5+ runs manually to generate history (some will fail due to Terraform’s random exit).  
   - Check logs for failures and lead times (e.g., ~40s with Terraform + Node.js delays).

---
# Exercise 4: Being Extra

## Step 1: Plan Azure Alternate

1. **Azure Version Outline**  
    - Replace AWS EC2 with Azure VM:  
      - Use `azurerm_virtual_machine` in Terraform.  
      - Deploy same web app with delays/failures.  
    - Update pipeline: Replace AWS credentials with Azure (`AZURE_CLIENT_ID`, etc.).  
    - Dashboard: Same queries/widgets, adjusted for Azure pipeline data.  
    - Next Steps: Test AWS version, then adapt Terraform for Azure (e.g., `week12/azure/` folder).

---

## Wrap-Up

- Save your work at `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX`.  
- Review at [https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week12Lab.md](https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week12Lab.md).  
- Download the AWS solution from [https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week12/solution](https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week12/solution).  
