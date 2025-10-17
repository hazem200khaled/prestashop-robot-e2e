# PrestaShop End-to-End Automation with Robot Framework

This project automates an end-to-end scenario on the PrestaShop demo site using Robot Framework, SeleniumLibrary, and Docker.

## Scenario Includes
- Open PrestaShop demo inside iframe.
- Create an account (robust handling of sign-in vs registration form).
- Search for "notebook" with retry logic.
- Validate search results contain the query.
- Open the first product and verify image.
- Add product to cart and handle modal.
- Navigate to cart and assert it is not empty.
- Capture a screenshot of the cart page for evidence.

## Tech Stack
- **Robot Framework** (test orchestration)
- **SeleniumLibrary** (browser automation)
- **FakerLibrary** (generate unique emails)
- **Docker & docker-compose** (isolated execution)
- **Selenium Standalone Chrome** (headless browser)

## Docker Compose VNC Support
### Port 7900 for live browser view:
```yaml
ports:
  - "7900:7900"
```
Access via:
```
http://localhost:7900/?autoconnect=1&resize=scale&password=secret
```
Default password: `secret`

### Port 5900 for VNC access:
```yaml
ports:
  - "5900:5900"
```
Access via VNC:
```
localhost:5900
```
Default password: `secret`

## How to Run with Docker
### Prerequisites
- Docker & Docker Compose installed.

### Run Tests
```bash
docker compose up --build --abort-on-container-exit
```

### View Browser in Real Time (Optional)
Open:
```
http://localhost:7900/?autoconnect=1&resize=scale&password=secret
```

### Cleanup
```bash
docker compose down
```

## Evidence & Reports
Robot Framework reports:
- `results/log.html`
- `results/report.html`

Screenshots:
- `results/evidence/cart_with_items.png`

> These results are not pushed to Git. They appear after running `docker compose`.

## Test Flow Summary
- Open PrestaShop demo → Switch to iframe → Dismiss cookies.
- Create account → Go to Home → Search for notebook (retry if mismatch).
- Validate results → Open first product → Verify image.
- Add to cart → Handle modal → Go to cart.
- Assert cart not empty → Capture screenshot.
