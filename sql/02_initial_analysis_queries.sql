-- Run after data has been loaded into smanalytics.
SET search_path TO smanalytics, public;

-- 1. Descriptive summary by dataset (uses only observed records).
SELECT dataset_code,
       COUNT(*) AS posts,
       COUNT(views) AS posts_with_views,
       COUNT(reach) AS posts_with_reach,
       COUNT(reported_interaction_rate) AS posts_with_reported_interaction_rate
FROM vw_content_performance
WHERE COALESCE(is_synthetic, FALSE) = FALSE
GROUP BY dataset_code
ORDER BY posts DESC;

-- 2. Hook comparison. Only use within a dataset/population where the fields
--    and measurement rules are comparable. Prefer medians to reduce outlier impact.
SELECT dataset_code, hook_type,
       COUNT(*) AS post_count,
       percentile_cont(0.5) WITHIN GROUP (ORDER BY views) AS median_views,
       AVG(views) AS mean_views,
       percentile_cont(0.5) WITHIN GROUP (ORDER BY comments) AS median_comments
FROM vw_content_performance
WHERE is_synthetic = FALSE AND hook_type IS NOT NULL
GROUP BY dataset_code, hook_type
HAVING COUNT(views) >= 5
ORDER BY dataset_code, median_views DESC;

-- 3. Media-type comparison where reach is available.
SELECT dataset_code, post_type,
       COUNT(*) AS post_count,
       AVG(engagement_rate_by_reach) AS avg_engagement_rate_by_reach,
       percentile_cont(0.5) WITHIN GROUP (ORDER BY engagement_rate_by_reach) AS median_engagement_rate_by_reach
FROM vw_content_performance
WHERE is_synthetic = FALSE AND reach > 0
GROUP BY dataset_code, post_type
ORDER BY dataset_code, median_engagement_rate_by_reach DESC;
