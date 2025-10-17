# PrestaShop E2E with Robot Framework, Selenium & Docker

## 🎯 Task
Automate the following scenario on the PrestaShop demo:

1. Open https://demo.prestashop.com/
2. Create an account
3. On the homepage, search for "notebook"
4. Open the first search result and assert it has an image
5. Add it to cart
6. Navigate to the cart
7. Assert the product is in the cart

> ⚠️ The demo shop loads inside an iframe; we switch to it and handle cookie banners. Account emails are randomized per run to avoid duplicates.

---

## 🧰 Tech Stack

- **Robot Framework** (test orchestration, readable keywords)
- **SeleniumLibrary** (browser automation)
- **FakerLibrary** (unique email generation)
- **Docker & docker-compose** (isolated, reproducible execution)
- **Selenium Standalone Chrome** (headless Chrome via Selenium Grid in a container)

### Libraries Used

- `robotframework`
- `robotframework-seleniumlibrary`
- `robotframework-faker`
- `Faker`

See `requirements.txt` for exact versions.

---

## 📂 Project Layout
prestashop-robot-e2e/
├─ tests/
│  └─ prestashop_end_to_end.robot       # Main test case
├─ resources/                           # Reusable page/flow keywords
│  ├─ common.resource
│  ├─ landing.resource
│  ├─ home.resource
│  ├─ auth.resource
│  ├─ search.resource
│  ├─ product.resource
│  └─ cart.resource
├─ requirements.txt
├─ Dockerfile                           # Robot test runner
├─ docker-compose.yml                   # Selenium + Runner
└─ README.md

---

## ▶️ Run with Docker (Recommended)

### Prerequisites
- Docker and Docker Compose installed

### Run
```bash
# From the project root
docker compose up --build --abort-on-container-exit
