*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${CART_ITEMS}        css:.cart-items .cart-item
${CART_ICON}         css:a[href*='/cart'], #_desktop_cart a

*** Keywords ***
Go To Cart
    Run Keyword And Ignore Error    Click Element    ${CART_ICON}
    Wait Until Element Is Visible    ${CART_ITEMS}    20s

Cart Should Contain Items
    Wait Until Element Is Visible    ${CART_ITEMS}    20s
    ${count}=    Get Element Count    ${CART_ITEMS}
    Should Be True    ${count} > 0    msg=No items found in cart