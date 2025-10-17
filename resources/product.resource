*** Settings ***
Library    SeleniumLibrary
Resource   ../resources/common.resource

*** Variables ***
# Product page
${PRODUCT_IMAGE}               css:img.js-qv-product-cover, .images-container img
${ADD_TO_CART}                 css:button.add-to-cart, button[data-button-action='add-to-cart']

# Add-to-cart modal & controls (target inside the modal)
${LOC_CART_MODAL}              css:#blockcart-modal, .modal.show, .modal.fade.in
${LOC_MODAL_PROCEED}           css:#blockcart-modal a.btn-primary, #blockcart-modal .cart-content-btn a[href*='/cart'], #blockcart-modal a[href*='/cart']
${LOC_MODAL_CLOSE}             css:#blockcart-modal button.close, #blockcart-modal .close

# (Keep a conservative header/cart fallback for emergencies)
${LOC_HEADER_CART}             css:#_desktop_cart a[href*='/cart'], a[aria-label*='Shopping cart']

*** Keywords ***
Product Image Should Be Visible
    Wait Until Element Is Visible    ${PRODUCT_IMAGE}    30s
    Element Should Be Visible        ${PRODUCT_IMAGE}

Add Product To Cart And Go To Cart
    # Click "Add to cart"
    Click When Ready                 ${ADD_TO_CART}

    # Wait for modal to appear (first preference)
    ${modal}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${LOC_CART_MODAL}    10s

    IF    ${modal}
        # Click the "Proceed to checkout" button INSIDE the modal
        Wait Until Element Is Visible    ${LOC_MODAL_PROCEED}    15s
        # Prefer a robust click helper to avoid interception
        Click When Ready                 ${LOC_MODAL_PROCEED}
    ELSE
        # No modal? Fallback to header cart after ensuring no overlay remains
        Run Keyword And Ignore Error     Wait Until Element Is Not Visible    ${LOC_CART_MODAL}    3s
        Click When Ready                 ${LOC_HEADER_CART}
    END

    # Safety: ensure we actually land on the cart page within the iframe
    ${on_cart}=    Run Keyword And Return Status    Wait Until Element Is Visible    css:.cart-items .cart-item    15s
    IF    not ${on_cart}
        # As a final fallback, navigate directly inside the iframe context
        ${href}=    Execute Javascript    var a=document.querySelector('#blockcart-modal a.btn-primary, #blockcart-modal .cart-content-btn a[href*="/cart"], a[href*="/cart"]'); return a && a.href ? a.href : '/cart';
        Go To    ${href}
        Wait Until Element Is Visible    css:.cart-items .cart-item    20s
    END