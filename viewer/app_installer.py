# Databricks notebook source
# MAGIC %md
# MAGIC # Model Viewer App Installer
# MAGIC
# MAGIC This notebook deploys the **Model Viewer** Databricks App to your workspace.
# MAGIC It will:
# MAGIC 1. Upload the app source code to your workspace
# MAGIC 2. Create or update the Databricks App
# MAGIC 3. Deploy the app
# MAGIC 4. Print the app URL for you to open and share

# COMMAND ----------

# MAGIC %md
# MAGIC ## Configuration
# MAGIC Set the app name below. Change it if you want a different URL slug.

# COMMAND ----------

APP_NAME = "model-viewer-app"

# COMMAND ----------

import os
import time
import json
import requests

# Get workspace context
ctx = dbutils.notebook.entry_point.getDbutils().notebook().getContext()
host = ctx.apiUrl().get()
token = ctx.apiToken().get()
username = ctx.userName().get()

headers = {
    "Authorization": f"Bearer {token}",
    "Content-Type": "application/json",
}

# Workspace path for app source code
notebook_path = dbutils.notebook.entry_point.getDbutils().notebook().getContext().notebookPath().get()
repo_root = "/".join(notebook_path.split("/")[:-2])  # go up from viewer/app_installer
app_source_path = f"{repo_root}/viewer/model-viewer-app"

print(f"Workspace host: {host}")
print(f"Username: {username}")
print(f"App source path: {app_source_path}")
print(f"App name: {APP_NAME}")

# COMMAND ----------

# MAGIC %md
# MAGIC ## Step 1: Verify app source exists in workspace

# COMMAND ----------

try:
    resp = requests.get(
        f"{host}/api/2.0/workspace/get-status",
        headers=headers,
        params={"path": f"{app_source_path}/app.yaml"},
    )
    if resp.status_code == 200:
        print(f"App source found at: {app_source_path}")
    else:
        raise Exception(
            f"App source not found at {app_source_path}. "
            f"Make sure this repo is synced to your workspace. "
            f"Response: {resp.text}"
        )
except Exception as e:
    print(f"ERROR: {e}")
    dbutils.notebook.exit(str(e))

# COMMAND ----------

# MAGIC %md
# MAGIC ## Step 2: Create or update the Databricks App

# COMMAND ----------

# Check if app already exists
resp = requests.get(f"{host}/api/2.0/apps/{APP_NAME}", headers=headers)

if resp.status_code == 200:
    app_info = resp.json()
    print(f"App '{APP_NAME}' already exists.")
    print(f"  URL: {app_info.get('url', 'N/A')}")
    print(f"  Status: {app_info.get('app_status', {}).get('state', 'N/A')}")
else:
    print(f"Creating app '{APP_NAME}'...")
    resp = requests.post(
        f"{host}/api/2.0/apps",
        headers=headers,
        json={
            "name": APP_NAME,
            "description": "Data Model Viewer - interactive graph visualization for metamodel JSON files",
        },
    )
    if resp.status_code in (200, 201):
        app_info = resp.json()
        print(f"App created successfully!")
        print(f"  URL: {app_info.get('url', 'N/A')}")
    else:
        print(f"ERROR creating app: {resp.status_code} - {resp.text}")
        dbutils.notebook.exit(f"Failed to create app: {resp.text}")

# COMMAND ----------

# MAGIC %md
# MAGIC ## Step 3: Deploy the app

# COMMAND ----------

print(f"Deploying app from: {app_source_path}")

resp = requests.post(
    f"{host}/api/2.0/apps/{APP_NAME}/deployments",
    headers=headers,
    json={
        "source_code_path": app_source_path,
        "mode": "SNAPSHOT",
    },
)

if resp.status_code in (200, 201):
    deployment = resp.json()
    deployment_id = deployment.get("deployment_id", "unknown")
    print(f"Deployment started: {deployment_id}")
else:
    print(f"ERROR deploying: {resp.status_code} - {resp.text}")
    dbutils.notebook.exit(f"Failed to deploy: {resp.text}")

# COMMAND ----------

# MAGIC %md
# MAGIC ## Step 4: Wait for deployment to complete

# COMMAND ----------

print("Waiting for deployment to complete...")
max_wait = 300  # 5 minutes
start = time.time()

while time.time() - start < max_wait:
    resp = requests.get(f"{host}/api/2.0/apps/{APP_NAME}", headers=headers)
    if resp.status_code == 200:
        info = resp.json()
        deploy_status = info.get("active_deployment", {}).get("status", {})
        app_status = info.get("app_status", {})
        state = deploy_status.get("state", "UNKNOWN")
        message = deploy_status.get("message", "")

        if state == "SUCCEEDED":
            app_url = info.get("url", "")
            print(f"\n{'='*60}")
            print(f"  DEPLOYMENT SUCCESSFUL!")
            print(f"{'='*60}")
            print(f"\n  App URL: {app_url}")
            print(f"\n  Open the URL above to use the Model Viewer.")
            print(f"  Upload a model.json file to visualize your data model.")
            print(f"\n  Share this URL with your team:")
            print(f"  {app_url}")
            print(f"\n{'='*60}")
            break
        elif state == "FAILED":
            print(f"\nDeployment FAILED: {message}")
            dbutils.notebook.exit(f"Deployment failed: {message}")
            break
        else:
            print(f"  Status: {state} - {message}")
    time.sleep(10)
else:
    print("Deployment timed out after 5 minutes. Check the app status manually.")

# COMMAND ----------

# MAGIC %md
# MAGIC ## Done!
# MAGIC
# MAGIC Your Model Viewer app is now deployed and ready to use.
# MAGIC
# MAGIC **How to use:**
# MAGIC 1. Open the app URL printed above
# MAGIC 2. Click **Upload JSON** to load a `model.json` file
# MAGIC 3. Explore domains, products, attributes, and foreign key relationships
# MAGIC
# MAGIC **Features:**
# MAGIC - Interactive graph visualization with multiple layouts (Circular, Clustered, Force, Grid)
# MAGIC - Domain hierarchy browser with search
# MAGIC - FK relationship explorer (click any product)
# MAGIC - Adjustable node/font sizes (F+/F- buttons)
# MAGIC - Domain toggle to show/hide domain groupings
