# 🌀 Self-Hosted Azure API Management Developer Portal

[![Docker](https://img.shields.io/badge/containerized-Docker-blue)](https://www.docker.com/)
[![Node.js](https://img.shields.io/badge/node-20.x-brightgreen)](https://nodejs.org/)
[![APIM](https://img.shields.io/badge/azure-apim-blue)](https://azure.microsoft.com/en-us/products/api-management/)

This repository provides a **self-hosted version of the Azure API Management Developer Portal**, preconfigured to:

- Clone the official Microsoft portal source
- Inject dynamic config using **runtime environment variables**
- Build the static portal site on container startup
- Serve the user-facing portal using `webpack`

> Supports version: `2.27.0` of the portal

---

## 🚀 Quick Start

### 🔧 Build the Docker Image

```bash
docker build -t apim-dev-portal:2.27.0 .
```

### ▶️ Run the Container

```bash
docker run --rm -p 8080:8080 \
  -e ACCESS_TOKEN="your-azure-arm-access-token" \
  -e APIM_SERVICE_NAME="your-apim-service-name" \
  -e GOOGLE_FONTS_API_KEY="your-google-fonts-api-key" \
  apim-dev-portal:2.27.0
```

Then open your browser at: [http://localhost:8080](http://localhost:8080)

---

## ⚙️ Environment Variables

| Variable                | Required | Description |
|-------------------------|----------|-------------|
| `ACCESS_TOKEN`          | ✅       | Azure access token for `https://management.azure.com` |
| `APIM_SERVICE_NAME`     | ✅       | Your API Management service name |
| `GOOGLE_FONTS_API_KEY`  | ❌       | Optional key for loading custom fonts in the designer |
| `DESIGNER_MODE`         | ❌       |  Whether to run the portal in designer mode (default: `false`) |

---

## 🧱 How It Works

At runtime, the container:

1. Clones the [official Microsoft Developer Portal](https://github.com/Azure/api-management-developer-portal)
2. Checks out tag `2.27.0`
3. Copies in the template config files
4. Generates actual `config.*.json` files using environment variables
5. Builds the publisher (end-user) portal
6. Serves the built site using `webpack`

---

## 📁 Project Structure

```
.
├── Dockerfile
├── generate-configs.js                 # Reads env vars and generates config.*.json
├── config.design.template.json
├── config.publish.template.json
├── config.runtime.template.json
└── README.md
```

> The actual `config.*.json` files are generated at container runtime and **not stored in the repo**.

---

## 🛠 Developer Notes

- The container only serves the **publisher (end-user)** portal.
- To use the **designer/editor** portal (`npm start`), simply set `DESIGNER_MODE=true` as an environment variable at runtime.
- You can run this behind a reverse proxy or inject configs using Kubernetes secrets.

---

## 🔐 Security

- Never commit tokens or secrets to version control.
- Use secret injection in your deployment platform (e.g., Docker secrets, GitHub Actions, Azure DevOps).
- Avoid embedding access tokens in config templates or source code.

---

## 📄 License

This project wraps the [Azure/api-management-developer-portal](https://github.com/Azure/api-management-developer-portal), which is licensed under the [MIT License](https://github.com/Azure/api-management-developer-portal/blob/master/LICENSE).

---

## 🤝 Contributing

PRs are welcome to improve config templating, build flexibility, or deployment tooling. Feel free to fork or submit improvements for multi-environment support, CI/CD pipelines, etc.
