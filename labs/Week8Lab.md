2q# Week 8 Lab: Building an Executive Dashboard

## Lab Overview

**Purpose**  
In Week 8 of the "DevOps for Executive Leadership" workshop (Page 9), you’ll enhance your Week 4 Azure DevOps project at `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX` (replace `XX` with your initials) by integrating a sample Node.js app from [https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8](https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8), updating your pipeline to generate DORA metrics, and expanding your Week 4 dashboard to include DORA metrics and estimate accuracy from task hours. This lab builds on your Week 4 work—preserving user stories and tasks in "Boards"—and prepares you for Week 12’s advanced integration.

**What You’ll Accomplish**  
- Upload the Week 8 sample app files to your Week 4 Azure DevOps repo.  
- Update the pipeline to log DORA metrics (e.g., deployment frequency, lead time).  
- Expand your Week 4 dashboard with DORA metrics and task estimate accuracy visuals.  
- Interpret results strategically for leadership.

**Estimated Time**  
About **75-105 minutes**:  
- 15 min: Prepare environment & upload sample app  
- 20 min: Configure & run pipeline  
- 25 min: Build & test dashboard (expanded for estimate metrics)  
- 20 min: Validate & interpret results  
- 10-15 min: Wrap-up & reflection  

**Lab Structure**  
Step-by-step instructions to enhance your Week 4 project, detailed at [https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week8Lab.md](https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week8Lab.md). Refer to Week 4’s setup at [labs/Week4Lab.md](https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week4Lab.md). For a completed solution, download the contents of [https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8/solution](https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8/solution) to review the final repo state.

---

## Prerequisites

- **Azure DevOps Project**: Your Week 4 project at `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX` (Page 23).  
- **Instructor’s Sample App**: [https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8](https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8) (Page 24).  
- **Lab Machine**: Provided machine with Git and Git Bash installed.  
- **Web Browser**: Chrome, Edge, or Firefox.

---

## Step 1: Prepare Your Environment

1. **Log In to Your Week 4 Project**  
   - Open your web browser (e.g., Chrome) on the lab machine.  
   - Go to `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX` (replace `XX` with your initials).  
   - Log in with the username `DevOpsStudent@Outlook.com`. Ask the instructor for the current password.  
   - Once logged in, verify your Week 4 setup:  
     - Click "Repos" > "Files" to see `hello.sh`, `README.md`, and `azure-pipelines.yml`.  
     - Click "Boards" > "Work Items" to see 2 user stories (2 story points each) and 2 tasks with estimates.  
     - Click "Overview" > "Dashboards" to see "Week4Lab Dashboard".  
   - **Why**: Ensures you’re starting with your Week 4 foundation (Page 21: "Why Azure DevOps?").

2. **Option 1: Clone the Sample App Using Git Bash and Upload**  
   - **Open Git Bash**:  
     - On the lab machine, click the Start menu (bottom-left corner of the screen).  
     - Type "Git Bash" in the search bar, then click "Git Bash" to open it. A black window with a command prompt will appear.  
   - **Create a Working Folder**:  
     - In Git Bash, type the following command and press Enter to create a folder called `Week8Lab` on your Desktop:  
       ```bash
       mkdir ~/Desktop/Week8Lab
       ```
     - Move into that folder by typing:  
       ```bash
       cd ~/Desktop/Week8Lab
       ```
   - **Clone the Instructor’s Repo**:  
     - Type this command and press Enter to download the entire repo from GitHub:  
       ```bash
       git clone https://github.com/ProDataMan/DevOpsForExecutives.git
       ```
     - Wait a few seconds for the download to finish. You’ll see a new folder called `DevOpsForExecutives` in `Week8Lab`.  
   - **Clone Your Azure DevOps Repo**:  
     - In Git Bash, type this command and press Enter (replace `XX` with your initials):  
       ```bash
       git clone https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX/_git/Week4Lab
       ```
     - Wait a few seconds. You’ll now have a `Week4Lab` folder next to `DevOpsForExecutives`.  
   - **Copy the Week 8 Files**:  
     - Type these commands one by one, pressing Enter after each, to copy the Week 8 sample app files from `DevOpsForExecutives/week8/` to `Week4Lab/` (this will overwrite `azure-pipelines.yml`):  
       ```bash
       cp DevOpsForExecutives/week8/index.js Week4Lab/
       cp DevOpsForExecutives/week8/package.json Week4Lab/
       cp DevOpsForExecutives/week8/test.js Week4Lab/
       cp DevOpsForExecutives/week8/azure-pipelines.yml Week4Lab/
       ```
   - **Upload the Files to Azure DevOps**:  
     - Move into your Azure DevOps repo folder:  
       ```bash
       cd Week4Lab
       ```
     - Tell Git to track all the new and updated files:  
       ```bash
       git add .
       ```
     - Save the changes with a message:  
       ```bash
       git commit -m "Uploaded Week 8 sample app files"
       ```
     - Send the files to your Azure DevOps repo:  
       ```bash
       git push origin main
       ```
     - Wait a few seconds for the upload to complete. You’ll see a success message in Git Bash.  
   - **Why**: This replaces Week 4’s `hello.sh` with the Node.js app files using Git Bash (Page 26).

3. **Option 2: Download Files Manually and Upload**  
   - **Download the Files**:  
     - Open your browser and go to [https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8](https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8).  
     - For each file (`index.js`, `package.json`, `test.js`, `azure-pipelines.yml`):  
       - Click the file name to open it.  
       - Click the "Raw" button (top-right of the file content).  
       - Right-click the page, select "Save As", and save it to your Desktop (e.g., `C:\Users\YourName\Desktop`). Keep the default file name.  
       - Repeat for all four files.  
   - **Upload to Azure DevOps**:  
     - Go back to `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX` in your browser.  
     - Click "Repos" > "Files" on the left menu.  
     - Click the "Upload file(s)" button (near the top-right).  
     - In the file picker, navigate to your Desktop, select `index.js`, `package.json`, `test.js`, and `azure-pipelines.yml` (hold Ctrl to select multiple files), then click "Open".  
     - In the pop-up, set the commit message to "Uploaded Week 8 sample app files".  
     - Check "Overwrite" if prompted (to replace the existing `azure-pipelines.yml`), then click "Commit".  
   - **Why**: This manually adds the Week 8 Node.js app files to your repo, replacing `hello.sh` (Page 26).

---

## Step 2: Configure the Pipeline

4. **Review `azure-pipelines.yml`**  
   - At `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX`, go to "Repos" > "Files", click `azure-pipelines.yml` to view it.  
   - Ensure it matches this (uploaded from `week8/`):  
     ```yaml
     trigger:
       - main

     pool:
       vmImage: 'ubuntu-latest'

     steps:
     - checkout: self
       displayName: 'Checkout Code'

     - script: |
         npm install
         npm test || echo "TestsFailed=1" >> $GITHUB_ENV
       displayName: 'Build and Test'
       continueOnError: true

     - script: |
         echo "Deploying application..."
         START_TIME=$(date +%s)
         sleep 5  # Simulate deployment
         END_TIME=$(date +%s)
         echo "LeadTimeMinutes=$(( (END_TIME - START_TIME) / 60 ))" >> $GITHUB_ENV
         echo "Availability=99" >> $GITHUB_ENV
       displayName: 'Deploy Application'
       condition: eq(variables['TestsFailed'], '')

     - script: |
         echo "Scanning for vulnerabilities..."
         echo "ChangeFailureRate=5" >> $GITHUB_ENV
         echo "DefectEscapeRate=1" >> $GITHUB_ENV
       displayName: 'Security Scan'
       condition: succeeded()

     - script: |
         echo "Simulating failure and recovery..."
         START_FAIL=$(date +%s)
         sleep 3  # Simulate failure duration
         END_FAIL=$(date +%s)
         echo "MTTRMinutes=$(( (END_FAIL - START_FAIL) / 60 ))" >> $GITHUB_ENV
       displayName: 'Simulate Recovery'
       continueOnError: true

     - script: |
         echo "Pipeline Metrics:"
         echo "LeadTimeMinutes=${{ variables.LeadTimeMinutes }}"
         echo "ChangeFailureRate=${{ variables.ChangeFailureRate }}"
         echo "MTTRMinutes=${{ variables.MTTRMinutes }}"
         echo "Availability=${{ variables.Availability }}"
         echo "DefectEscapeRate=${{ variables.DefectEscapeRate }}"
       displayName: 'Log Metrics'
     ```
   - If it doesn’t match (e.g., manual upload error), edit it in the browser:  
     - Click the three dots (...) next to `azure-pipelines.yml`, select "Edit".  
     - Copy-paste the above YAML, click "Commit", message: "Confirmed Week 8 pipeline".  
   - **Why**: Logs DORA metrics, replacing Week 4’s simpler pipeline (Page 29: "Pipeline Stages").

5. **Run the Pipeline**  
   - Go to "Pipelines" > "Builds" on the left menu.  
   - Find your pipeline (likely named "Week4Lab"), click it, then click "Run pipeline" (top-right).  
   - In the pop-up, click "Run". Wait ~5 minutes.  
   - Click the running job (e.g., "Job 1") to see logs: look for `LeadTimeMinutes=0`, `ChangeFailureRate=5`, etc. (Page 42).  
   - **Why**: Generates metrics data (Page 43).

---

## Step 3: Build the Dashboard

6. **Update Your Week 4 Dashboard**  
   - At `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX`, go to "Overview" > "Dashboards", click "Week4Lab Dashboard" to open it.  
   - **Why**: Builds on Week 4’s base (Page 32).

7. **Create Queries for Metrics**  
   - Go to "Boards" > "Queries" on the left menu:  
     - **Query 1: Pipeline Metrics**  
       - Click "New Query".  
       - Name it "Pipeline Metrics".  
       - Set filters: "Work Item Type" = "Build", "Pipeline" = "Week4Lab".  
       - Click "Save query".  
     - **Query 2: Task Estimates**  
       - Click "New Query".  
       - Name it "Task Estimates".  
       - Set filters: "Work Item Type" = "Task", "State" = "Done".  
       - Click "Columns", add "Original Estimate" and "Completed Work", click "OK".  
       - Click "Save query".  
   - **Why**: Prepares data for widgets (Page 34).

8. **Add Metrics Widgets**  
   - In "Dashboards", click "Edit" (top-right):  
     - **Keep Build History**: Ensure it shows last 5 builds (bar chart).  
     - **Add Query Results (Lead Time)**:  
       - Click "Add widget", search "Query Results", click "Add".  
       - Click the gear icon on the widget, set Query to "Pipeline Metrics".  
       - Set "Chart type" to "Line chart".  
       - Manually note `LeadTimeMinutes` from logs (e.g., 0), as it’s not queryable yet—future runs will populate.  
       - Size: 2x2, click "Save".  
     - **Add Pipeline Overview**:  
       - Click "Add widget", search "Pipeline Overview", click "Add".  
       - Click the gear icon, set Pipeline to "Week4Lab", Chart Type to "Bar chart" (frequency).  
       - Size: 2x2, click "Save".  
     - **Add Query Results (Estimate Accuracy)**:  
       - Click "Add widget", search "Query Results", click "Add".  
       - Click the gear icon, set Query to "Task Estimates".  
       - Set "Chart type" to "Bar chart".  
       - Configure: Group by "Title", show "Original Estimate" and "Completed Work" (e.g., Task 1: 2h/2h, Task 2: 2h/3h).  
       - Size: 2x2, click "Save".  
   - Click "Done Editing".  
   - **Why**: Visualizes DORA metrics and estimate accuracy (Page 33: "Adding Widgets").

9. **Test Dashboard**  
   - Go to "Repos" > "Files", click `index.js`, click "Edit", add a comment (e.g., `// Test run`), click "Commit".  
   - Go to "Pipelines" > "Builds", run the pipeline again.  
   - Refresh the dashboard:  
     - Build History and Pipeline Overview show the new run.  
     - Lead Time updates with log data (e.g., 0 min).  
     - Task Estimates stay static (Week 4 data).  
   - Compare with [https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8/solution](https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8/solution) (Page 35).  
   - **Why**: Ensures real-time updates.

---

## Step 4: Validate and Interpret

10. **Validate Metrics**  
    - Compare dashboard to logs and work items (Page 44):  
      - Deployment Frequency: Run count (e.g., 3+ from Week 4 and 8).  
      - Lead Time, MTTR: Mock values (e.g., 0 min).  
      - Change Failure Rate: Mock 5%.  
      - Estimate Accuracy: Task 1 (2h/2h, 100%), Task 2 (2h/3h, 67%).  
    - **Why**: Confirms accuracy across metrics.

11. **Interpret Results**  
    - Link to goals (Pages 50-51):  
      - Speed: Frequency/lead time.  
      - Stability: Failure/defect rates.  
      - Efficiency: Availability/MTTR, estimate accuracy (Task 2 overrun suggests planning improvement).  
    - Summarize for executives (Page 52): "Frequent releases with reliable metrics and improving estimates enhance agility and planning."  
    - **Why**: Prepares leadership communication.

---

## Wrap-Up

- Save your work at `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX`.  
- Review takeaways (Pages 54-56) and Week 9 preview (Page 57) at [https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week8Lab.md](https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week8Lab.md).  
- Download the completed solution from [https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8/solution](https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8/solution) to compare your results.  
- Next: Week 12 will integrate advanced features (see [labs/Week12Lab.md](https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week12Lab.md)).
