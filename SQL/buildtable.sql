

CREATE TABLE IF NOT EXISTS nwn.spellslearned
(uuid INTEGER NOT NULL), 
(spellid INTEGER NOT NULL), 
(classid INTEGER NOT NULL), 
(spelllevel INTEGER NOT NULL) 
PRIMARY KEY (uuid, spellid);

