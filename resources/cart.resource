*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Resource   ../resources/common.resource

*** Variables ***
${CART_ITEMS}        css:.cart-items .cart-item
${CART_ICON}         css:a[href*='/cart'], #_desktop_cart a
${LOC_HEADER_CART}    css:#_desktop_cart a[href*='/cart'], a[aria-label*='Shopping cart']

*** Keywords ***
Go To Cart
    Run Keyword And Ignore Error    Click Element    ${CART_ICON}
    Wait Until Element Is Visible    ${CART_ITEMS}    20s

Cart Should Contain Items
    Wait Until Element Is Visible    ${CART_ITEMS}    20s
    ${count}=    Get Element Count    ${CART_ITEMS}
    Should Be True    ${count} > 0    msg=No items found in cart

Ensure On Cart Page
    [Documentation]    Make sure we are in the cart inside the iframe (navigate if needed).
    ${on_cart}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${CART_ITEMS}    3s
    IF    not ${on_cart}
        ${clicked}=    Run Keyword And Return Status    Click When Ready    ${LOC_HEADER_CART}
        IF    not ${clicked}
            ${href}=    Execute Javascript    var a=document.querySelector('#_desktop_cart a[href*="/cart"], a[aria-label*="Shopping cart"]'); return a && a.href ? a.href : '/cart';
            Go To    ${href}
        END
        Wait Until Element Is Visible    ${CART_ITEMS}    30s
    END

Capture Cart Evidence
    [Arguments]    ${filename}=cart_not_empty
    [Documentation]    Save a screenshot under results/evidence/${filename}.png
    ${evidence_dir}=    Set Variable    ${OUTPUT DIR}${/}evidence
    Create Directory    ${evidence_dir}
    Set Screenshot Directory    ${evidence_dir}
    Capture Page Screenshot     ${filename}.png
    Log                         Saved cart screenshot: ${evidence_dir}${/}${filename}.png