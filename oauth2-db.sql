CREATE DATABASE oauth2db;

USE oauth2db;

CREATE TABLE GrantType
(
    grant_type VARCHAR(255) NOT NULL,
    PRIMARY KEY (grant_type)
);

CREATE TABLE Scope
(
    scope VARCHAR(255) NOT NULL,
    PRIMARY KEY (scope)
);

CREATE TABLE ClientType
(
    client_type VARCHAR(255) NOT NULL,
    PRIMARY KEY (client_type)
);

CREATE TABLE User
(
    username VARCHAR(255) NOT NULL, 
    password VARCHAR(255) NOT NULL,
    PRIMARY KEY (username)
);

CREATE TABLE Client
(
    client_id VARCHAR(255) NOT NULL,
    client_secret VARCHAR(255) NOT NULL,
    client_type VARCHAR(255) NOT NULL,
    PRIMARY KEY (client_id),
    FOREIGN KEY (client_type) REFERENCES ClientType(client_type)
);

CREATE TABLE RefreshToken
(
    refresh_token VARCHAR(255) NOT NULL, 
    client_id VARCHAR(255) NOT NULL, 
    username VARCHAR(255) NOT NULL,
    PRIMARY KEY (refresh_token),
    FOREIGN KEY (client_id) REFERENCES Client(client_id),
    FOREIGN KEY (username) REFERENCES User(username)
);

CREATE TABLE AccessToken
(
    access_token VARCHAR(255) NOT NULL, 
    client_id VARCHAR(255) NOT NULL, 
    username VARCHAR(255) NOT NULL,
    refresh_token VARCHAR(255), 
    PRIMARY KEY (access_token),
    FOREIGN KEY (client_id) REFERENCES Client(client_id),
    FOREIGN KEY (username) REFERENCES User(username),
    FOREIGN KEY (refresh_token) REFERENCES RefreshToken(refresh_token)
);

CREATE TABLE AvailableGrantType
(
    client_id VARCHAR(255) NOT NULL, 
    grant_type VARCHAR(255) NOT NULL,
    PRIMARY KEY (client_id, grant_type),
    FOREIGN KEY (client_id) REFERENCES Client(client_id),
    FOREIGN KEY (grant_type) REFERENCES GrantType(grant_type)
);

CREATE TABLE AvailableScope
(
    client_id VARCHAR(255) NOT NULL, 
    scope VARCHAR(255) NOT NULL,
    PRIMARY KEY (client_id, scope),
    FOREIGN KEY (client_id) REFERENCES Client(client_id),
    FOREIGN KEY (scope) REFERENCES Scope(scope)
);

CREATE TABLE AuthorizedScope
(
    access_token VARCHAR(255) NOT NULL, 
    scope VARCHAR(255) NOT NULL,
    PRIMARY KEY (access_token, scope),
    FOREIGN KEY (access_token) REFERENCES AccessToken(access_token),
    FOREIGN KEY (scope) REFERENCES Scope(scope)
);

INSERT INTO ClientType VALUES ("confidential"), ("public");
INSERT INTO GrantType VALUES ("password");
