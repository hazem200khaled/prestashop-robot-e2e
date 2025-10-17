*** Settings ***
Library    SeleniumLibrary
Resource   ../resources/common.resource

*** Variables ***
${LOC_SIGN_IN}              css:a.user-info, a[title*="Log in" i], a[href*="my-account"]
${LOC_LOGO_LINK}            css:#_desktop_logo a
${LOC_SEARCH_INPUT}         css:input[name="s"]

@{LOC_SEARCH_SUBMIT_CANDIDATES}
# ...    css:#search_widget button[type=submit]
# ...    css:#search_widget button
# ...    css:form[action*="search"] button[type=submit]
...    css:#search_widget i.material-icons.search

*** Keywords ***
Go To Sign In
    Ensure In Live Shop Frame
    Click When Ready    ${LOC_SIGN_IN}

Go To Home Page
    Ensure In Live Shop Frame
    Click When Ready    ${LOC_LOGO_LINK}

Submit Search Robust
    [Arguments]    ${query}
    # Try clicking a submit control first
    ${clicked}=    Set Variable    ${False}
    FOR    ${loc}    IN    @{LOC_SEARCH_SUBMIT_CANDIDATES}
        ${vis}=    Run Keyword And Return Status    Wait Until Element Is Visible    ${loc}    2s
        IF    ${vis}
            ${clicked}=    Run Keyword And Return Status    Click Element    ${loc}
            IF    ${clicked}
                Exit For Loop
            END
        END
    END
    # Fallback 1: press ENTER
    IF    not ${clicked}
        Press Keys    ${LOC_SEARCH_INPUT}    RETURN
    END
    # Fallback 2: JS navigate inside iframe (build the search URL manually)
    IF    not ${clicked}
        ${submitted}=    Run Keyword And Return Status
        ...    Execute Javascript
        ...    var f=document.querySelector('#search_widget form');var q=arguments[0];var u=(f&&f.action)||'/search';window.location.href=u+(u.indexOf('?')>-1?'&':'?')+'s='+encodeURIComponent(q);return true;
        Run Keyword If    not ${submitted}    Log    JS form submit fallback did not execute (form not found).    WARN
    END

Wait For Search Results
    # Wait for either product cards or the products grid
    ${ok}=    Run Keyword And Return Status    Wait Until Element Is Visible    css:article.product-miniature    20s
    Run Keyword If    not ${ok}    Wait Until Element Is Visible    css:.products    15s

Search For
    [Arguments]    ${query}
    # Ensure In Live Shop Frame
    # Scroll To Top
    # # Make sure header present
    # Run Keyword And Ignore Error    Wait Until Element Is Visible    css:#header    5s
    # Type robustly and submit
    Type Text Reliably               ${LOC_SEARCH_INPUT}    ${query}
    Submit Search Robust             ${query}
    Wait For Search Results
