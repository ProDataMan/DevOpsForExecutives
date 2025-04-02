# Week 8 lab ("Building an Executive Dashboard")
The lab involves building a pipeline in Azure DevOps with prebuilt code, generating DORA and DevOps metrics, and creating an executive dashboard.

The instructions assume basic familiarity with Azure DevOps (from Week 4) and YAML, as noted in "Lab Prerequisites" (Slide 23). The lab will produce the six key DevOps metrics (deployment frequency, lead time, MTTR, change failure rate, application availability, defect escape rate) used throughout the slides.

The instructions will guide students to fork the repo, merge it into their Week 4 project repo, update the pipeline, and build the dashboard, aligning with the Week 8 lab and concepts.

---
### Step-by-Step Lab Instructions

#### Lab Overview
In Week 8 of the "DevOps for Executive Leadership" workshop (Page 9), you’ll enhance your Week 4 Azure DevOps project by merging a sample Node.js app from the instructor’s repository into your existing repo, updating your pipeline to generate DORA and DevOps metrics, and building an executive dashboard. This lab builds on your Week 4 work—your user stories and tasks in "Boards" remain intact—and takes approximately 75-105 minutes using Azure DevOps’ free tier. By the end, you’ll have a pipeline and dashboard showcasing DevOps value, as outlined on Pages 10-11.

#### Prerequisites
- **Azure DevOps Account**: Use your Week 4 project (e.g., "Week4Lab") at [dev.azure.com](https://dev.azure.com) (Page 23).
- **Instructor’s Sample App Repository**: Access [https://github.com/ProDataMan/week8-sample-app](https://github.com/ProDataMan/week8-sample-app) (Page 24).
- **Git Basics**: Know how to clone, branch, and merge (see [git-scm.com](https://git-scm.com/)).
- **Web Browser**: Chrome, Edge, or Firefox.
- **Basic YAML Knowledge**: From Week 4 (Page 23).

#### Lab Steps

##### Step 1: Prepare Your Environment
1. **Log In to Your Week 4 Project**:
   - Go to [dev.azure.com](https://dev.azure.com), sign in, and open your Week 4 project (e.g., "Week4Lab").
   - Verify your user stories and tasks exist in "Boards" (they won’t be affected by repo changes).
   - **Why**: Uses your existing setup (Page 20: "Why Azure DevOps?").

2. **Fork the Instructor’s Sample App Repo**:
   - Visit [https://github.com/ProDataMan/week8-sample-app](https://github.com/ProDataMan/week8-sample-app).
   - Click "Fork" to copy it to your GitHub account (e.g., `https://github.com/yourusername/week8-sample-app`).
   - **Why**: Gets the prebuilt Node.js app for the lab (Page 26: "Forking Repository").

3. **Clone Your Fork Locally**:
   - Open a terminal (e.g., Git Bash, PowerShell).
   - Run: `git clone https://github.com/yourusername/week8-sample-app.git`
   - `cd week8-sample-app`
   - **Why**: Prepares the sample code for merging.

##### Step 2: Merge Sample App into Your Week 4 Repo
4. **Clone Your Week 4 Repo Locally**:
   - In Azure DevOps, go to "Repos" > "Files" in your Week 4 project.
   - Click "Clone", copy the URL (e.g., `https://dev.azure.com/yourorg/Week4Lab/_git/Week4Lab`).
   - In a new terminal directory: `git clone https://dev.azure.com/yourorg/Week4Lab/_git/Week4Lab`
   - `cd Week4Lab`
   - **Why**: Accesses your Week 4 repo (Page 17: "Week 4 Lab Recap").

5. **Add the Sample App Repo as a Remote**:
   - In the `Week4Lab` directory:
     - `git remote add sample https://github.com/yourusername/week8-sample-app.git`
     - `git fetch sample`
   - **Why**: Links the sample app for merging.

6. **Merge the Sample App Code**:
   - Create a branch: `git checkout -b week8-merge`
   - Merge: `git merge sample/main --allow-unrelated-histories`
   - Resolve conflicts:
     - If `azure-pipelines.yml` conflicts, keep your Week 4 version for now (you’ll update it next).
     - Overwrite any Week 4 code (e.g., basic scripts) with sample app files (`index.js`, `package.json`, `test.js`).
   - Commit: `git add . && git commit -m "Merged Week 8 sample app"`
   - Push: `git push origin week8-merge`
   - **Why**: Integrates the sample app (Page 26).

7. **Complete the Merge via Pull Request**:
   - In Azure DevOps "Repos" > "Pull Requests", click "New Pull Request".
   - Source: `week8-merge`, Target: `main`.
   - Title: "Merge Week 8 Sample App", approve, and complete.
   - **Why**: Safely updates your repo.

##### Step 3: Configure the Pipeline
8. **Update `azure-pipelines.yml`**:
   - In "Repos" > "Files", open `azure-pipelines.yml`.
   - Replace with (Page 27: "Configuring YAML"):
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
   - Commit to `main`.
   - **Why**: Logs metrics (Page 29: "Pipeline Stages").

9. **Run the Pipeline**:
   - Go to "Pipelines" > "Builds", select your pipeline, click "Run".
   - Wait ~5 minutes, check logs (e.g., `LeadTimeMinutes=0`, `ChangeFailureRate=5`) (Page 42).
   - **Why**: Generates data (Page 42).

##### Step 4: Build the Dashboard
10. **Create Dashboard**:
    - In "Boards" > "Dashboards", click "New Dashboard".
    - Name: "DevOps Metrics", save (Page 32).

11. **Add Widgets**:
    - Edit dashboard (Page 33):
      - "Build History" (pie chart, last 5 builds, pass/fail).
      - "Query Results" (line chart for `LeadTimeMinutes`, query below).
      - "Pipeline Overview" (bar chart for frequency).
    - **Why**: Visualizes metrics.

12. **Map Data**:
    - In "Queries" > "New Query" (Page 34):
      - Filter: Build, Pipeline = Week4Lab.
      - Add custom field `LeadTimeMinutes` from logs (manual entry).
      - Save, link to widget.
    - Adjust Build History for `ChangeFailureRate`.
    - **Why**: Links logs to visuals.

13. **Test Dashboard**:
    - Edit `index.js` (add a comment), commit, run pipeline.
    - Confirm dashboard updates (Page 35).

##### Step 5: Validate and Interpret
14. **Validate Metrics**:
    - Check dashboard vs. logs (Page 44):
      - Deployment frequency: Run count.
      - Lead time, MTTR, etc.: Mock values.

15. **Interpret**:
    - Link to goals (Pages 50-51): Speed, stability, efficiency.
    - Summarize for executives (Page 52).

#### Wrap-Up
- Save work, review Pages 54-56 for takeaways and Week 9 preview.

---

### Prerequisite Code and Artifacts
#### Instructor’s Repo (`week8-sample-app`)
- Confirmed at [https://github.com/ProDataMan/week8-sample-app](https://github.com/ProDataMan/week8-sample-app):
  - `index.js`: Node.js app.
  - `package.json`: Dependencies.
  - `test.js`: Test script.
  - `azure-pipelines.yml`: Placeholder (replaced in lab).

#### Week 4 Repo Assumptions
- Contains a basic `azure-pipelines.yml` (e.g., `echo "Hello"`) and possibly minimal code.
- User stories/tasks in "Boards" are unaffected by code merges.

---

### Validation
- **Work Items**: Preserved in "Boards" (Page 19).
- **Metrics**: Generates all six DevOps metrics (Pages 38-40).
- **Time**: ~75-105 minutes, including merge steps.

