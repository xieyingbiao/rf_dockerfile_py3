*** Settings ***
Library           MongoDBLibrary

*** Variables ***
${MDBHost}        localhost
${MDBPort}        ${52010}

*** Test Cases ***
Connect-Disconnect
    [Tags]    regression
    Comment    Connect to MongoDB Server
    Connect To MongoDB    ${MDBHost}    ${MDBPort}
    Comment    Disconnect from MongoDB Server
    Disconnect From MongoDB

Get MongoDB Databases
    [Tags]    regression
    Comment
    Connect To MongoDB    ${MDBHost}    ${MDBPort}
    Comment    Retrieve a list of databases on the MongoDB server
    @{output} =    Get MongoDB Databases
    Log Many    @{output}
    Comment    Verify the order in which the databases are returned by checking specific elements of return for exact db name
    Should Contain    @{output}[0]    test
    Should Contain    @{output}[1]    admin
    Should Contain    @{output}[2]    local
    Comment    Verify that db name is contained in the list output
    Should Contain    ${output}    admin
    Should Contain    ${output}    local
    Should Contain    ${output}    test
    Comment    Log as a list
    Log    ${output}
    Comment    Disconnect from MongoDB Server
    Disconnect From MongoDB

Save MongoDB Records
    [Tags]    regression
    ${MDBDB} =    Set Variable    foo
    ${MDBColl} =    Set Variable    foo
    Comment    Connect to MongoDB Server
    Connect To MongoDB    ${MDBHost}    ${MDBPort}
    Comment    Get current record count in collection to ensure that count increases correctly
    ${CurCount} =    Get MongoDB Collection Count    ${MDBDB}    ${MDBColl}
    ${output} =    Save MongoDB Records    ${MDBDB}    ${MDBColl}    {"timestamp":1, "msg":"Hello 1"}
    Log    ${output}
    Set Suite Variable    ${recordno1}    ${output}
    ${output} =    Save MongoDB Records    ${MDBDB}    ${MDBColl}    {"timestamp":2, "msg":"Hello 2"}
    Log    ${output}
    Set Suite Variable    ${recordno2}    ${output}
    ${output} =    Save MongoDB Records    ${MDBDB}    ${MDBColl}    {"timestamp":3, "msg":"Hello 3"}
    Log    ${output}
    Set Suite Variable    ${recordno3}    ${output}
    Comment    Verify that the record count increased by the number of records saved above (3)
    ${output} =    Get MongoDB Collection Count    ${MDBDB}    ${MDBColl}
    Should Be Equal    ${output}    ${${CurCount} + 3}
    Disconnect From MongoDB

Update An Existing MongoDB Record
    [Tags]    regression
    ${MDBDB} =    Set Variable    foo
    ${MDBColl} =    Set Variable    foo
    Comment    Connect to MongoDB Server
    Connect To MongoDB    ${MDBHost}    ${MDBPort}
    Comment    Get current record count in collection to ensure that count increases correctly
    ${CurCount} =    Get MongoDB Collection Count    ${MDBDB}    ${MDBColl}
    ${output} =    Save MongoDB Records    ${MDBDB}    ${MDBColl}    {"timestamp":1, "msg":"Hello 1"}
    Log    ${output}
    Set Suite Variable    ${recordno1}    ${output}
    ${output} =    Save MongoDB Records    ${MDBDB}    ${MDBColl}    {"timestamp":2, "msg":"Hello 2"}
    Log    ${output}
    Set Suite Variable    ${recordno2}    ${output}
    ${output} =    Save MongoDB Records    ${MDBDB}    ${MDBColl}    {"timestamp":3, "msg":"Hello 3"}
    Log    ${output}
    Set Suite Variable    ${recordno3}    ${output}
    Comment    Verify that the record count increased by the number of records saved above (3)
    ${output} =    Get MongoDB Collection Count    ${MDBDB}    ${MDBColl}
    Should Be Equal    ${output}    ${${CurCount} + 3}
    Disconnect From MongoDB

Get MongoDB Collections
    [Tags]    regression
    Comment    Connect to MongoDB Server
    Connect To MongoDB    ${MDBHost}    ${MDBPort}
    @{output}    Get MongoDB Collections    foo
    Comment    Log as an array the returned list of collections
    Log Many    @{output}
    Comment    Log as a list the returned list of collections
    Log    ${output}
    Comment    Verify that known collection names are in the list returned
    Should Contain    ${output}    foo
    Should Contain    ${output}    system.indexes
    Comment    Disconnect from MongoDB Server
    Disconnect From MongoDB

Validate MongoDB Collection
    [Tags]    regression
    ${MDBDB} =    Set Variable    foo
    Comment    Connect to MongoDB Server
    Connect To MongoDB    ${MDBHost}    ${MDBPort}
    ${MDBColl} =    Set Variable    foo
    Comment    Validate a Collection
    ${allResults} =    Validate MongoDB Collection    ${MDBDB}    ${MDBColl}
    Log    ${allResults}
    ${MDBColl} =    Set Variable    system.indexes
    Comment    Validate a Collection
    ${allResults} =    Validate MongoDB Collection    ${MDBDB}    ${MDBColl}
    Log    ${allResults}
    Comment    Disconnect from MongoDB Server
    Disconnect From MongoDB

Get MongoDB Collection Count
    [Tags]    regression
    Comment    Connect to MongoDB Server
    Connect To MongoDB    ${MDBHost}    ${MDBPort}
    ${output}    Get MongoDB Collection Count    foo    foo
    Should Be Equal As Strings    ${output}    6
    Comment    Should Not Be Equal As Strings    ${output}    0
    Comment    Disconnect from MongoDB Server
    Disconnect From MongoDB

Retrieve All MongoDB Records
    [Tags]    regression
    ${myVar} =    Set Variable    Blah, Foo, Bar, 4da8713952dfbd08ce000000
    Comment    Connect to MongoDB Server
    Connect To MongoDB    ${MDBHost}    ${MDBPort}
    ${output}    Retrieve All MongoDB Records    foo    foo
    Log    ${output}
    Log    ${recordNo1}
    Log    ${recordNo2}
    Log    ${recordNo3}
    Should Contain X Times    ${output}    '${recordNo1}'    1
    Should Contain X Times    ${output}    '${recordNo2}'    1
    Should Contain X Times    ${output}    '${recordNo3}'    1
    Disconnect From MongoDB

Retrieve Some MongoDB Records
    [Tags]    regression
    Comment    Connect to MongoDB Server
    Connect To MongoDB    ${MDBHost}    ${MDBPort}
    ${output}    Retrieve Some MongoDB Records    foo    foo    {"timestamp": {"$gte" : 2}}
    Log    ${output}
    Should Not Contain    ${output}    '${recordNo1}'    1
    Should Contain X Times    ${output}    '${recordNo2}'    1
    Should Contain X Times    ${output}    '${recordNo3}'    1
    Disconnect From MongoDB

Remove MongoDB Records By id
    [Tags]    regression
    ${MDBDB} =    Set Variable    foo
    ${MDBColl} =    Set Variable    foo
    Comment    Connect to MongoDB Server
    Connect To MongoDB    ${MDBHost}    ${MDBPort}
    Comment    Verify that the record we want to remove exists.
    ${output}    Retrieve All MongoDB Records    ${MDBDB}    ${MDBColl}
    Log    ${output}
    Should Contain    ${output}    '${recordNo2}'
    Comment    Remove the record from MongoDB
    ${output}    Remove MongoDB Records    ${MDBDB}    ${MDBColl}    {"_id": "${recordNo2}"}
    Log    ${output}
    Comment    Verify that the record was removed from the database.
    ${output}    Retrieve All MongoDB Records    ${MDBDB}    ${MDBColl}
    Log    ${output}
    Should Not Contain    ${output}    '${recordNo2}'
    Comment    Disconnect from MongoDB Server
    Disconnect From MongoDB

Remove MongoDB Records
    [Tags]    regression
    ${MDBDB} =    Set Variable    foo
    ${MDBColl} =    Set Variable    foo
    Comment    Connect to MongoDB Server
    Connect To MongoDB    ${MDBHost}    ${MDBPort}
    Comment    Verify that the record we want to remove exists.
    ${output}    Retrieve All MongoDB Records    ${MDBDB}    ${MDBColl}
    Log    ${output}
    Should Contain    ${output}    'timestamp', 1
    Comment    Remove the record from MongoDB
    ${output}    Remove MongoDB Records    ${MDBDB}    ${MDBColl}    {"timestamp": {"$lt": 2}}
    Log    ${output}
    Comment    Verify that the record was removed from the database.
    ${output}    Retrieve All MongoDB Records    ${MDBDB}    ${MDBColl}
    Log    ${output}
    Should Not Contain    ${output}    'timestamp', 1
    Comment    Disconnect from MongoDB Server
    Disconnect From MongoDB

Drop MongoDB Collection
    [Tags]    regression
    Comment    Connect to MongoDB Server
    Connect To MongoDB    ${MDBHost}    ${MDBPort}
    Drop MongoDB Collection    FooBar    OhYeah
    @{output}    Get MongoDB Collections    FooBar
    Log Many    @{output}
    Should Not Contain    ${output}    OhYeah
    Comment    Disconnect from MongoDB Server
    Disconnect From MongoDB

Drop MongoDB Database
    [Tags]    regression
    Comment    Connect to MongoDB Server
    Connect To MongoDB    ${MDBHost}    ${MDBPort}
    Comment    Drop a Database if it exists
    Drop MongoDB Database    FooBar
    Comment    Get a list of databases on MongoDB Server and verify that database was dropped
    @{output} =    Get MongoDB Databases
    Should Not Contain    ${output}    FooBar
    Comment    Disconnect from MongoDB Server
    Disconnect From MongoDB

Test Suite Cleanup
    [Tags]    regression
    Comment    Connect to MongoDB Server
    Connect To MongoDB    ${MDBHost}    ${MDBPort}
    Comment    Drop a Database if it exists
    Drop MongoDB Database    foo
    Comment    Get a list of databases on MongoDB Server and verify that database was dropped
    @{output} =    Get MongoDB Databases
    Should Not Contain    ${output}    foo
    Comment    Disconnect from MongoDB Server
    Disconnect From MongoDB

Retrieve Mongodb Records With Desired Fields
    [Tags]    regression
    Comment    Connect to MongoDB Server
    Connect To MongoDB    ${MDBHost}    ${MDBPort}
    Comment    Set test data
    ${MDBDB} =    Set Variable    users
    ${MDBColl} =    Set Variable    account
    ${output} =    Save MongoDB Records    ${MDBDB}    ${MDBColl}    {"firstName": "Clark", "lastName": "Kent", "address": {"streetAddress": "21 2nd Street", "city": "Metropolis"}}
    Comment    Retrieve Mongodb Records With Desired Fields
    ${fields} =    Retrieve Mongodb Records With Desired Fields    ${MDBDB}    ${MDBColl}    {}    address.city    ${false}
    Log    ${fields}
    Should Contain    ${fields}    city
    Should Contain    ${fields}    Metropolis
