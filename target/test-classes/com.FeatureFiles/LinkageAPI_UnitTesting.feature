Feature: API level unit testing for linkage service

  Background: Authetication API for obtaining a authetication token for unique session
    Given url 'https://sandbox.apihub.citi.com/gcb/api'
    And path '/clientCredentials/oauth2/token/hk/gcb'
    And header Authorization = 'Basic NWFkODRmZjYtMmVmOS00MDJkLTljYmEtZDEyYmZjYjQxZmFhOnVHMnlKN2FOMnZEM2RXM3RMN3VVOGZKOHRNOG9HMndSMHFQMGtHNmFDMGpYNWVQMmhZ'
    And header Content-Type = 'application/x-www-form-urlencoded'
    And request 'grant_type=client_credentials&scope=/api'
    When method POST
    Then status 200
    And match response.token_type == 'Bearer'
    And match response.access_token != null
    * def accessToken = response.access_token
    * def Auth = 'Bearer '+accessToken

  Scenario: Verify the LinkageAPI with all mandatory body parameters
    Given url 'https://sandbox.apihub.citi.com/gcb/api'
    And path '/v1/apac/rewards/linkage'
    And header Authorization = Auth
    And header Accept = 'application/json'
    And header Content-Type = 'application/json'
    And header client_id = '5ad84ff6-2ef9-402d-9cba-d12bfcb41faa'
    And request '{"lastFourDigitsCardNumber": "8653","citiCardHolderPhoneNumber": "6590020056","merchantCustomerReferenceId":"6300804530034"}'
    When method POST
    Then status 200
    And match response.rewardLinkCode != null

  Scenario: Verify the LinkageAPI with invalid lastFourDigitsCardNumber in body parameters
    Given url 'https://sandbox.apihub.citi.com/gcb/api'
    And path '/v1/apac/rewards/linkage'
    And header Authorization = Auth
    And header Accept = 'application/json'
    And header Content-Type = 'application/json'
    And header client_id = '5ad84ff6-2ef9-402d-9cba-d12bfcb41faa'
    And request '{"lastFourDigitsCardNumber": "1234","citiCardHolderPhoneNumber": "6590020056","merchantCustomerReferenceId":"6300804530034"}'
    When method POST
    Then status 400
    And match response.type == 'invalid'
    And match response.code == 'invalidRequest'
    And match response.details == 'Missing or invalid parameters'

  Scenario: Verify the LinkageAPI with invalid citiCardHolderPhoneNumber in body parameters
    Given url 'https://sandbox.apihub.citi.com/gcb/api'
    And path '/v1/apac/rewards/linkage'
    And header Authorization = Auth
    And header Accept = 'application/json'
    And header Content-Type = 'application/json'
    And header client_id = '5ad84ff6-2ef9-402d-9cba-d12bfcb41faa'
    And request '{"lastFourDigitsCardNumber": "8653","citiCardHolderPhoneNumber": "1111111111","merchantCustomerReferenceId":"6300804530034"}'
    When method POST
    Then status 400
    And match response.type == 'invalid'
    And match response.code == 'invalidRequest'
    And match response.details == 'Missing or invalid parameters'

  Scenario: Verify the LinkageAPI with invalid merchantCustomerReferenceId in body parameters
    Given url 'https://sandbox.apihub.citi.com/gcb/api'
    And path '/v1/apac/rewards/linkage'
    And header Authorization = Auth
    And header Accept = 'application/json'
    And header Content-Type = 'application/json'
    And header client_id = '5ad84ff6-2ef9-402d-9cba-d12bfcb41faa'
    And request '{"lastFourDigitsCardNumber": "8653","citiCardHolderPhoneNumber": "6590020056","merchantCustomerReferenceId":"!@#$%^&*()_+"}'
    When method POST
    Then status 400
    And match response.type == 'invalid'
    And match response.code == 'invalidRequest'
    And match response.details == 'Missing or invalid parameters'

  Scenario: Verify the LinkageAPI with invalid Authorization credentials in the request

    Given url 'https://sandbox.apihub.citi.com/gcb/api'
    And path '/v1/apac/rewards/linkage'
    And header Authorization = 'Bearer 123456'
    And header Accept = 'application/json'
    And header Content-Type = 'application/json'
    And header client_id = '5ad84ff6-2ef9-402d-9cba-d12bfcb41faa'
    And request '{"lastFourDigitsCardNumber": "8653","citiCardHolderPhoneNumber": "6590020056","merchantCustomerReferenceId":"6300804530034"}'
    When method POST
    Then status 401
    And match response.type == 'unAuthorized'
    And match response.code == '401'
    And match response.details == 'Authorization credentials are missing or invalid'

    
    Scenario: Verify the LinkageAPI with invalid Authorization credentials in the request

    Given url 'https://sandbox.apihub.citi.com/gcb/api'
    And path '/v1/apac/rewards/linkage'
    And header Authorization = Auth
    And header Accept = 'application/json'
    And header Content-Type = 'application/json'
    And header client_id = 'abcd'
    And request '{"lastFourDigitsCardNumber": "8653","citiCardHolderPhoneNumber": "6590020056","merchantCustomerReferenceId":"6300804530034"}'
    When method POST
    Then status 401
    And match response.type == 'unAuthorized'
    And match response.code == '401'
    And match response.details == 'Authorization credentials are missing or invalid'
    