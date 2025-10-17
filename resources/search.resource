*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${PRODUCT_CARDS}        css:article.product-miniature
${FIRST_PRODUCT_LINK}   css:article.product-miniature a.product-thumbnail, article.product-miniature a.thumbnail

*** Keywords ***
Open First Search Result
    Wait Until Element Is Visible    ${PRODUCT_CARDS}    20s
    Wait Until Element Is Visible    ${FIRST_PRODUCT_LINK}    20s
    Click Element    ${FIRST_PRODUCT_LINK}
