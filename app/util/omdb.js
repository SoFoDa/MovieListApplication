"use strict";

module.exports.getMovieByTitle = (title) => {
    let reqTitle = encodeURIComponent(title.replace(" ", "+"));
    let url = `http://www.omdbapi.com/?apikey=${process.env.OMDB_KEY}&t=${reqTitle}`;
    return fetch(url, {
        json: true,
    }).then(res => res.json()
    ).then(data => { 
        return data;
    });
}