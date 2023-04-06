DELIMITER //
CREATE PROCEDURE ComputeAverageWeightedScoreForUser(IN user_id INT)
BEGIN
    DECLARE total_score FLOAT;
    DECLARE total_weight INT;
    DECLARE weighted_score FLOAT;

    SELECT SUM(score * weight) INTO total_score, SUM(weight) INTO total_weight FROM corrections JOIN projects ON corrections.project_id = projects.id WHERE corrections.user_id = user_id;

    IF total_weight IS NULL OR total_weight = 0 THEN
        SET weighted_score = 0;
    ELSE
        SET weighted_score = total_score / total_weight;
    END IF;

    UPDATE users SET average_score = weighted_score WHERE id = user_id;
END //
DELIMITER ;
