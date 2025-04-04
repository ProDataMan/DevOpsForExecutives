# Week 8 Lab: Building an Executive Dashboard

## Lab Overview

**Purpose**  
In Week 8 of the "DevOps for Executive Leadership" workshop (Page 9), you’ll enhance your Week 4 Azure DevOps project at `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX` (replace `XX` with your initials) by integrating a sample Node.js app from [https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8](https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8). You’ll switch your project to the "DevOpsClassroom Agile" process, update the pipeline to build, test, package the app, and populate the custom "Estimate Accuracy" field for tasks, then expand your Week 4 dashboard with Build Duration, Test Success Rate, Story Points Completed, and Estimate Accuracy metrics.

**What You’ll Accomplish**  
- Switch your project from Agile to "DevOpsClassroom Agile" process.  
- Upload Week 8 sample app files.  
- Update the pipeline to generate Build Duration and Test Success Rate, and calculate/update Estimate Accuracy for tasks in your project.  
- Expand the dashboard with these metrics.  
- Interpret results for leadership insights.

**Estimated Time**  
About **90-120 minutes**:  
- 15 min: Switch process & prepare environment  
- 25 min: Configure & run pipeline (with API updates)  
- 30 min: Build & test dashboard  
- 20 min: Validate & interpret results  
- 10-15 min: Wrap-up & reflection  

**Lab Structure**  
Instructions at [https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week8Lab.md](https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week8Lab.md). Refer to Week 4 at [labs/Week4Lab.md](https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week4Lab.md). Solution at [https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8/solution](https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8/solution).

---

## Prerequisites

- **Azure DevOps Project**: Your Week 4 project at `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX`, where `XX` is your initials (e.g., `JD` for John Doe), currently using the Agile process.  
- **Sample App**: [https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8](https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8).  
- **Lab Machine**: Provided with Git and Git Bash installed.  
- **PAT**: Personal Access Token with "Work Items - Read/Write" scope (create one or use instructor-provided `PAT_TOKEN`).  
- **Custom Process**: "DevOpsClassroom Agile" inherited process with "Estimate Accuracy" (integer, `Custom.EstimateAccuracy`) added to Task type (pre-created by instructor).  
- **Permissions**: Project Collection Administrator access or instructor assistance to switch processes.  
- **Web Browser**: Chrome, Edge, or Firefox.

---

## Step 1: Switch Process to "DevOpsClassroom Agile"

1. **Log In to Azure DevOps**  
   - Open your browser, go to `https://devopsclassroom.visualstudio.com`, log in with `DevOpsStudent@Outlook.com` (ask instructor for password).

2. **Verify Current Process**  
   - Go to your project: `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX` (replace `XX` with your initials).  
   - Click "Project settings" (bottom-right gear icon) > "Overview".  
   - Confirm the current process is "Agile". If not, note the process and inform the instructor.

3. **Switch to "DevOpsClassroom Agile"**  
   - Go to "Organization settings" (top-left Azure DevOps logo > "Organization settings" at bottom-left).  
   - Click "Process" under "Boards" in the left pane.  
   - Find "DevOpsClassroom Agile" (under "Agile" if inherited from it), click it to open details.  
   - Click the ellipsis (`…`) next to "DevOpsClassroom Agile" > "Change team projects to use DevOpsClassroom Agile".  
   - In the dialog:  
     - Under "Available projects," check `Week4-Lab-DemoXX` (with your initials).  
     - Click "OK" to switch.  
   - **If Option Missing**:  
     - Go to "Agile" process > "Projects" tab > Find `Week4-Lab-DemoXX` > Ellipsis (`…`) > "Change process" > Select "DevOpsClassroom Agile" > "Save".  
     - If still not visible, ask instructor: “Can you switch Week4-Lab-DemoXX to DevOpsClassroom Agile?”

4. **Verify Switch**  
   - Back in your project ("Project settings" > "Overview"), confirm the process is now "DevOpsClassroom Agile".  
   - "Boards" > "Work Items" > Open a Task (e.g., from Week 4) > Check for "Estimate Accuracy" field (initially blank).

---

## Step 2: Prepare Your Environment

5. **Verify Week 4 Setup**  
   - In `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX`:  
     - "Repos" > "Files": `hello.sh`, `README.md`, `azure-pipelines.yml`.  
     - "Boards" > "Work Items": 2 user stories (2 points each), 2 tasks (e.g., Task 1: 2h/2h, Task 2: 2h/3h, state "Closed").  
     - "Overview" > "Dashboards": "Week4Lab Dashboard".

6. **Option 1: Clone and Upload via Git Bash**  
   - Start menu > "Git Bash".  
   - Create folder:  
     ```bash
     mkdir ~/Desktop/Week8Lab
     cd ~/Desktop/Week8Lab
     ```
   - Clone repos:  
     ```bash
     git clone https://github.com/ProDataMan/DevOpsForExecutives.git
     git clone https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX/_git/Week4Lab
     ```
     - Replace `XX` with your initials in the second command.  
   - Copy files:  
     ```bash
     cp DevOpsForExecutives/week8/index.js Week4Lab/
     cp DevOpsForExecutives/week8/package.json Week4Lab/
     cp DevOpsForExecutives/week8/test.js Week4Lab/
     cp DevOpsForExecutives/week8/azure-pipelines.yml Week4Lab/
     ```
   - Upload:  
     ```bash
     cd Week4Lab
     git add .
     git commit -m "Uploaded Week 8 sample app files"
     git push origin main
     ```

7. **Option 2: Download and Upload Manually**  
   - Go to [https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8](https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8).  
   - Files:  
     - **`index.js`**:  
       ```javascript
       const express = require('express');
       const app = express();
       app.get('/', (req, res) => res.send('Hello, DevOps!'));
       module.exports = app;
       if (require.main === module) {
         app.listen(3000, () => console.log('App running on port 3000'));
       }
       ```
     - **`package.json`**:  
       ```json
       {
         "name": "week8-app",
         "version": "1.0.0",
         "dependencies": { "express": "^4.17.1" },
         "scripts": { "test": "node test.js" }
       }
       ```
     - **`test.js`**:  
       ```javascript
       const app = require('./index');
       const rand = Math.random();
       if (rand < 0.2) {
         console.log("Test failed: Simulated error");
         process.exit(1);
       }
       console.log("Test passed: Express app loaded");
       ```
     - **`azure-pipelines.yml`**: See Step 3.  
   - Upload: "Repos" > "Files" > "Upload file(s)", select all, "Overwrite", commit: "Uploaded Week 8 sample app files".

---

## Step 3: Configure the Pipeline

8. **Set Up Pipeline Variables**  
   - Go to your pipeline: "Pipelines" > "Builds" > "Week4Lab" > "Edit" > "Variables".  
   - Add or verify the following variables:  
     - **Name**: `PAT_TOKEN`, **Value**: [Your PAT token, e.g., `abc123...xyz789`], **Secret**: Checked.  
       - **Create PAT (if needed)**: Profile (top-right) > "Personal access tokens" > "+ New Token", Name: `Week8Lab-Pipeline`, Expiration: 30 days, Scope: "Work Items (Read & Write)", copy token, add here.  
     - **Name**: `STUDENT_INITIALS`, **Value**: Your initials (e.g., `JD` for John Doe), **Secret**: Unchecked.  
   - Save the changes.  
   - **Note**: Both variables are set here in the GUI, not in the YAML file, for consistency and security.

9. **Review `azure-pipelines.yml`**  
   - Ensure it matches the YAML below (uses `STUDENT_INITIALS` from pipeline variables):  
     ```yaml
     trigger:
       - main

     pool:
       vmImage: 'ubuntu-latest'

     steps:
     - checkout: self
       displayName: 'Checkout Code'

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
         PROJECT_NAME="Week4-Lab-Demo$STUDENT_INITIALS"
         RESPONSE=$(curl -u :"$PAT_TOKEN" -H "Content-Type: application/json" \
           "https://devopsclassroom.visualstudio.com/$PROJECT_NAME/_apis/wit/wiql?api-version=6.0" \
           -d "{\"query\": \"SELECT [System.Id], [System.Title], [Microsoft.VSTS.Scheduling.OriginalEstimate], [Microsoft.VSTS.Scheduling.CompletedWork] FROM WorkItems WHERE [System.WorkItemType] = 'Task' AND [System.State] = 'Closed' AND [System.TeamProject] = '$PROJECT_NAME'\"}" \
           --silent --show-error)
         echo "API Response: $RESPONSE"
         if echo "$RESPONSE" | grep -q "<html>"; then
           echo "Error: Received HTML redirect, PAT may be invalid or expired"
           exit 1
         fi
         echo "$RESPONSE" | jq -r '.workItems[] | [.id] | join(" ")' > task_ids.txt || { echo "Failed to parse JSON response"; exit 1; }
         for TASK_ID in $(cat task_ids.txt); do
           TASK_DATA=$(curl -u :"$PAT_TOKEN" -H "Content-Type: application/json" \
             "https://devopsclassroom.visualstudio.com/$PROJECT_NAME/_apis/wit/workitems/$TASK_ID?api-version=6.0" \
             --silent --show-error)
           echo "Task $TASK_ID Data: $TASK_DATA"
           ORIGINAL_ESTIMATE=$(echo "$TASK_DATA" | jq -r '.fields["Microsoft.VSTS.Scheduling.OriginalEstimate"] // 0')
           COMPLETED_WORK=$(echo "$TASK_DATA" | jq -r '.fields["Microsoft.VSTS.Scheduling.CompletedWork"] // 0')
           ESTIMATE_ACCURACY=$(echo "scale=2; $ORIGINAL_ESTIMATE - $COMPLETED_WORK" | bc)
           echo "Task $TASK_ID: Original=$ORIGINAL_ESTIMATE, Completed=$COMPLETED_WORK, Accuracy=$ESTIMATE_ACCURACY"
           curl -u :"$PAT_TOKEN" -X PATCH -H "Content-Type: application/json-patch+json" \
             "https://devopsclassroom.visualstudio.com/$PROJECT_NAME/_apis/wit/workitems/$TASK_ID?api-version=6.0" \
             -d "[{\"op\": \"add\", \"path\": \"/fields/Custom.EstimateAccuracy\", \"value\": $ESTIMATE_ACCURACY}]" \
             --silent --show-error || echo "Failed to update Task $TASK_ID"
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
   - Edit if needed: "Repos" > "Files" > `azure-pipelines.yml` > Edit, paste, commit: "Updated pipeline for GUI variables".
   - **Notes**:  
     - Ensure `PAT_TOKEN` and `STUDENT_INITIALS` are set in pipeline variables before running.  
     - `PAT_TOKEN` is secret; `STUDENT_INITIALS` is not.

10. **Run the Pipeline**  
    - "Pipelines" > "Builds" > "Week4Lab" > "Run pipeline" > "Run".  
    - Wait ~5-10 minutes.  
    - Check logs:  
      - "Build and Test": `Build duration: X seconds`, `TestSuccess=true/false` (20% failure chance).  
      - "Update Task Estimate Accuracy": `Task X: Original=Y, Completed=Z, Accuracy=W` (only for your project’s tasks).  
      - "Log Metrics": `BuildDurationSeconds=X`, `TestSuccess=true/false`.

---

## Step 4: Build the Dashboard

11. **Update Your Week 4 Dashboard**  
    - "Overview" > "Dashboards" > "Week4Lab Dashboard".

12. **Create Queries for Metrics**  
    - "Boards" > "Queries":  
      - **Query 1: Task Estimates**  
        - "New Query", name: "Task Estimates".  
        - Filters: "Work Item Type" = "Task", "State" = "Closed", "Team Project" = `Week4-Lab-DemoXX` (your initials).  
        - Columns: "Title", "Original Estimate", "Completed Work", "Estimate Accuracy".  
        - Save.  
      - **Query 2: Completed Stories**  
        - "New Query", name: "Completed Stories".  
        - Filters: "Work Item Type" = "User Story", "State" = "Closed", "Team Project" = `Week4-Lab-DemoXX` (your initials).  
        - Columns: "Title", "Story Points".  
        - Save.

13. **Add Metrics Widgets**  
    - Click "Edit":  
      - **Build History**:  
        - Last 5 builds (bar chart), Pipeline: "Week4Lab", Size: 2x2.  
      - **Build Duration**:  
        - Add "Chart for Work Items", manually note `BuildDurationSeconds` from "Log Metrics" (e.g., `X` seconds).  
        - Chart Type: Line chart (single point), Size: 2x2, save.  
      - **Test Success Rate**:  
        - Add "Chart for Work Items", track `TestSuccess` from logs (e.g., 80% over 5 runs).  
        - Chart Type: Pie chart (Success vs. Failure), Size: 2x2, save.  
      - **Story Points Completed**:  
        - Add "Query Results", Query: "Completed Stories".  
        - Chart Type: Column chart, Aggregate: Sum "Story Points" (e.g., 4), Size: 2x2, save.  
      - **Estimate Accuracy**:  
        - Add "Query Results", Query: "Task Estimates".  
        - Chart Type: Bar chart, Field: "Estimate Accuracy" (e.g., 0, -1), Size: 2x2, save.  
    - Click "Done Editing".

14. **Test Dashboard**  
    - Edit `index.js` (add `// Test`), commit, run pipeline.  
    - Check "Boards" > "Work Items": Tasks updated with "Estimate Accuracy" (e.g., Task 1: 0, Task 2: -1).  
    - Refresh dashboard:  
      - "Build History": New run.  
      - "Build Duration": Latest log value.  
      - "Test Success Rate": Adjust pie manually.  
      - "Story Points Completed": 4 points.  
      - "Estimate Accuracy": Bar chart shows values (e.g., 0, -1).

---

## Step 5: Validate and Interpret

15. **Validate Metrics**  
    - **Build Duration**: ~10-20s (logs).  
    - **Test Success Rate**: ~80% (varies, logs).  
    - **Story Points Completed**: 4 (query).  
    - **Estimate Accuracy**: Task 1: 0h, Task 2: -1h (tasks, check for floats like 0.5 if applicable).

16. **Interpret Results**  
    - **Speed**: Build Duration (CI efficiency).  
    - **Stability**: Test Success Rate (quality).  
    - **Progress**: Story Points Completed (velocity).  
    - **Efficiency**: Estimate Accuracy (planning accuracy).  
    - Summary: "Efficient builds with stable tests and accurate planning drive progress."

---

## Wrap-Up

- Save at `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX` (your initials).  
- Review at [https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week8Lab.md](https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week8Lab.md).  
- Solution at [https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8/solution](https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8/solution).  
- Next: Week 12 introduces release pipelines and additional DevOps and Dora Metrics for a more complete Dashboard

---
