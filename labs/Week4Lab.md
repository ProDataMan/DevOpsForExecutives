# Week 4 Lab: Azure DevOps Hands-On (No Existing App Required)

## Lab Overview

**Purpose**  
This lab introduces **brand-new Azure DevOps users** to core features. You’ll create a **new project**, set up a **basic repository**, define a **pipeline** that prints messages (with an intentional failure and fix), add **user stories and tasks** with estimates, and build a **simple dashboard** showing build history and work item status. No existing app is required.

**What You’ll Accomplish**  
- **New Azure DevOps Project**: Your own workspace at `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX` (replace `XX` with your initials).  
- **Basic Repository**: A repo with a simple script and README.  
- **Pipeline**: A build pipeline that echoes text and logs timestamps, with a failure-to-success exercise.  
- **Work Items**: User stories with story points and tasks with time estimates for tracking.  
- **Dashboard**: A basic view of pipeline runs and work item status, preparing for Week 8.

**Estimated Time**  
About **75 minutes**:  
- 5 min: Sign in & create project  
- 10 min: Set up repo  
- 20 min: Create, run, and fix pipeline (includes failure fix)  
- 15 min: Add work items  
- 15 min: Set up dashboard  
- 10 min: Reflection  

**Lab Structure**  
Step-by-step guidance with detailed instructions inline. You’ll end with a functional pipeline, work items with estimates, and a dashboard in your project at `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX`, setting the stage for Week 8’s metrics-driven lab (Pages 17-21). Refer to this lab at [https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week4Lab.md](https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week4Lab.md). For a completed solution, download the contents of [https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week4/solution](https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week4/solution) to review the final repo state.

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
- Configure YAML pipeline with a failure
- Run pipeline and fix the failure
- Check logs after fix

**Detailed Instructions:**  
- **Go to Pipelines → New**: At `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX`, click "Pipelines" > "New Pipeline".  
- **Select your repo**: Choose "Azure Repos Git", select "Week4Lab" (default repo name in your project).  
- **Configure YAML pipeline with a failure**: Pick "Starter Pipeline", replace with:  
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
  Save and commit to `main`: "Added Week 4 pipeline". **Note**: This will fail because `./hello.sh` requires `bash hello.sh`.  
- **Run pipeline and fix the failure**:  
  - Click "Run". Wait ~2-3 minutes. The pipeline will fail at "Run Hello Script" with an error (e.g., "Permission denied" or "Command not found").  
  - Fix it: Edit `azure-pipelines.yml`, change `./hello.sh` to `bash hello.sh`:  
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
        bash hello.sh
      displayName: 'Run Hello Script'

    - script: |
        echo "Pipeline completed at $(date)"
      displayName: 'Log Completion'
    ```
    Commit: "Fixed pipeline with bash command". Re-run the pipeline.  
- **Check logs after fix**: Wait ~2-3 minutes. Check logs:  
  - "Checkout Code": Code pulled.  
  - "Run Hello Script": "Hello from Week 4 Lab!".  
  - "Log Completion": Timestamp (e.g., "Pipeline completed at ...").  

This exercise demonstrates a failed build and fix.

---

## Step 4: Adding User Stories and Tasks

- Go to Boards → Work Items
- Create two user stories with story points
- Add one task per story with estimates
- Link tasks to stories

**Detailed Instructions:**  
- **Go to Boards → Work Items**: At `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX`, click "Boards" > "Work Items".  
- **Create two user stories with story points**: Click "New Work Item" > "User Story":  
  - **Story 1**:  
    - Title: "As a user, I want a greeting message to confirm pipeline execution."  
    - Description: "Echo a hello message in the pipeline."  
    - Story Points: 2.  
    - State: New.  
    - Save.  
  - **Story 2**:  
    - Title: "As a manager, I want pipeline logs to monitor progress."  
    - Description: "Log completion time in pipeline output."  
    - Story Points: 2.  
    - State: New.  
    - Save.  
- **Add one task per story with estimates**:  
  - Open Story 1, "Add Link" > "New Item":  
    - Type: Task.  
    - Title: "Write hello script".  
    - Original Estimate: 2  
    - Completed: 2
    - State: Closed  
    - Save and link.  
  - Open Story 2, add:  
    - Title: "Add timestamp log".  
    - Original Estimate: 2  
    - Completed: 3 (as actual effort, showing overrun).  
    - State: Closed  
    - Save and link.  
  - **Note**: These estimates will be used in Week 8 or Week 12 to demonstrate estimate accuracy (e.g., Task 1 was spot-on, Task 2 took longer than planned).  
- **Link tasks to stories**: Verify each story shows its task in "Boards" > "Backlogs".  

These work items with estimates prepare for Week 8’s dashboard and future metrics (Page 17).

---

## Step 5: Setting Up a Basic Dashboard

- Go to Overview → Dashboards
- Create a new dashboard
- Create a query for work items
- Add Build History widget
- Add Query Tile widget
- Test dashboard updates

**Detailed Instructions:**  
- **Create a query for work items**: Before adding widgets, go to "Boards" > "Queries":  
  - Click "New Query".  
  - Name: "Open Work Items".  
  - Filter: Type = User Story, State = New.  
  - Save.  
- **Go to Overview → Dashboards**: At `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX`, click "Overview" > "Dashboards".  
- **Create a new dashboard**: Click "New Dashboard", name it "Week4Lab Dashboard", visibility "Project", save (Page 32: "Dashboard Setup").  
- **Add Build History widget**: In "Dashboards", click "Edit", search "Build History", add it. Configure:  
  - Pipeline: "Week4Lab".  
  - Size: 2x2.  
  - Save. Note: This displays as a bar chart showing build history (e.g., success/failure over time).  
- **Add Query Tile widget**: Click "Edit", add "Query Tile":  
  - Select existing query: "Open Work Items".  
  - Title: "Open Stories" (shows count, e.g., 2).  
  - Size: 2x2.  
  - Save (Page 33: "Adding Widgets").  
- **Test dashboard updates**: Edit `hello.sh` (e.g., `echo "Hello again!"`), commit, run pipeline. Refresh dashboard: Build History updates with the new run (including the earlier failure), Open Stories stays at 2. Compare with [https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week4/solution](https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week4/solution).  

This simple dashboard is a starting point for Week 8 (Page 35: "Testing Dashboard").

---

## Optional Exercises (Preparation for Week 8 and Beyond)

- Add mock test metrics
- Generate multiple pipeline runs
- Explore additional widgets

**Detailed Instructions:**  
- **Add mock test metrics**: Edit `azure-pipelines.yml`, add:  
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
- **Biggest Takeaway**: Which feature (pipeline, work items, dashboard) feels most valuable for oversight? How did fixing the pipeline failure and adding estimates enhance your understanding?  
- **Potential Uses in Your Org**: How could dashboards or pipelines improve visibility or automation?  
- **Next Steps for Week 8**: In Week 8 (Page 9, see [labs/Week8Lab.md](https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week8Lab.md)), you’ll merge a Node.js app and add metrics like lead time. How might estimate accuracy (e.g., 2h vs. 3h) play into this?  
- **Dashboard Expansion Ideas**: What metrics (e.g., estimate accuracy, trends) could enhance this for Week 12’s holistic view (see [labs/Week12Lab.md](https://github.com/ProDataMan/DevOpsForExecutives/blob/main/labs/Week12Lab.md))?  
