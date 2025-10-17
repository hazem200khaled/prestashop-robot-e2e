*** Settings ***
Library    SeleniumLibrary
Library    FakerLibrary    locale=en_US

*** Variables ***
${WINDOW_WIDTH}     1440
${WINDOW_HEIGHT}    900


@{OVERLAY_CANDIDATES}
...    css:.modal-backdrop.show
...    css:.fade.show[role="dialog"]
...    css:.loading, .is-loading, .spinner
...    css:#blockcart-modal.show
...    css:#cookieConsent, .cookie, [id*="cookie"] .show


*** Keywords ***
Open PrestaShop Demo
    [Documentation]    Opens the demo site either locally or via Selenium Grid (REMOTE_URL).
    IF    '${REMOTE_URL}'
        Open Browser    about:blank    ${BROWSER}    remote_url=${REMOTE_URL}
    ELSE
        Open Browser    about:blank    ${BROWSER}
    END
    Set Window Size    ${WINDOW_WIDTH}    ${WINDOW_HEIGHT}
    Go To    ${BASE_URL}

Generate Unique Email
    ${email}=    FakerLibrary.Email
    RETURN    ${email}


Wait For Overlays To Disappear
    FOR    ${loc}    IN    @{OVERLAY_CANDIDATES}
        Run Keyword And Ignore Error    Wait Until Element Is Not Visible    ${loc}    2s
    END

Scroll To Top
    Execute Javascript    window.scrollTo(0,0)

Click When Ready
    [Arguments]    ${locator}    ${timeout}=20s
    Wait For Overlays To Disappear
    Wait Until Element Is Visible     ${locator}    ${timeout}
    Wait Until Element Is Enabled     ${locator}    ${timeout}
    Scroll Element Into View          ${locator}
    ${ok}=    Run Keyword And Return Status    Click Element    ${locator}
    IF    not ${ok}
        Execute Javascript    arguments[0].click();    ${locator}
    END

Type Text Reliably
    [Arguments]    ${locator}    ${text}
    # Focus the element and aggressively clear it, then type.
    Wait Until Element Is Visible     ${locator}    30s
    Click Element                     ${locator}
    Run Keyword And Ignore Error      Clear Element Text    ${locator}
    Press Keys                        ${locator}    CTRL+a
    Press Keys                        ${locator}    BACKSPACE
    Input Text                        ${locator}    ${text}
    ${val}=    Get Element Attribute  ${locator}    value
    IF    '${val}' != '${text}'
        Log    Standard typing failed ('${val}'); trying JS set value.    WARN
        Execute Javascript    arguments[0].value=arguments[1]; arguments[0].dispatchEvent(new Event('input',{bubbles:true})); arguments[0].dispatchEvent(new Event('change',{bubbles:true}));    ${locator}    ${text}
        ${val2}=    Get Element Attribute  ${locator}    value
        Should Be Equal    ${val2}    ${text}    msg=Failed to set search text via JS.
    END
    Press Keys                        ${locator}    ENTER
