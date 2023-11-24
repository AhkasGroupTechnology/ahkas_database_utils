CREATE TABLE if not exists 
    customers (
        `id` INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, 
        `name` TEXT,
        `phone` TEXT,
        `gender` TEXT,
        `address` TEXT,
        `type` TEXT,
        `active` INTEGER
    );