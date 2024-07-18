# Create the pool
gcloud iam workload-identity-pools create "github-pool" --project="jeffovertonsamples"  --location="global" --display-name="GitHub Actions Pool"
# Create the provider
gcloud iam workload-identity-pools providers create-oidc "github-provider"  --project="jeffovertonsamples" --location="global" --workload-identity-pool="github-pool" --display-name="GitHub Actions Provider" --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.repository=assertion.repository" --issuer-uri="https://token.actions.githubusercontent.com"
# Create the service account
gcloud iam service-accounts create "terraform-github" --project="jeffovertonsamples" --display-name="Terraform GitHub Actions"
# Allow Workload Identity Federation to Impersonate the Service Account
gcloud iam service-accounts add-iam-policy-binding "terraform-github@jeffovertonsamples.iam.gserviceaccount.com" --project="jeffovertonsamples" --role="roles/iam.workloadIdentityUser" --member="principalSet://iam.googleapis.com/projects/740598049160/locations/global/workloadIdentityPools/github-pool/attribute.repository/jco281/sampleIAC"
# Role Bindings for Flask App testing
gcloud projects add-iam-policy-binding jeffovertonsamples --member="serviceAccount:terraform-github@jeffovertonsamples.iam.gserviceaccount.com" --role="roles/storage.admin"
#Create creds file
gcloud iam workload-identity-pools create-cred-config projects/740598049160/locations/global/workloadIdentityPools/github-pool/providers/github-provider --service-account="terraform-github@jeffovertonsamples.iam.gserviceaccount.com"  --output-file="C:\Users\jeeff\IdeaProjects\sampleIAC\infra\GCP\terraform\bucket\credentials.json" --credential-source-file="C:\Users\jeeff\IdeaProjects\sampleIAC\infra\GCP\terraform\bucket\identity-token-file.json"
# Create local auth file
gcloud auth application-default login --project jeffovertonsamples
# Create ENV variables
$env:GOOGLE_APPLICATION_CREDENTIALS="C:/path/to/credentials.json"
