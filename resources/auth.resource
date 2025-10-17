*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${LOC_FIRST_NAME}          id:field-firstname
${LOC_LAST_NAME}           id:field-lastname
${LOC_EMAIL}               id:field-email
${LOC_PASSWORD}            id:field-password
${LOC_CUSTOMER_PRIVACY}    name:customer_privacy
${LOC_TERMS}               name:psgdpr
${LOC_SAVE_ACCOUNT}        css:button[type='submit'].form-control-submit, button[type='submit'][data-link-action='save-customer']
${LOC_MY_ACCOUNT_MARKER}   css:.page-customer-account, #content .links
${LOC_CREATE_LINK}         xpath=//a[contains(@href,'create') or contains(.,'Create one')]

*** Keywords ***
Create New Account
    [Arguments]    ${first}    ${last}    ${email}    ${password}
    # Sometimes the page shows a sign-in form first; click "Create one" if needed
    ${_rc}    ${_}=    Run Keyword And Ignore Error    Wait Until Element Is Visible    ${LOC_FIRST_NAME}    5s
    Run Keyword If    '${_rc}'!='PASS'    Run Keyword And Ignore Error    Click Element    ${LOC_CREATE_LINK}
    Wait Until Element Is Visible    ${LOC_FIRST_NAME}    20s

    Input Text    ${LOC_FIRST_NAME}    ${first}
    Input Text    ${LOC_LAST_NAME}     ${last}
    Input Text    ${LOC_EMAIL}         ${email}
    Input Text    ${LOC_PASSWORD}      ${password}

    Run Keyword And Ignore Error    Select Checkbox    ${LOC_CUSTOMER_PRIVACY}
    Run Keyword And Ignore Error    Select Checkbox    ${LOC_TERMS}
    Click Button    ${LOC_SAVE_ACCOUNT}
    Wait Until Page Contains Element    ${LOC_MY_ACCOUNT_MARKER}    20s
