CREATE TABLE if not exists 
    users (
        `id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        `name` TEXT,
        `phone` TEXT,
        `email` TEXT,
        `user_name` TEXT, 
        `password` TEXT,
        `active` INTEGER
    );
    