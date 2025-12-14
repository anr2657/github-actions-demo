# GitHub Actions + Argo CD Demo App

This is a simple demo application that showcases a complete GitOps workflow using GitHub Actions for CI and Argo CD for CD. It includes a Node.js application, a Dockerfile, a Helm chart, and the necessary configuration files.

## Project Structure

*   `index.js`: Simple Node.js "Hello World" application.
*   `Dockerfile`: Defines how to build the container image for the app.
*   `.github/workflows/ci.yaml`: GitHub Actions workflow that builds and pushes the Docker image to GitHub Container Registry (GHCR).
*   `charts/myapp/`: A Helm chart for deploying the application to Kubernetes.
*   `argocd-app.yaml`: The Argo CD Application manifest that points to this repository and syncs the Helm chart.

## Prerequisites

*   **Kubernetes Cluster:** A running Kubernetes cluster (e.g., Minikube, Kind, Docker Desktop, or a cloud provider).
*   **Argo CD:** Installed and running in your cluster.
*   **GitHub Repository:** This code should be pushed to a GitHub repository.
*   **GitHub Container Registry (GHCR) Access:**
    *   Ensure your GitHub Actions workflow has permissions to write packages.
    *   Create a Kubernetes Secret (named `ghcr-secret`) in your cluster to allow it to pull images from GHCR (if your package is private).

## Setup & Deployment

1.  **Repository Setup:**
    *   Clone this repository.
    *   Update `charts/myapp/values.yaml`:
        *   Set `image.repository` to your GHCR image path (e.g., `ghcr.io/YOUR_USERNAME/github-actions-demo`).
    *   Update `argocd-app.yaml`:
        *   Set `repoURL` to your GitHub repository URL.

2.  **Kubernetes Secrets (for Private Images):**
    If your GHCR image is private, create a secret in your deployment namespace:
    ```bash
    kubectl create secret docker-registry ghcr-secret \
      --docker-server=ghcr.io \
      --docker-username=<YOUR_GITHUB_USERNAME> \
      --docker-password=<YOUR_GITHUB_TOKEN_OR_PAT> \
      --docker-email=<YOUR_EMAIL>
    ```

3.  **Deploy with Argo CD:**
    Apply the Argo CD application manifest:
    ```bash
    kubectl apply -f argocd-app.yaml
    ```

4.  **Verify:**
    *   Check the Argo CD UI or use `kubectl get applications -n argocd` to see the sync status.
    *   Once synced, check your application pods: `kubectl get pods`.
    *   Port-forward to test the app locally:
        ```bash
        kubectl port-forward svc/myapp 3000:3000
        ```
    *   Visit `http://localhost:3000` in your browser.

## CI/CD Flow

1.  **Commit & Push:** When you push changes to the `main` branch.
2.  **CI (GitHub Actions):**
    *   Builds the Docker image.
    *   Pushes the image to `ghcr.io`.
3.  **CD (Argo CD):**
    *   Argo CD detects changes in the Git repository (specifically the Helm chart configuration).
    *   It automatically syncs the new state to the Kubernetes cluster.
    *   (Note: For automatic image updates without chart changes, you might typically use a tool like Argo CD Image Updater, or update the image tag in your Helm values during the CI process).
