DELIMITER //

CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
    DECLARE total_weighted_score FLOAT;
    DECLARE total_weight FLOAT;
    DECLARE user_count INT;
    DECLARE project_weight INT;
    DECLARE user_id INT;
    DECLARE project_id INT;
    DECLARE project_score FLOAT;
    DECLARE weighted_score FLOAT;

    SELECT COUNT(*) FROM users INTO user_count;

    SET total_weighted_score = 0;
    SET total_weight = 0;

    /* Loop through all users */
    SET user_id = 1;
    WHILE user_id <= user_count DO
        /* Loop through all projects for this user */
        SET project_id = 1;
        WHILE project_id <= (SELECT COUNT(*) FROM projects) DO
            SELECT score INTO project_score FROM corrections WHERE user_id = user_id AND project_id = project_id;
            SELECT weight INTO project_weight FROM projects WHERE id = project_id;
            IF project_score IS NOT NULL THEN
                SET weighted_score = project_score * project_weight;
                SET total_weighted_score = total_weighted_score + weighted_score;
                SET total_weight = total_weight + project_weight;
            END IF;
            SET project_id = project_id + 1;
        END WHILE;
        /* Calculate and update average weighted score for this user */
        IF total_weight > 0 THEN
            UPDATE users SET average_score = total_weighted_score / total_weight WHERE id = user_id;
        END IF;
        SET user_id = user_id + 1;
        SET total_weighted_score = 0;
        SET total_weight = 0;
    END WHILE;

END //

DELIMITER ;
