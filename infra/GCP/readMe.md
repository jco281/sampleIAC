# Terraform Examples for Google Cloud

This repository contains Terraform configuration files for deploying resources on Google Cloud Platform (GCP). The examples include creating a Google Cloud Storage bucket, uploading an application zip file to the bucket, and deploying the application to Google App Engine.

## Prerequisites

- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install) installed and configured.
- [Terraform](https://www.terraform.io/downloads.html) installed.
- A Google Cloud Platform project with billing enabled.
- A service account with the necessary permissions (`roles/storage.admin`, `roles/appengine.appAdmin`, `roles/iam.serviceAccountUser`).

## Setup Instructions

### 1. Authentication

Ensure that your Google Cloud SDK is authenticated:

```bash
gcloud auth application-default login --project jeffovertonsamples
```