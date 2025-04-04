# Week 12 Lab: Advanced Dashboard with Terraform-Driven Metrics

## Lab Overview

**Purpose**  
In Week 12 of the "DevOps for Executive Leadership" workshop, you’ll integrate a prebuilt Terraform configuration into your Week 8 Azure DevOps project at `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX` (replace `XX` with your initials). This configuration provisions an AWS EC2 instance and deploys a basic web app, intentionally introducing deployment failures and slow deploys. You’ll enhance your Week 8 dashboard to visualize deployment frequency, history, failure rates, and estimate accuracy, providing a comprehensive view for executive oversight. An Azure alternate version will follow once the AWS setup is validated.

**What You’ll Accomplish**  
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

## Step 3: Enhance the Dashboard

7. **Create New Queries**  
   - At `https://devopsclassroom.visualstudio.com/Week4-Lab-DemoXX`, go to "Boards" > "Queries":  
     - **Query 1: Deployment History**  
       - Name: "Deployment History".  
       - Filter: Build, Pipeline = Week4Lab, last 10 runs.  
       - Columns: Build Number, Status, Duration.  
       - Save.  
     - **Query 2: Task Estimates** (from Week 8, reused).  

8. **Update Week 8 Dashboard**  
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

9. **Test Dashboard**  
   - Trigger another pipeline run.  
   - Refresh dashboard:  
     - Deployment History shows run successes/failures.  
     - Frequency increases, Lead Time reflects delays, Task Estimates remain static.  
   - Compare with [https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week12/solution](https://github.com/ProDataMan/DevOpsForExecutives/tree/main/week12/solution).

---

## Step 4: Validate and Interpret

10. **Validate Metrics**  
    - Check logs and dashboard:  
      - Deployment Frequency: ~5-10 runs, varying success.  
      - Failure Rate: ~50% from Terraform, plus Node.js test failures.  
      - Lead Time: ~40s+ due to delays.  
      - Estimate Accuracy: Task 1 (100%), Task 2 (67%) from Week 4.  
    - **Why**: Confirms rich data for analysis.

11. **Interpret Results**  
    - Strategic insights:  
      - High failure rate (50%) suggests deployment reliability issues.  
      - Long lead times (40s+) indicate optimization needs.  
      - Estimate accuracy shows planning gaps (Task 2 overrun).  
    - Executive summary: "Frequent but unreliable deploys with planning inaccuracies require process refinement."  
    - **Why**: Provides actionable leadership insights.

---

## Step 5: Plan Azure Alternate

12. **Azure Version Outline**  
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
