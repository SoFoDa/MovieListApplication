"use strict";

module.exports.getMovieByTitle = async (title) => {
    let reqTitle = encodeURIComponent(title.replace(" ", "+"));
    let url = `http://www.omdbapi.com/?apikey=${process.env.OMDB_KEY}&t=${reqTitle}`;
    return fetch(url, {
        json: true,
    }).then(res => res.json()
    ).then(movie => { 
        if (movie.Type == "movie") {
            let entry = {
                title: movie.Title, 
                runtime: parseInt(movie.Runtime.split(" ")[0]),
                genres: [],
                release_year: parseInt(movie.Year), 
                directors: [],
                poster_path: '',
            };
            entry['genres'] = movie.Genre.split(",").map(genre => {
                if(genre.startsWith(" ")) {
                    return genre.slice(1);
                }
                return genre;
            });
            entry['directors'] = movie.Director.split(",").map(director => {
                if(director.startsWith(" ")) {
                    return director.slice(1);
                }
                return director;
            });;
            return entry;
        }
        return null;
    });
}