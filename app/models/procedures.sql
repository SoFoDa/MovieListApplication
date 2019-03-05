DROP PROCEDURE getUserActivity;
DROP PROCEDURE getSeenMovies;


DELIMITER //
CREATE PROCEDURE getUserActivity
(IN user CHAR(30))
BEGIN
  SELECT
    date,
    friend_id,
    movie_id,
    type
  FROM
    Activity as ac
    LEFT JOIN Activity_friend as acf ON ac.activity_id = acf.activity_id
    LEFT JOIN Activity_movie acm ON ac.activity_id = acm.activity_id
    INNER JOIN User as u ON ac.user_id = u.user_id
  WHERE
    u.user_id = user;
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