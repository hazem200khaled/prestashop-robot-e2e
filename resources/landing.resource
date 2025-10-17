*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${IFRAME_LIVE}    css:iframe#framelive
@{COOKIE_ACCEPT_CANDIDATES}
...    css:button[aria-label*="Accept" i]
...    xpath=//button[contains(., 'I agree') or contains(., 'Accept')]
...    css:button.js-cookie-consent-agree
...    xpath=//button[contains(., 'OK')]

*** Keywords ***
Switch To Live Shop Iframe
    Wait Until Element Is Visible    ${IFRAME_LIVE}    40s
    Select Frame    ${IFRAME_LIVE}
    Wait Until Page Contains Element    id:header    20s

Dismiss Cookie Banner If Present
    FOR    ${locator}    IN    @{COOKIE_ACCEPT_CANDIDATES}
        ${rc}    ${msg}=    Run Keyword And Ignore Error    Click Element    ${locator}
        Run Keyword If    '${rc}'=='PASS'    Exit For Loop
    END