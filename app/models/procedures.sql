DROP PROCEDURE getUserActivity;
DROP PROCEDURE getSeenMovies;
DROP PROCEDURE getDirectors;
DROP PROCEDURE getGenres;
DROP PROCEDURE getUserInfo;
DROP PROCEDURE getFollowerAmount;
DROP PROCEDURE getSummedRuntime;
DROP PROCEDURE getMostWatchedGenre;
DROP PROCEDURE getMostWatchedDirector;
DROP PROCEDURE isSeen;
DROP PROCEDURE getSeenFollowed;
DROP PROCEDURE deleteMovieActivity;
DROP PROCEDURE deleteFriendActivity;

DELIMITER //
CREATE PROCEDURE getUserActivity
(IN user CHAR(30))
BEGIN
  SELECT
    fusr.username,
    ac.date,
    acfu.username as friend_username,
    fusr.user_id as tuser_id,
    acfu.user_id as friend_id,
    acm.type,
    mov.movie_id,
    mov.title,
    mov.release_year,
    mov.poster_path
  FROM
    User as usr
    JOIN User_friend as usf ON usf.user_id = usr.user_id
    JOIN Activity as ac ON ac.user_id = usf.friend_id
    LEFT JOIN Activity_friend as acf ON ac.activity_id = acf.activity_id
    LEFT JOIN User as acfu ON acfu.user_id = acf.friend_id 
    LEFT JOIN Activity_movie as acm ON ac.activity_id = acm.activity_id
    LEFT JOIN Movie as mov ON acm.movie_id = mov.movie_id
    JOIN User as fusr ON fusr.user_id = usf.friend_id
  WHERE
    usr.user_id = user
  ORDER BY
    ac.date DESC
  LIMIT
    25;
END //

CREATE PROCEDURE getSeenMovies
(IN id CHAR(30))
BEGIN
  SELECT
    m.movie_id,
    title,
    runtime,    
    release_year,    
    poster_path    
  FROM
    Movie as m
    JOIN Seen as s ON m.movie_id = s.movie_id
    JOIN User as u ON u.user_id = s.user_id    
  WHERE
    u.user_id = id 
  ORDER BY
    m.title;
END //

CREATE PROCEDURE getDirectors
(IN id CHAR(30))
BEGIN
  SELECT
  name
  FROM
    Director as d
    JOIN Movie_director as md ON d.director_id = md.director_id
    JOIN Movie as m ON m.movie_id = md.movie_id
  WHERE
    md.movie_id = id;
END //

CREATE PROCEDURE getGenres
(IN id CHAR(30))
BEGIN
  SELECT
  genre_type
  FROM
    Genre as g
    JOIN Movie_genre as mg ON g.genre_id = mg.genre_id
    JOIN Movie as m ON m.movie_id = mg.movie_id
  WHERE
    mg.movie_id = id;
END //

CREATE PROCEDURE getUserInfo
(IN id CHAR(30))
BEGIN
  SELECT
    id,
    usr.username,
    uinf.name,
    uinf.created as join_date
  FROM
    User as usr   
    Join User_info as uinf on usr.user_id = uinf.user_id  
  WHERE
    usr.user_id = id;  
END //

CREATE PROCEDURE getFollowerAmount
(IN id CHAR(30))
BEGIN
  SELECT  
    COUNT(*) as follower_amount
  FROM    
    User_friend as ufri
  WHERE
    ufri.friend_id = id;  
END //

CREATE PROCEDURE getMostWatchedDirector
(IN id CHAR(30))
BEGIN
  SELECT
    name,
    COUNT(name) as count
  FROM
    User as u
    JOIN Seen as s ON u.user_id = s.user_id
    JOIN Movie as m ON m.movie_id = s.movie_id
    JOIN Movie_director as mv ON mv.movie_id = m.movie_id
    JOIN Director as d ON d.director_id = mv.director_id
  WHERE
    u.user_id = id
  GROUP BY
    name
  ORDER BY
    COUNT(name) DESC
  LIMIT
    1;
END //

CREATE PROCEDURE getMostWatchedGenre
(IN id CHAR(30))
BEGIN
  SELECT
    genre_type,
    COUNT(genre_type) as count
  FROM
    User as u
    JOIN Seen as s ON u.user_id = s.user_id
    JOIN Movie as m ON m.movie_id = s.movie_id
    JOIN Movie_genre as mv ON mv.movie_id = m.movie_id
    JOIN Genre as g ON g.genre_id = mv.genre_id
  WHERE
    u.user_id = id
  GROUP BY
    genre_type
  ORDER BY
    COUNT(genre_type) DESC
  LIMIT
    1;
END //

CREATE PROCEDURE getSummedRuntime
(IN id CHAR(30))
BEGIN
  SELECT
    SUM(m.runtime)
  FROM
    Movie as m
    JOIN Seen as s ON m.movie_id = s.movie_id
    JOIN User as u ON s.user_id = u.user_id
  WHERE
    u.user_id = id;
END //

CREATE PROCEDURE isSeen
(IN u_id CHAR(30), IN m_id CHAR(30))
BEGIN
  SELECT  
    COUNT(*) as is_seen
  FROM    
    Seen as s
  WHERE
    s.user_id = u_id
    AND s.movie_id = m_id;  
END //

CREATE PROCEDURE getSeenFollowed
(IN u_id CHAR(30), IN m_id CHAR(30))
BEGIN
  SELECT  
    u2.username,
    s.date
  FROM    
    User as u
    JOIN User_friend as uf ON u.user_id = uf.user_id
    JOIN User as u2 ON uf.friend_id = u2.user_id
    JOIN Seen as s ON uf.friend_id = s.user_id
  WHERE
    u.user_id = u_id
    AND s.movie_id = m_id;  
END //

CREATE PROCEDURE deleteMovieActivity
(IN u_id CHAR(30), IN m_id CHAR(30))
BEGIN
  SET @activity_id = (SELECT
        a.activity_id
      FROM
        Activity as a
        JOIN (SELECT * FROM Activity_movie) as acm ON acm.activity_id = a.activity_id
      WHERE
        a.user_id = u_id
        AND acm.movie_id = m_id
    );
  DELETE FROM
    Activity_movie
  WHERE
    activity_id = @activity_id;

  DELETE FROM
    Activity
  WHERE
    activity_id = @activity_id;
END //


CREATE PROCEDURE deleteFriendActivity
(IN u_id CHAR(30), IN f_id CHAR(30))
BEGIN
  SET @activity_id = (SELECT
        a.activity_id
      FROM
        Activity as a
        JOIN (SELECT * FROM Activity_friend) as acf ON acf.activity_id = a.activity_id
      WHERE
        a.user_id = u_id
        AND acf.friend_id = f_id
    );
  DELETE FROM
    Activity_friend
  WHERE
    activity_id = @activity_id;

  DELETE FROM
    Activity
  WHERE
    activity_id = @activity_id;
END //

DELIMITER ;