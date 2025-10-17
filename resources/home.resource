*** Settings ***
Library    SeleniumLibrary
Library    String
Resource   ../resources/common.resource

*** Variables ***
${LOC_SIGN_IN}              css:a.user-info, a[title*="Log in" i], a[href*="my-account"]
${LOC_LOGO_LINK}            css:#_desktop_logo a
${LOC_SEARCH_INPUT}         css:input[name="s"]

@{LOC_SEARCH_SUBMIT_CANDIDATES}
...    css:#search_widget button[type=submit]
...    css:#search_widget button
...    css:form[action*="search"] button[type=submit]
...    css:#search_widget i.material-icons.search

*** Keywords ***
Go To Sign In
    Click When Ready    ${LOC_SIGN_IN}

Go To Home Page
    Click When Ready    ${LOC_LOGO_LINK}

Submit Search Robust
    [Arguments]    ${query}
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
    IF    not ${clicked}
        Press Keys    ${LOC_SEARCH_INPUT}    RETURN
    END
    IF    not ${clicked}
        ${submitted}=    Run Keyword And Return Status
        ...    Execute JavaScript
        ...    var f=document.querySelector('#search_widget form');var q=arguments[0];var u=(f&&f.action)||'/search';window.location.href=u+(u.indexOf('?')>-1?'&':'?')+'s='+encodeURIComponent(q);return true;
        Run Keyword If    not ${submitted}    Log    JS form submit fallback did not execute (form not found).    WARN
    END

Wait For Search Results
    ${ok}=    Run Keyword And Return Status    Wait Until Element Is Visible    css:article.product-miniature    20s
    Run Keyword If    not ${ok}    Wait Until Element Is Visible    css:.products    15s

Validate Results Match Query
    [Arguments]    ${query}
    [Documentation]    Returns True if a product page title OR any product tile title contains the query (case-insensitive).
    ${q}=    Convert To Lower Case    ${query}

    # Case A: We landed on a product detail page
    ${on_pdp}=    Run Keyword And Return Status    Wait Until Element Is Visible    css:h1.h1, h1[itemprop="name"]    2s
    IF    ${on_pdp}
        ${name}=        Get Text    css:h1.h1, h1[itemprop="name"]
        ${name_lower}=  Convert To Lower Case   ${name}
        ${match}=       Run Keyword And Return Status    Should Contain    ${name_lower}    ${q}
        RETURN    ${match}
    END

    # Case B: We are on a results grid/list
    ${grid}=    Run Keyword And Return Status    Wait Until Element Is Visible    css:article.product-miniature    10s
    IF    not ${grid}
        RETURN    ${False}
    END

    ${titles}=    Get WebElements    css:article.product-miniature .product-title a, article.product-miniature h2 a, article.product-miniature .product-title
    ${found}=     Set Variable       ${False}
    FOR    ${el}    IN    @{titles}
        ${t}=          Get Text                 ${el}
        ${t_lower}=    Convert To Lower Case    ${t}
        ${ok}=         Run Keyword And Return Status    Should Contain    ${t_lower}    ${q}
        IF    ${ok}
            ${found}=  Set Variable    ${True}
            Exit For Loop
        END
    END
    RETURN    ${found}

Search For
    [Arguments]    ${query}    ${max_retries}=3
    Scroll To Top
    Run Keyword And Ignore Error    Wait Until Element Is Visible    css:#header    5s

    ${success}=    Set Variable    ${False}
    FOR    ${i}    IN RANGE    ${max_retries}
        # Type and submit
        Type Text Reliably               ${LOC_SEARCH_INPUT}    ${query}
        Submit Search Robust             ${query}
        Wait For Search Results

        # Validate results contain the query
        ${ok}=    Validate Results Match Query    ${query}
        IF    ${ok}
            ${success}=    Set Variable    ${True}
            Log    Search results matched '${query}' on attempt ${i + 1}.    INFO
            Exit For Loop
        ELSE
            Log    Results didn't match '${query}' on attempt ${i + 1}/${max_retries}. Retrying...    WARN
            # Reset back to home inside iframe and try again
            Go To Home Page
            Run Keyword And Ignore Error    Wait Until Element Is Visible    ${LOC_SEARCH_INPUT}    10s
        END
    END

    Should Be True    ${success}    msg=Search did not return expected results for '${query}' after ${max_retries} attempts.