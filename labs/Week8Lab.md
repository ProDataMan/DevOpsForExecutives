# Week 8 Lab: Building an Executive Dashboard

## Lab Overview

**Purpose**  
In Week 8 of the "DevOps for Executive Leadership" workshop (Page 9), you’ll enhance your Week 4 Azure DevOps project at `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX` (replace `XX` with your initials) by merging a sample Node.js app from [https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8](https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8), updating your pipeline to generate DORA metrics, and expanding your Week 4 dashboard to include DORA metrics and estimate accuracy from task hours. This lab builds on your Week 4 work—preserving user stories and tasks in "Boards"—and prepares you for Week 12’s comprehensive integration.

**What You’ll Accomplish**  
- Merge the Week 8 sample app into your Week 4 repo.  
- Update the pipeline to log DORA metrics (e.g., deployment frequency, lead time).  
- Expand your Week 4 dashboard with DORA metrics and task estimate accuracy visuals.  
- Interpret results strategically for leadership.

**Estimated Time**  
About **75-105 minutes**:  
- 15 min: Prepare environment & merge sample app  
- 20 min: Configure & run pipeline  
- 25 min: Build & test dashboard (expanded for estimate metrics)  
- 20 min: Validate & interpret results  
- 10-15 min: Wrap-up & reflection  

**Lab Structure**  
Step-by-step instructions to enhance your Week 4 project, detailed at [https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week8Lab.md](https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week8Lab.md). Refer to Week 4’s setup at [https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week4Lab.md](https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week4Lab.md). For a completed solution, download the contents of [https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8/solution](https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8/solution) to review the final repo state.

---

## Prerequisites

- **Azure DevOps Project**: Your Week 4 project at `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX` (Page 23).  
- **Instructor’s Sample App**: [https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8](https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8) (Page 24).  
- **Git Basics**: Cloning, branching, merging (see [git-scm.com](https://git-scm.com/)).  
- **Basic YAML Knowledge**: From Week 4 (Page 23).  
- **Web Browser**: Chrome, Edge, or Firefox.

---

## Step 1: Prepare Your Environment

1. **Log In to Your Week 4 Project**  
   - Go to `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX` (replace `XX` with your initials). Log in as `DevOpsStudent@Outlook.com` (ask the instructor for the current password).  
   - Verify your Week 4 setup: repo (`hello.sh`, `README.md`, `azure-pipelines.yml`), work items in "Boards" (2 user stories with 2 story points each, 2 tasks with estimates), and "Week4Lab Dashboard".  
   - **Why**: Uses your Week 4 foundation (Page 21: "Why Azure DevOps?").

2. **Fork the Instructor’s Sample App Repo**  
   - Visit [https://github.com/ProDataMan/DevOpsForExecutives](https://github.com/ProDataMan/DevOpsForExecutives).  
   - Click "Fork" to copy the entire repo to your GitHub account (e.g., `https://github.com/yourusername/DevOpsForExecutives`). The Week 8 sample app is in the `week8/` folder.  
   - **Why**: Gets the Node.js app for merging (Page 26: "Forking Repository"). Note: Lab instructions are in `labs/`, but you’ll fork the whole repo.

3. **Clone Your Fork Locally**  
   - Open a terminal (e.g., Git Bash, PowerShell).  
   - Run:  
     ```bash
     git clone https://github.com/yourusername/DevOpsForExecutives.git
     cd DevOpsForExecutives
     ```
   - **Why**: Prepares the sample code for merging.

---

## Step 2: Merge Sample App into Your Week 4 Repo

4. **Clone Your Week 4 Repo Locally**  
   - At `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX`, go to "Repos" > "Files".  
   - Click "Clone", copy the URL (e.g., `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX/_git/Week4Lab`).  
   - In a new terminal directory:  
     ```bash
     git clone https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX/_git/Week4Lab
     cd Week4Lab
     ```
   - **Why**: Accesses your Week 4 repo (Page 18: "Week 4 Lab Recap").

5. **Add the Sample App Repo as a Remote**  
   - Run:  
     ```bash
     git remote add sample https://github.com/yourusername/DevOpsForExecutives.git
     git fetch sample
     ```
   - **Why**: Links the sample app for merging.

6. **Merge the Sample App Code**  
   - Create a branch:  
     ```bash
     git checkout -b week8-merge
     ```
   - Merge only the `week8/` folder:  
     ```bash
     git checkout sample/main -- week8/*
     ```
   - Move files from `week8/` to root:  
     ```bash
     mv week8/* .
     rmdir week8
     ```
   - Resolve conflicts:  
     - If `azure-pipelines.yml` conflicts, keep your Week 4 version for now (you’ll update it next).  
     - Overwrite `hello.sh` with `index.js`, `package.json`, `test.js`.  
     - Ignore `labs/` and other week folders from the merge.  
   - Commit:  
     ```bash
     git add .
     git commit -m "Merged Week 8 sample app from week8/"
     git push origin week8-merge
     ```
   - **Why**: Integrates the Node.js app (Page 26). Tip: Check [https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8/solution](https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8/solution) for the expected outcome.

7. **Complete the Merge via Pull Request**  
   - At `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX`, go to "Repos" > "Pull Requests".  
   - Click "New Pull Request": Source: `week8-merge`, Target: `main`.  
   - Title: "Merge Week 8 Sample App", approve, and complete.  
   - **Why**: Safely updates your repo.

---

## Step 3: Configure the Pipeline

8. **Update `azure-pipelines.yml`**  
   - At `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX`, go to "Repos" > "Files", open `azure-pipelines.yml`.  
   - Replace with (Page 28: "Configuring YAML"):  
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
   - Commit to `main`: "Updated pipeline for Week 8 metrics".  
   - **Why**: Logs DORA metrics, replacing Week 4’s simple echo (Page 29: "Pipeline Stages").

9. **Run the Pipeline**  
   - Go to "Pipelines" > "Builds", select your pipeline, click "Run".  
   - Wait ~5 minutes, check logs (e.g., `LeadTimeMinutes=0`, `ChangeFailureRate=5`) (Page 42).  
   - **Why**: Generates metrics data (Page 43).

---

## Step 4: Build the Dashboard

10. **Update Your Week 4 Dashboard**  
    - At `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX`, go to "Overview" > "Dashboards", open "Week4Lab Dashboard".  
    - **Why**: Builds on Week 4’s base (Page 32).

11. **Create Queries for Metrics**  
    - Go to "Boards" > "Queries":  
      - **Query 1: Pipeline Metrics**  
        - Name: "Pipeline Metrics".  
        - Filter: Build, Pipeline = Week4Lab.  
        - Save.  
      - **Query 2: Task Estimates**  
        - Name: "Task Estimates".  
        - Filter: Work Item Type = Task, State = Done.  
        - Columns: Add "Original Estimate" and "Completed Work".  
        - Save.  
    - **Why**: Prepares data for widgets (Page 34).

12. **Add Metrics Widgets**  
    - In "Dashboards", click "Edit" (Page 33: "Adding Widgets"):  
      - **Keep Build History**: Adjust to show last 5 builds (bar chart).  
      - **Add Query Results (Lead Time)**:  
        - Add "Query Results" widget.  
        - Query: "Pipeline Metrics".  
        - Chart Type: Line chart.  
        - Configure: Add `LeadTimeMinutes` from logs (manual entry, e.g., 0).  
        - Size: 2x2.  
      - **Add Pipeline Overview**:  
        - Add "Pipeline Overview" widget.  
        - Pipeline: "Week4Lab".  
        - Chart Type: Bar chart for frequency.  
        - Size: 2x2.  
      - **Add Query Results (Estimate Accuracy)**:  
        - Add "Query Results" widget.  
        - Query: "Task Estimates".  
        - Chart Type: Bar chart.  
        - Configure: Group by "Title", show "Original Estimate" and "Completed Work" (e.g., Task 1: 2h/2h, Task 2: 2h/3h).  
        - Size: 2x2.  
    - Save.  
    - **Why**: Visualizes DORA metrics and estimate accuracy, enhancing Week 4’s dashboard.

13. **Test Dashboard**  
    - Edit `index.js` (e.g., add a comment), commit, run pipeline.  
    - Refresh dashboard, confirm updates:  
      - Build History and Pipeline Overview reflect new run.  
      - Lead Time updates with new log data.  
      - Task Estimates remain static (Week 4 data).  
    - Compare with [https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8/solution](https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8/solution) (Page 35).  
    - **Why**: Ensures real-time functionality.

---

## Step 5: Validate and Interpret

14. **Validate Metrics**  
    - Compare dashboard to logs and work items (Page 44):  
      - Deployment Frequency: Run count (e.g., 3+ from Week 4 and 8).  
      - Lead Time, MTTR: Mock values (e.g., 0 min).  
      - Change Failure Rate: Mock 5%.  
      - Estimate Accuracy: Task 1 (2h/2h, 100% accurate), Task 2 (2h/3h, 67% accurate).  
    - **Why**: Confirms accuracy across DORA and task metrics.

15. **Interpret Results**  
    - Link to goals (Pages 50-51):  
      - Speed: Frequency/lead time.  
      - Stability: Failure/defect rates.  
      - Efficiency: Availability/MTTR, estimate accuracy (e.g., Task 2 overrun suggests planning improvement).  
    - Summarize for executives (Page 52): "Frequent releases with reliable metrics and improving estimates enhance agility and planning."  
    - **Why**: Prepares leadership communication with broader insights.

---

## Wrap-Up

- Save your work at `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX`.  
- Review takeaways (Pages 54-56) and Week 9 preview (Page 57) at [https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week8Lab.md](https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week8Lab.md).  
- Download the completed solution from [https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8/solution](https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week8/solution) to compare your results.  
- Next: Week 12 will integrate advanced features (see [https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week12Lab.md](https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week12Lab.md)).
