*** Settings ***
Documentation     End-to-end test: Create account, search notebook, add to cart, and verify.
Library           SeleniumLibrary    timeout=20    implicit_wait=1    run_on_failure=NOTHING
Library           FakerLibrary    locale=en_US
Resource          ../resources/common.resource
Resource          ../resources/landing.resource
Resource          ../resources/home.resource
Resource          ../resources/auth.resource
Resource          ../resources/search.resource
Resource          ../resources/product.resource
Resource          ../resources/cart.resource
Suite Setup       Open PrestaShop Demo
Suite Teardown    Close All Browsers

*** Variables ***
${BASE_URL}       https://demo.prestashop.com/
${BROWSER}        chrome
${REMOTE_URL}     ${EMPTY}
${SEARCH_TERM}    notebook
${FIRST_NAME}     Hazem
${LAST_NAME}      Tester
${PASSWORD}       P@ssw0rd123456!

*** Test Cases ***
Create account, search notebook, add to cart and verify
    [Documentation]    - Open demo site
    ...                - Switch to live shop iframe
    ...                - Dismiss cookies
    ...                - Create an account (uses random email)
    ...                - Search for "notebook"
    ...                - Open first result and verify image visible
    ...                - Add to cart and go to cart
    ...                - Assert product exists in cart
    Switch To Live Shop Iframe
    Go To Sign In
    ${email}=    Generate Unique Email
    Create New Account    ${FIRST_NAME}    ${LAST_NAME}    ${email}    ${PASSWORD}
    Go To Home Page
    Search For    ${SEARCH_TERM}
    Open First Search Result
    Product Image Should Be Visible
    Add Product To Cart And Go To Cart
    Ensure On Cart Page
    Cart Should Contain Items
    Capture Cart Evidence
