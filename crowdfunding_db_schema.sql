CREATE TABLE contacts (
    contact_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    CONSTRAINT pk_contacts
	PRIMARY KEY (contact_id)
);



CREATE TABLE category (
    category_id VARCHAR(10) NOT NULL,
    category_name VARCHAR(50) NOT NULL,
    CONSTRAINT pk_category 
	PRIMARY KEY (category_id)
);

CREATE TABLE subcategory (
    subcategory_id VARCHAR(10) NOT NULL,
    subcategory_name VARCHAR(50) NOT NULL,
    CONSTRAINT pk_subcategory
	PRIMARY KEY (subcategory_id)
);

CREATE TABLE campaign (
    cf_id INT NOT NULL,
    contact_id INT NOT NULL,
    company_name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    goal NUMERIC(10,2) NOT NULL,
    pledged NUMERIC(10,2) NOT NULL,
    outcome VARCHAR(50) NOT NULL,
    backers_count INT NOT NULL,
    country VARCHAR(10) NOT NULL,
    currency VARCHAR(10) NOT NULL,
    launch_date DATE NOT NULL,
    end_date DATE NOT NULL,
    category_id VARCHAR(10) NOT NULL,
    subcategory_id VARCHAR(10) NOT NULL,
    CONSTRAINT pk_campaign 
	PRIMARY KEY (cf_id)
);

CREATE TABLE backers (
    backer_id VARCHAR(10) NOT NULL,
    cf_id INT NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    CONSTRAINT pk_backers 
	PRIMARY KEY (backer_id)
);

ALTER TABLE campaign ADD CONSTRAINT fk_campaign_contact_id FOREIGN KEY(contact_id)
REFERENCES contacts (contact_id);

ALTER TABLE campaign ADD CONSTRAINT fk_campaign_category_id FOREIGN KEY(category_id)
REFERENCES category (category_id);

ALTER TABLE campaign ADD CONSTRAINT fk_campaign_subcategory_id FOREIGN KEY(subcategory_id)
REFERENCES subcategory (subcategory_id);

ALTER TABLE backers ADD CONSTRAINT fk_backers_cf_id FOREIGN KEY(cf_id)
REFERENCES campaign (cf_id);

SELECT cpg.backers_count, cpg.cf_id, cpg.outcome
FROM campaign as cpg
WHERE (cpg.outcome = 'live')
ORDER BY cpg.backers_count DESC;

SELECT COUNT (bkr.cf_id), bkr.cf_id
FROM backers as bkr
GROUP BY bkr.cf_id
ORDER BY COUNT(bkr.cf_id) DESC;

SELECT con.first_name, con.last_name, con.email, (cpg.goal - cpg.pledged) as remaining_goal_amount 
INTO email_contacts_remaining_goal_amount
FROM campaign as cpg
INNER JOIN contacts as con
ON (cpg.contact_id = con.contact_id)
WHERE (cpg.outcome = 'live')
ORDER BY remaining_goal_amount DESC;

SELECT * FROM email_contacts_remaining_goal_amount;

SELECT bck.email, bck.first_name, bck.last_name, cpg.cf_id, cpg.company_name, cpg.description, (cpg.goal - cpg.pledged) as left_of_goal 
INTO email_backers_remaining_goal_amount
FROM campaign as cpg
INNER JOIN backers as bck
ON (cpg.cf_id = bck.cf_id)
WHERE (cpg.outcome = 'live')
ORDER BY bck.last_name, bck.email;

SELECT * FROM email_backers_remaining_goal_amount;