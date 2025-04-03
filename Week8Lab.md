# Week 8 Lab: Building an Executive Dashboard

## Lab Overview

**Purpose**  
In Week 8 of the "DevOps for Executive Leadership" workshop (Page 9), you’ll enhance your Week 4 Azure DevOps project at `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX` (replace `XX` with your initials) by merging a sample Node.js app from [https://github.com/ProDataMan/week8-sample-app](https://github.com/ProDataMan/week8-sample-app), updating your pipeline to generate DORA and DevOps metrics, and building an executive dashboard. This lab builds on your Week 4 work—preserving user stories and tasks in "Boards"—and prepares you for Week 12’s comprehensive integration.

**What You’ll Accomplish**  
- Merge the sample app into your Week 4 repo.  
- Update the pipeline to log DORA metrics (e.g., deployment frequency, lead time).  
- Expand your Week 4 dashboard with metrics visuals.  
- Interpret results strategically for leadership.

**Estimated Time**  
About **75-105 minutes**:  
- 15 min: Prepare environment & merge sample app  
- 20 min: Configure & run pipeline  
- 20 min: Build & test dashboard  
- 20 min: Validate & interpret results  
- 10-20 min: Wrap-up & reflection  

**Lab Structure**  
Step-by-step instructions to enhance your Week 4 project, detailed at [https://github.com/ProDataMan/DevOpsForExecutives/blob/main/Week8Lab.md](https://github.com/ProDataMan/DevOpsForExecutives/blob/main/Week8Lab.md). Refer to Week 4’s setup at [Week4Lab.md](https://github.com/ProDataMan/DevOpsForExecutives/blob/main/Week4Lab.md).

---

## Prerequisites

- **Azure DevOps Project**: Your Week 4 project at `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX` (Page 23).  
- **Instructor’s Sample App**: [https://github.com/ProDataMan/week8-sample-app](https://github.com/ProDataMan/week8-sample-app) (Page 24).  
- **Git Basics**: Cloning, branching, merging (see [git-scm.com](https://git-scm.com/)).  
- **Basic YAML Knowledge**: From Week 4 (Page 23).  
- **Web Browser**: Chrome, Edge, or Firefox.

---

## Step 1: Prepare Your Environment

1. **Log In to Your Week 4 Project**  
   - Go to `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX` (replace `XX` with your initials).  
   - Verify your Week 4 setup: repo (`hello.sh`, `README.md`, `azure-pipelines.yml`), work items in "Boards" (2 user stories, 2 tasks), and "Week4Lab Dashboard".  
   - **Why**: Uses your Week 4 foundation (Page 21: "Why Azure DevOps?").

2. **Fork the Instructor’s Sample App Repo**  
   - Visit [https://github.com/ProDataMan/week8-sample-app](https://github.com/ProDataMan/week8-sample-app).  
   - Click "Fork" to copy it to your GitHub account (e.g., `https://github.com/yourusername/week8-sample-app`).  
   - **Why**: Gets the Node.js app for merging (Page 26: "Forking Repository").

3. **Clone Your Fork Locally**  
   - Open a terminal (e.g., Git Bash, PowerShell).  
   - Run:  
     ```bash
     git clone https://github.com/yourusername/week8-sample-app.git
     cd week8-sample-app
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
     git remote add sample https://github.com/yourusername/week8-sample-app.git
     git fetch sample
     ```
   - **Why**: Links the sample app for merging.

6. **Merge the Sample App Code**  
   - Create a branch:  
     ```bash
     git checkout -b week8-merge
     ```
   - Merge:  
     ```bash
     git merge sample/main --allow-unrelated-histories
     ```
   - Resolve conflicts:  
     - If `azure-pipelines.yml` conflicts, keep your Week 4 version for now (you’ll update it next).  
     - Overwrite `hello.sh` with sample app files (`index.js`, `package.json`, `test.js`).  
   - Commit:  
     ```bash
     git add .
     git commit -m "Merged Week 8 sample app"
     git push origin week8-merge
     ```
   - **Why**: Integrates the Node.js app (Page 26).

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
    - At `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX`, go to "Boards" > "Dashboards", open "Week4Lab Dashboard".  
    - **Why**: Builds on Week 4’s base (Page 32).

11. **Add Metrics Widgets**  
    - Click "Edit" (Page 33: "Adding Widgets"):  
      - **Keep Build History**: Adjust to show last 5 builds (pie chart, pass/fail).  
      - **Add Query Results**: For `LeadTimeMinutes`:  
        - Go to "Queries" > "New Query":  
          - Name: "Pipeline Metrics".  
          - Filter: Build, Pipeline = Week4Lab.  
          - Save, link to a line chart widget (manual entry from logs initially).  
      - **Add Pipeline Overview**: Bar chart for frequency, select "Week4Lab".  
    - Arrange: 2x2 tiles each.  
    - Save.  
    - **Why**: Visualizes DORA metrics, enhancing Week 4’s dashboard.

12. **Map Data**  
    - For "Query Results" widget (Page 34):  
      - Edit "Pipeline Metrics" query, add custom field `LeadTimeMinutes` from logs (e.g., 0).  
      - Update widget to reflect this.  
    - Adjust Build History for `ChangeFailureRate` (e.g., mock 5%).  
    - **Why**: Links pipeline logs to visuals.

13. **Test Dashboard**  
    - Edit `index.js` (e.g., add a comment), commit, run pipeline.  
    - Refresh dashboard, confirm updates (e.g., frequency increases, lead time logged) (Page 35).  
    - **Why**: Ensures real-time functionality.

---

## Step 5: Validate and Interpret

14. **Validate Metrics**  
    - Compare dashboard to logs (Page 44):  
      - Deployment frequency: Run count (e.g., 2+ from Week 4 and 8).  
      - Lead time, MTTR, etc.: Mock values (e.g., 0 min, 5%).  
    - **Why**: Confirms accuracy.

15. **Interpret Results**  
    - Link to goals (Pages 50-51):  
      - Speed: Frequency/lead time.  
      - Stability: Failure/defect rates.  
      - Efficiency: Availability/MTTR.  
    - Summarize for executives (Page 52): "Frequent, reliable releases improve agility."  
    - **Why**: Prepares leadership communication.

---

## Wrap-Up

- Save your work at `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX`.  
- Review takeaways (Pages 54-56) and Week 9 preview (Page 57) at [https://github.com/ProDataMan/DevOpsForExecutives/blob/main/Week8Lab.md](https://github.com/ProDataMan/DevOpsForExecutives/blob/main/Week8Lab.md).  
- Next: Week 12 will integrate advanced features (see [Week12Lab.md](https://github.com/ProDataMan/DevOpsForExecutives/blob/main/Week12Lab.md)).

