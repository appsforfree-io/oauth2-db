CREATE DATABASE oauth2db;

USE oauth2db;

CREATE TABLE GrantType
(
    grantType VARCHAR(255),
    PRIMARY KEY (grantType)
);

CREATE TABLE Scope
(
    scope VARCHAR(255),
    PRIMARY KEY (scope)
);

CREATE TABLE ClientType
(
    clientType VARCHAR(255),
    PRIMARY KEY (clientType)
);

CREATE TABLE User
(
    username VARCHAR(255), 
    password VARCHAR(255),
    PRIMARY KEY (username)
);

CREATE TABLE Client
(
    clientId VARCHAR(255),
    clientSecret VARCHAR(255),
    PRIMARY KEY (clientId)
);

CREATE TABLE RefreshToken
(
    refreshToken VARCHAR(255), 
    clientId VARCHAR(255), 
    username VARCHAR(255),
    PRIMARY KEY (refreshToken)
);

CREATE TABLE AccessToken
(
    accessToken VARCHAR(255), 
    refreshToken VARCHAR(255), 
    clientId VARCHAR(255), 
    username VARCHAR(255),
    PRIMARY KEY (accessToken)
);

CREATE TABLE AvailableGrantType
(
    clientId VARCHAR(255), 
    grantType VARCHAR(255),
    PRIMARY KEY (clientId, grantType)
);

CREATE TABLE AvailableScope
(
    clientId VARCHAR(255), 
    scope VARCHAR(255),
    PRIMARY KEY (clientId, scope)
);

CREATE TABLE AuthorizedScope
(
    accessToken VARCHAR(255), 
    scope VARCHAR(255),
    PRIMARY KEY (accessToken, scope)
);

INSERT INTO ClientType VALUES ("confidential"), ("public");
INSERT INTO GrantType VALUES ("password");
