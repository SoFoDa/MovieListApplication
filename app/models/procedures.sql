DROP PROCEDURE getUserActivity;
DROP PROCEDURE getSeenMovies;


DELIMITER //
CREATE PROCEDURE getUserActivity
(IN user CHAR(30))
BEGIN
  SELECT * FROM User
  WHERE username = user;
END //

CREATE PROCEDURE getSeenMovies
(IN id CHAR(30))
BEGIN
  SELECT
    title,
    runtime,
    genre,
    release_year,
    director,
    poster_path
  FROM
    Movie as m
    INNER JOIN Seen as s ON m.movie_id = s.movie_id
    INNER JOIN User as u ON u.user_id = s.user_id
  WHERE
    u.user_id = id;
END //
DELIMITER ;