# Week 8 lab ("Building an Executive Dashboard")
The lab involves building a pipeline in Azure DevOps with prebuilt code, generating DORA and DevOps metrics, and creating an executive dashboard.

The instructions assume basic familiarity with Azure DevOps (from Week 4) and YAML, as noted in "Lab Prerequisites" (Slide 23). The lab will produce the six key DevOps metrics (deployment frequency, lead time, MTTR, change failure rate, application availability, defect escape rate) used throughout the slides.

---

### Step-by-Step Lab Instructions

#### Lab Overview
In this Week 8 lab, you’ll build a CI/CD pipeline in Azure DevOps using a prebuilt Node.js application, configure it to log DORA and DevOps metrics, and create an executive dashboard to visualize these metrics for leadership. The lab takes about 60-90 minutes and uses Azure DevOps’ free tier. By the end, you’ll have a functional pipeline and dashboard demonstrating DevOps value.

#### Prerequisites
- **Azure DevOps Account**: Sign up for a free account at [azure.microsoft.com](https://azure.microsoft.com/en-us/services/devops/) if you don’t have one (Slide 23).
- **Forked Sample Repository**: You’ll fork a provided GitHub repo (detailed below) into your Azure DevOps project.
- **Basic YAML Knowledge**: Familiarity with editing YAML files (e.g., from Week 4 or [yaml.org](https://yaml.org/)).
- **Web Browser**: Use Chrome, Edge, or Firefox for the Azure DevOps portal.

#### Lab Steps

##### Step 1: Set Up Your Azure DevOps Environment
1. **Log In to Azure DevOps**:
   - Navigate to [dev.azure.com](https://dev.azure.com), sign in with your Microsoft account, and create an organization if prompted (e.g., "DevOpsWorkshop").
   - Create a new project named "Week8Lab" (public, Git, Agile template).
   - **Why**: Ensures you have a workspace for the lab (Slide 23).

2. **Fork the Sample Repository**:
   - Go to the provided GitHub repo: [github.com/example/week8-sample-app](https://github.com/example/week8-sample-app) (see artifacts below).
   - Click "Fork" to copy it to your GitHub account.
   - In Azure DevOps, go to "Repos" > "Import a repository":
     - Enter your forked GitHub URL (e.g., `https://github.com/yourusername/week8-sample-app`).
     - Import it into your "Week8Lab" project.
   - **Why**: Provides prebuilt code for the pipeline (Slide 26).

3. **Verify Repository Contents**:
   - In "Repos" > "Files", confirm you see:
     - `index.js` (Node.js app)
     - `package.json` (dependencies)
     - `test.js` (test script)
     - `azure-pipelines.yml` (initial pipeline)
   - **Why**: Ensures the code base is ready (Slide 26).

##### Step 2: Configure the Pipeline
4. **Edit the Pipeline YAML**:
   - In "Repos" > "Files", open `azure-pipelines.yml`.
   - Replace its contents with the YAML below (see artifacts):
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
         echo "ChangeFailureRate=5" >> $GITHUB_ENV  # Mock scan failure rate
         echo "DefectEscapeRate=1" >> $GITHUB_ENV  # Mock defect escape
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
   - Save and commit to the `main` branch.
   - **Why**: Defines stages to log metrics (Slide 19).

5. **Run the Pipeline Manually**:
   - Go to "Pipelines" > "Builds", select the pipeline (auto-created from YAML), and click "Run pipeline".
   - Wait ~5 minutes for completion.
   - **Why**: Generates initial metrics (Slide 22).

6. **Check Pipeline Logs**:
   - Click the completed run, then each step’s logs.
   - Look for outputs like:
     - `LeadTimeMinutes=0` (simulated deploy time).
     - `ChangeFailureRate=5` (mock scan result).
     - `MTTRMinutes=0` (simulated recovery).
   - Note the run number (e.g., "20250402.1") for deployment frequency.
   - **Why**: Validates metric logging (Slide 21).

##### Step 3: Build the Executive Dashboard
7. **Create a New Dashboard**:
   - Go to "Boards" > "Dashboards", click "New Dashboard".
   - Name it "DevOps Metrics", set visibility to "Project", and save.
   - **Why**: Sets up visualization (Slide 24).

8. **Add Widgets for Metrics**:
   - Click "Edit" on the dashboard:
     - Add "Build History" widget (configure for "Week8Lab" pipeline, show last 5 builds as a pie chart for pass/fail).
     - Add "Query Results" widget (create a query for pipeline logs, extract `LeadTimeMinutes`, show as a line chart).
     - Add "Pipeline Overview" widget (select "Week8Lab", show build frequency as a bar chart).
   - Arrange widgets for clarity.
   - **Why**: Visualizes key metrics (Slide 25).

9. **Map Data to Widgets**:
   - For "Query Results" widget:
     - Create a query in "Queries" > "New Query":
       - Filter: Work Item Type = Build, Pipeline = Week8Lab.
       - Add a custom field for `LeadTimeMinutes` from logs (manual entry for simplicity).
     - Save and link to the widget.
   - Adjust other widgets to reflect logs (e.g., `ChangeFailureRate` in Build History).
   - **Why**: Ensures data accuracy (Slide 26).

10. **Test Dashboard Functionality**:
    - Trigger another pipeline run (edit `index.js`, e.g., add a comment, commit).
    - Watch the dashboard update (~5 minutes).
    - Confirm metrics like lead time trend downward or frequency increases.
    - **Why**: Validates real-time updates (Slide 27).

##### Step 4: Validate and Interpret Results
11. **Validate Metrics**:
    - Compare dashboard visuals to pipeline logs:
      - Deployment frequency: Count runs (e.g., 2 in lab).
      - Lead time: Check `LeadTimeMinutes` trend.
      - MTTR: Verify `MTTRMinutes` from recovery step.
      - Change failure rate: See pass/fail ratio.
      - Availability/Defect escape: Check mock values (99%, 1).
    - **Why**: Ensures accuracy (Slide 31).

12. **Interpret Strategically**:
    - Note trends (e.g., lead time ~0 due to simulation, adjust for real scenarios).
    - Link to goals (Slide 34):
      - Speed: Faster delivery (frequency/lead time).
      - Stability: Low failure/defect rates.
      - Efficiency: High availability, quick MTTR.
    - Prepare a 2-minute executive summary (e.g., "Frequent, safe releases save costs").
    - **Why**: Prepares leadership communication (Slide 35).

#### Wrap-Up
- Save your dashboard and pipeline configuration.
- Review Slide 38 ("Lab Recap") for achievements.
- Prepare for Week 9’s ROI focus using this data (Slide 40).

---

### Prerequisite Code and Artifacts

#### Sample Repository Structure
Provided GitHub repo (`week8-sample-app`) contains these files:

1. **`index.js`** (Simple Node.js App):
   ```javascript
   const express = require('express');
   const app = express();
   app.get('/', (req, res) => res.send('Hello, DevOps!'));
   app.listen(3000, () => console.log('App running on port 3000'));
   module.exports = app; // For testing
   ```

2. **`package.json`** (Dependencies):
   ```json
   {
     "name": "week8-sample-app",
     "version": "1.0.0",
     "main": "index.js",
     "scripts": {
       "start": "node index.js",
       "test": "node test.js"
     },
     "dependencies": {
       "express": "^4.17.1"
     }
   }
   ```

3. **`test.js`** (Basic Test):
   ```javascript
   const app = require('./index');
   const assert = require('assert');
   assert.ok(true, 'App loads'); // Simple pass
   console.log('Tests passed');
   ```

4. **`azure-pipelines.yml`** (Initial Placeholder, Replaced in Lab):
   ```yaml
   trigger:
     - main
   pool:
     vmImage: 'ubuntu-latest'
   steps:
   - script: echo "Placeholder pipeline"
     displayName: 'Initial Run'
   ```

#### Notes on Artifacts
- **Simplicity**: The Node.js app is minimal to focus on pipeline setup, not coding.
- **Metrics**: The YAML uses mock values (e.g., `sleep 5` for lead time, fixed 5% failure rate) for demo purposes. In a real scenario, replace with actual scans (e.g., SonarQube) or deployment times.
- **Flexibility**: Adjust `sleep` durations or failure conditions (e.g., `exit 1` in tests) to simulate varied outcomes.

---

### Integration with Slides
- **Step 1**: Slide 21-23 ("Hands-On Lab Introduction", "Lab Prerequisites", "Lab Structure").
- **Step 2**: Slide 25-30 ("Pipeline Setup Details", "Forking Repository", "Configuring YAML", "Pipeline Stages", "Metrics Logging", "Pipeline Validation").
- **Step 3**: Slide 31-35 ("Dashboard Creation Process", "Dashboard Setup", "Adding Widgets", "Mapping Data", "Testing Dashboard").
- **Step 4**: Slide 41-49 ("Lab Execution Steps", "Validating Results", "Metrics Analysis Deep Dive", "Strategic Alignment Principles").
- **Wrap-Up**: Slide 53-54 ("Wrap-Up and Future Steps").

---

### Validation
- **Metrics Generated**:
  - Deployment frequency: Count of runs (manual + triggered).
  - Lead time: Simulated via deploy step (~5s, logged as minutes).
  - MTTR: Simulated recovery (~3s, logged as minutes).
  - Change failure rate: Mock 5% from scan.
  - Availability: Mock 99%.
  - Defect escape rate: Mock 1 bug.
- **Time**: ~60-90 minutes, fitting a workshop session.
- **Free Tier**: Uses Azure DevOps’ free tier (5 users, unlimited pipelines).
