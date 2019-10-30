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
    redirect_uri VARCHAR(255),
    PRIMARY KEY (client_id),
    FOREIGN KEY (client_type) REFERENCES ClientType(client_type)
);

CREATE TABLE RefreshToken
(
    refresh_token VARCHAR(255) NOT NULL, 
    client_id VARCHAR(255) NOT NULL, 
    issued_at TIMESTAMP,
    expires_on TIMESTAMP,
    username VARCHAR(255),
    PRIMARY KEY (refresh_token),
    FOREIGN KEY (client_id) REFERENCES Client(client_id) ON DELETE CASCADE,
    FOREIGN KEY (username) REFERENCES User(username) ON DELETE CASCADE
);

CREATE TABLE AccessToken
(
    access_token VARCHAR(255) NOT NULL, 
    client_id VARCHAR(255) NOT NULL, 
    issued_at TIMESTAMP,
    expires_on TIMESTAMP,
    username VARCHAR(255),
    refresh_token VARCHAR(255), 
    PRIMARY KEY (access_token),
    FOREIGN KEY (client_id) REFERENCES Client(client_id) ON DELETE CASCADE,
    FOREIGN KEY (username) REFERENCES User(username) ON DELETE CASCADE,
    FOREIGN KEY (refresh_token) REFERENCES RefreshToken(refresh_token) ON DELETE CASCADE
);

CREATE TABLE AuthorizationCode
(
    code VARCHAR(255) NOT NULL, 
    client_id VARCHAR(255) NOT NULL,
    redirect_uri VARCHAR(255) NOT NULL,
    issued_at TIMESTAMP,
    expires_on TIMESTAMP,
    username VARCHAR(255),
    PRIMARY KEY (code),
    FOREIGN KEY (client_id) REFERENCES Client(client_id) ON DELETE CASCADE,
    FOREIGN KEY (username) REFERENCES User(username) ON DELETE CASCADE
);

CREATE TABLE SupportedGrantType
(
    client_id VARCHAR(255) NOT NULL, 
    grant_type VARCHAR(255) NOT NULL,
    PRIMARY KEY (client_id, grant_type),
    FOREIGN KEY (client_id) REFERENCES Client(client_id) ON DELETE CASCADE,
    FOREIGN KEY (grant_type) REFERENCES GrantType(grant_type)
);

CREATE TABLE ValidScope
(
    client_id VARCHAR(255) NOT NULL, 
    scope VARCHAR(255) NOT NULL,
    PRIMARY KEY (client_id, scope),
    FOREIGN KEY (client_id) REFERENCES Client(client_id) ON DELETE CASCADE,
    FOREIGN KEY (scope) REFERENCES Scope(scope) ON DELETE CASCADE
);

CREATE TABLE AuthorizedScope
(
    username VARCHAR(255) NOT NULL, 
    client_id VARCHAR(255) NOT NULL,
    scope VARCHAR(255) NOT NULL,
    PRIMARY KEY (username, client_id, scope),
    FOREIGN KEY (username) REFERENCES User(username) ON DELETE CASCADE,
    FOREIGN KEY (client_id) REFERENCES Client(client_id) ON DELETE CASCADE,
    FOREIGN KEY (scope) REFERENCES Scope(scope) ON DELETE CASCADE
);

INSERT INTO ClientType VALUES ("confidential"), ("public");
INSERT INTO GrantType VALUES ("password"), ("client_credentials"), ("authorization_code"), ("refresh_token");

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
    SELECT refresh_token, client_id, issued_at, expires_on, username
    FROM RefreshToken
    WHERE refresh_token = v_refresh_token;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE SaveRefreshToken(
    IN v_refresh_token VARCHAR(255), 
    IN v_client_id VARCHAR(255),
    IN v_issued_at TIMESTAMP,
    IN v_expires_on TIMESTAMP,
    IN v_username VARCHAR(255))
BEGIN
    INSERT INTO RefreshToken (refresh_token, client_id, issued_at, expires_on, username) 
    VALUE (v_refresh_token, v_client_id, v_issued_at, v_expires_on, v_username);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteRefreshToken(IN v_refresh_token VARCHAR(255))
BEGIN
    DELETE FROM RefreshToken WHERE refresh_token = v_refresh_token;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetAccessToken(IN v_access_token VARCHAR(255))
BEGIN
    SELECT access_token, client_id, issued_at, expires_on, username, refresh_token
    FROM AccessToken
    WHERE access_token = v_access_token;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE SaveAccessToken(
    IN v_access_token VARCHAR(255), 
    IN v_client_id VARCHAR(255), 
    IN v_issued_at TIMESTAMP, 
    IN v_expires_on TIMESTAMP, 
    IN v_username VARCHAR(255), 
    IN v_refresh_token VARCHAR(255))
BEGIN
    INSERT INTO AccessToken (access_token, client_id, issued_at, expires_on, username, refresh_token)
    VALUE (v_access_token, v_client_id, v_issued_at, v_expires_on, v_username, v_refresh_token);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteAccessToken(IN v_access_token VARCHAR(255))
BEGIN
    DELETE FROM AccessToken WHERE access_token = v_access_token;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetSupportedGrantTypes(IN v_client_id VARCHAR(255))
BEGIN
    SELECT grant_type FROM SupportedGrantType WHERE client_id = v_client_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetValidScopes(IN v_client_id VARCHAR(255))
BEGIN
    SELECT scope FROM ValidScope WHERE client_id = v_client_id;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE SaveAuthorizationCode(
    IN v_code VARCHAR(255), 
    IN v_client_id VARCHAR(255), 
    IN v_redirect_uri VARCHAR(255),
    IN v_issued_at TIMESTAMP, 
    IN v_expires_on TIMESTAMP, 
    IN v_username VARCHAR(255))
BEGIN
    INSERT INTO AuthorizationCode (code, client_id, redirect_uri, issued_at, expires_on, username)
    VALUE (v_code, v_client_id, v_redirect_uri, v_issued_at, v_expires_on, v_username);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE GetAuthorizationCode(IN v_code VARCHAR(255))
BEGIN
    SELECT code, client_id, redirect_uri, issued_at, expires_on, username
    FROM AuthorizationCode
    WHERE code = v_code;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteAuthorizationCode(IN v_code VARCHAR(255))
BEGIN
    DELETE FROM AuthorizationCode WHERE code = v_code;
END //
DELIMITER ;
