-- /// Activity procedure.
DELIMITER //
CREATE PROCEDURE getUserActivity
(IN user CHAR(30))
BEGIN
  SELECT * FROM User
  WHERE username = user;
END //
DELIMITER ;