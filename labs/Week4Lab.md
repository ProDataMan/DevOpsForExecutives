# Week 4 Lab: Azure DevOps Hands-On (No Existing App Required)

## Lab Overview

**Purpose**  
This lab introduces **brand-new Azure DevOps users** to core features. You’ll create a **new project**, set up a **basic repository**, define a **pipeline** that prints messages, add **user stories and tasks**, and build a **simple dashboard** showing build history and work item status. No existing app is required.

**What You’ll Accomplish**  
- **New Azure DevOps Project**: Your own workspace at `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX` (replace `XX` with your initials).  
- **Basic Repository**: A repo with a simple script and README.  
- **Pipeline**: A build pipeline that echoes text and logs timestamps.  
- **Work Items**: User stories and tasks for tracking.  
- **Dashboard**: A basic view of pipeline runs and work item status, preparing for Week 8.

**Estimated Time**  
About **75 minutes**:  
- 5 min: Sign in & create project  
- 10 min: Set up repo  
- 15 min: Create & run pipeline  
- 15 min: Add work items  
- 15 min: Set up dashboard  
- 15 min: Reflection & optional exercises  

**Lab Structure**  
Step-by-step guidance with detailed instructions inline. You’ll end with a functional pipeline, work items, and a dashboard in your project at `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX`, setting the stage for Week 8’s metrics-driven lab (Pages 17-21). Refer to this lab at [https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week4Lab.md](https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week4Lab.md). For a completed solution, download the contents of [https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week4/solution](https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week4/solution) to review the final repo state.

---

## Step 1: Setting Up Azure DevOps Project

- Sign in with provided credentials
- Access DevOpsClassroom.VisualStudio.com
- Create a new project
- Choose project name & process

**Detailed Instructions:**  
- **Sign in with provided credentials**: Open your browser, go to [DevOpsClassroom.VisualStudio.com](https://DevOpsClassroom.VisualStudio.com), and log in as `DevOpsStudent@Outlook.com`. Ask the instructor for the current password.  
- **Access DevOpsClassroom.VisualStudio.com**: Once logged in, you’ll see the `DevOpsClassroom` organization.  
- **Create a new project**: Click "New Project" (top-right).  
  - Name: "Week4-Lab-DemoXX" (replace `XX` with your initials).  
  - Visibility: Private.  
  - Click "Create". Your project will be at `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX`.  
- **Choose project name & process**: Under "Advanced", select **Git** for Version Control and **Agile** for Work Item Process (matches Week 8 continuity).  

Your project is now ready at `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX` to host your repo, pipeline, work items, and dashboard (Page 20: "Azure DevOps Overview").

---

## Step 2: Creating a Basic Repository

- Go to Repos in new project
- Initialize repo with README
- Add a simple script file
- Commit changes

**Detailed Instructions:**  
- **Go to Repos**: Navigate to `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX`, click "Repos" on the left menu.  
- **Initialize repo with README**: Click "Initialize" to create a `README.md` in the `main` branch. Edit it with:  
  ```markdown
  # Week4Lab
  Basic pipeline and dashboard demo for DevOps workshop.
  ```
  Commit: "Initial README".  
- **Add a simple script file**: Click "New" > "File", name it `hello.sh`, add:  
  ```bash
  #!/bin/bash
  echo "Hello from Week 4 Lab!"
  ```
  Commit: "Added hello script". Alternatively, copy this from [https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week4](https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week4).  
- **Commit changes**: Ensure both files are in `main`.  

This repo provides a baseline for the pipeline (Page 18: "Code checkout from repository").

---

## Step 3: Creating and Running the Pipeline

- Go to Pipelines → New
- Select your repo
- Configure YAML pipeline
- Run pipeline and check logs

**Detailed Instructions:**  
- **Go to Pipelines → New**: At `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX`, click "Pipelines" > "New Pipeline".  
- **Select your repo**: Choose "Azure Repos Git", select "Week4Lab" (default repo name in your project).  
- **Configure YAML pipeline**: Pick "Starter Pipeline", replace with:  
  ```yaml
  trigger:
    - main

  pool:
    vmImage: 'ubuntu-latest'

  steps:
  - checkout: self
    displayName: 'Checkout Code'

  - script: |
      chmod +x hello.sh
      ./hello.sh
    displayName: 'Run Hello Script'

  - script: |
      echo "Pipeline completed at $(date)"
    displayName: 'Log Completion'
  ```
  Save and commit to `main`: "Added Week 4 pipeline". You can also copy this from [https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week4](https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week4).  
- **Run pipeline and check logs**: Click "Run". Wait ~2-3 minutes. Check logs:  
  - "Checkout Code": Code pulled.  
  - "Run Hello Script": "Hello from Week 4 Lab!".  
  - "Log Completion": Timestamp (e.g., "Pipeline completed at ...").  

This matches Week 8’s recap (Page 18) and generates basic data (Page 19: "CI/CD Concepts").

---

## Step 4: Adding User Stories and Tasks

- Go to Boards → Work Items
- Create two user stories
- Add one task per story
- Link tasks to stories

**Detailed Instructions:**  
- **Go to Boards → Work Items**: At `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX`, click "Boards" > "Work Items".  
- **Create two user stories**: Click "New Work Item" > "User Story":  
  - **Story 1**:  
    - Title: "As a user, I want a greeting message to confirm pipeline execution."  
    - Description: "Echo a hello message in the pipeline."  
    - State: New.  
    - Save.  
  - **Story 2**:  
    - Title: "As a manager, I want pipeline logs to monitor progress."  
    - Description: "Log completion time in pipeline output."  
    - State: New.  
    - Save.  
- **Add one task per story**:  
  - Open Story 1, "Add Link" > "New Item":  
    - Type: Task.  
    - Title: "Write hello script".  
    - State: Done.  
    - Save and link.  
  - Open Story 2, add:  
    - Title: "Add timestamp log".  
    - State: Done.  
    - Save and link.  
- **Link tasks to stories**: Verify each story shows its task in "Boards" > "Backlogs".  

These work items prepare for Week 8’s dashboard (Page 17).

---

## Step 5: Setting Up a Basic Dashboard

- Go to Dashboards
- Create a new dashboard
- Add Build History widget
- Add Work Item Query widget
- Test dashboard updates

**Detailed Instructions:**  
- **Go to Dashboards**: At `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX`, click "Boards" > "Dashboards".  
- **Create a new dashboard**: Click "New Dashboard", name it "Week4Lab Dashboard", visibility "Project", save (Page 32: "Dashboard Setup").  
- **Add Build History widget**: Click "Edit", search "Build History", add it. Configure:  
  - Pipeline: "Week4Lab".  
  - Display: Pie chart, last 5 builds (pass/fail).  
  - Size: 2x2.  
  - Save.  
- **Add Work Item Query widget**: Add "Query Tile":  
  - Click "New Query":  
    - Name: "Open Work Items".  
    - Filter: Type = User Story, State = New.  
    - Save.  
  - Link to widget, title "Open Stories" (shows count, e.g., 2).  
  - Save dashboard (Page 33: "Adding Widgets").  
- **Test dashboard updates**: Edit `hello.sh` (e.g., `echo "Hello again!"`), commit, run pipeline. Refresh dashboard: Build History updates, Open Stories stays at 2. Compare with [https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week4/solution](https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week4/solution).  

This simple dashboard is a starting point for Week 8 (Page 35: "Testing Dashboard").

---

## Optional Exercises (Preparation for Week 8 and Beyond)

- Simulate a pipeline failure
- Add mock test metrics
- Generate multiple pipeline runs
- Explore additional widgets

**Detailed Instructions:**  
- **Simulate a pipeline failure**: Edit `azure-pipelines.yml`, add:  
  ```yaml
  - script: |
      echo "Simulating failure"
      exit 1
    displayName: 'Fail Step'
    condition: eq(variables['Build.Reason'], 'Manual')
  ```
  Run manually, check Build History shows a failure (prepares for Week 8’s failure rates, Page 29).  
- **Add mock test metrics**: Add to YAML:  
  ```yaml
  - script: |
      echo "Tests run: 10, Passed: 9, Failed: 1"
    displayName: 'Mock Tests'
  ```
  Re-run, logs mock data for Week 8’s dashboard (Page 30: "Metrics Logging").  
- **Generate multiple pipeline runs**: Commit small changes (e.g., edit `README.md` 3-5 times), run pipeline each time. Build History shows frequency, aiding Week 8’s deployment frequency (Page 38: "DORA Metrics").  
- **Explore additional widgets**: Add "Pipeline Duration" widget to track run time (prep for Week 8’s lead time, Page 47).  

These exercises enrich data for Week 8 and Week 12’s advanced dashboards at [https://github.com/ProDataMan/DevOpsForExecutives](https://github.com/ProDataMan/DevOpsForExecutives).

---

## Group Reflection

- Biggest takeaway
- Potential uses in your org
- Next steps for Week 8
- Dashboard expansion ideas

**Reflection Prompts:**  
- **Biggest Takeaway**: Which feature (pipeline, work items, dashboard) feels most valuable for oversight?  
- **Potential Uses in Your Org**: How could dashboards or pipelines improve visibility or automation?  
- **Next Steps for Week 8**: In Week 8 (Page 9, see [labs/Week8Lab.md](https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week8Lab.md)), you’ll merge a Node.js app and add metrics like lead time. How might this dashboard evolve?  
- **Dashboard Expansion Ideas**: What metrics (e.g., failures, trends) could enhance this for Week 12’s holistic view (see [labs/Week12Lab.md](https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week12Lab.md))?  

---
