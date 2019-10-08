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

DELIMITER //
CREATE PROCEDURE SaveClient(
    IN v_client_id VARCHAR(255),
    IN v_client_secret VARCHAR(255),
    IN v_client_type VARCHAR(255))
BEGIN
    INSERT INTO Client (client_id, client_secret, client_type) 
    VALUE (v_client_id, v_client_secret, v_client_type);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetClient(IN v_client_id VARCHAR(255))
BEGIN
    SELECT client_id, client_secret, client_type
    FROM Client
    WHERE client_id = v_client_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE RemoveClient(IN v_client_id VARCHAR(255))
BEGIN
    DELETE FROM Client
    WHERE client_id = v_client_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetUser(IN v_username VARCHAR(255))
BEGIN
    SELECT username, password
    FROM User
    WHERE username = v_username;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE SaveUser(
    IN v_username VARCHAR(255), 
    IN v_password VARCHAR(255))
BEGIN
    INSERT INTO User (username, password) 
    VALUE (v_username, v_password);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteUser(IN v_username VARCHAR(255))
BEGIN
    DELETE FROM User WHERE username = v_username;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetRefreshToken(IN v_refresh_token VARCHAR(255))
BEGIN
    SELECT refresh_token, client_id, username
    FROM RefreshToken
    WHERE refresh_token = v_refresh_token;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE SaveRefreshToken(
    IN v_refresh_token VARCHAR(255), 
    IN v_client_id VARCHAR(255),
    IN v_username VARCHAR(255))
BEGIN
    INSERT INTO RefreshToken (refresh_token, client_id, username) 
    VALUE (v_refresh_token, v_client_id, v_username);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteRefreshToken(IN v_refresh_token VARCHAR(255))
BEGIN
    DELETE FROM RefreshToken WHERE refresh_token = v_refresh_token;
END //
DELIMITER ;
