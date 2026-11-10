-- Social Media Performance Analytics & Recommendation System
-- PostgreSQL schema v1.0
-- Preserve source-specific raw imports separately; these tables are the normalized analytical layer.

CREATE SCHEMA IF NOT EXISTS smanalytics;
SET search_path TO smanalytics, public;

CREATE TABLE IF NOT EXISTS dataset_sources (
    dataset_id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    dataset_code        VARCHAR(40) NOT NULL UNIQUE,
    dataset_name        TEXT NOT NULL,
    provider            TEXT NOT NULL,
    source_url          TEXT NOT NULL,
    record_count_claimed INTEGER,
    publication_date    DATE,
    licence_status      TEXT,
    provenance_status   VARCHAR(30) NOT NULL CHECK
        (provenance_status IN ('RESEARCH_CURATED','REPOSITORY_DESCRIBED','LIMITED_PROVENANCE','UNVERIFIED')),
    intended_use        TEXT NOT NULL,
    limitations         TEXT
);

CREATE TABLE IF NOT EXISTS source_accounts (
    account_id          BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    dataset_id          BIGINT NOT NULL REFERENCES dataset_sources(dataset_id),
    source_account_key  TEXT NOT NULL,
    account_label       TEXT,
    account_category    TEXT,
    industry            TEXT,
    CONSTRAINT uq_source_account UNIQUE (dataset_id, source_account_key)
);

CREATE TABLE IF NOT EXISTS content_posts (
    post_id                 BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    dataset_id              BIGINT NOT NULL REFERENCES dataset_sources(dataset_id),
    source_record_id        TEXT NOT NULL,
    account_id              BIGINT REFERENCES source_accounts(account_id),
    platform                VARCHAR(30) NOT NULL DEFAULT 'Instagram',
    published_at            TIMESTAMP,
    post_type               VARCHAR(40),
    caption                 TEXT,
    permalink               TEXT,
    source_content_category TEXT,
    video_duration_seconds  NUMERIC(10,2),
    source_row_number       INTEGER,
    CONSTRAINT uq_dataset_source_record UNIQUE (dataset_id, source_record_id),
    CONSTRAINT chk_video_duration CHECK (video_duration_seconds IS NULL OR video_duration_seconds >= 0)
);

CREATE TABLE IF NOT EXISTS content_metrics (
    metric_id               BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    post_id                 BIGINT NOT NULL REFERENCES content_posts(post_id) ON DELETE CASCADE,
    observed_at             TIMESTAMP,
    observation_type        VARCHAR(30) NOT NULL DEFAULT 'UNKNOWN'
        CHECK (observation_type IN ('POINT_IN_TIME','LIFETIME_SNAPSHOT','PERIODIC','UNKNOWN')),
    views                   BIGINT,
    impressions             BIGINT,
    reach                   BIGINT,
    likes                   BIGINT,
    comments                BIGINT,
    shares                  BIGINT,
    saves                   BIGINT,
    profile_visits          BIGINT,
    follows                 BIGINT,
    reported_interaction_rate NUMERIC(12,6),
    metric_notes            TEXT,
    is_synthetic            BOOLEAN NOT NULL DEFAULT FALSE,
    CONSTRAINT uq_post_observation UNIQUE (post_id, observed_at),
    CONSTRAINT chk_nonnegative_metrics CHECK (
        (views IS NULL OR views >= 0) AND (impressions IS NULL OR impressions >= 0) AND
        (reach IS NULL OR reach >= 0) AND (likes IS NULL OR likes >= 0) AND
        (comments IS NULL OR comments >= 0) AND (shares IS NULL OR shares >= 0) AND
        (saves IS NULL OR saves >= 0) AND (profile_visits IS NULL OR profile_visits >= 0) AND
        (follows IS NULL OR follows >= 0)
    )
);

CREATE TABLE IF NOT EXISTS content_annotations (
    annotation_id           BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    post_id                 BIGINT NOT NULL REFERENCES content_posts(post_id) ON DELETE CASCADE,
    annotation_version      VARCHAR(20) NOT NULL DEFAULT 'v1',
    annotation_method       VARCHAR(30) NOT NULL
        CHECK (annotation_method IN ('SOURCE_CODED','MANUAL_PROJECT','AI_ASSISTED_REVIEWED','SYNTHETIC')),
    annotator               TEXT,
    hook_type               VARCHAR(50),
    hook_text               TEXT,
    hook_duration_seconds   NUMERIC(8,2),
    cta_type                VARCHAR(50),
    has_comment_prompt      BOOLEAN,
    content_pillar          VARCHAR(60),
    content_subtype         VARCHAR(60),
    has_subtitles           BOOLEAN,
    editing_pace            VARCHAR(40),
    information_density     SMALLINT CHECK (information_density BETWEEN 1 AND 5),
    visual_support          SMALLINT CHECK (visual_support BETWEEN 1 AND 5),
    education_value         SMALLINT CHECK (education_value BETWEEN 1 AND 5),
    attention_retention_potential SMALLINT CHECK (attention_retention_potential BETWEEN 1 AND 5),
    execution_quality       SMALLINT CHECK (execution_quality BETWEEN 1 AND 5),
    voiceover               BOOLEAN,
    face_shown              BOOLEAN,
    product_shown_first_3s  BOOLEAN,
    text_overlay            BOOLEAN,
    storytelling             BOOLEAN,
    educational              BOOLEAN,
    entertainment            BOOLEAN,
    product_demo             BOOLEAN,
    ugc                      BOOLEAN,
    annotation_notes         TEXT,
    created_at               TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uq_post_annotation_version UNIQUE (post_id, annotation_version)
);

CREATE TABLE IF NOT EXISTS cross_platform_pairs (
    pair_id                 BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    dataset_id              BIGINT NOT NULL REFERENCES dataset_sources(dataset_id),
    source_pair_key         TEXT NOT NULL,
    instagram_post_id       BIGINT REFERENCES content_posts(post_id),
    facebook_post_id        BIGINT REFERENCES content_posts(post_id),
    row_index_difference    NUMERIC(12,4),
    interaction_difference  NUMERIC(12,6),
    notes                   TEXT,
    CONSTRAINT uq_dataset_pair UNIQUE (dataset_id, source_pair_key)
);

CREATE TABLE IF NOT EXISTS data_quality_issues (
    issue_id                BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    dataset_id              BIGINT NOT NULL REFERENCES dataset_sources(dataset_id),
    source_record_id        TEXT,
    field_name              TEXT,
    issue_type              VARCHAR(50) NOT NULL,
    severity                VARCHAR(20) NOT NULL CHECK (severity IN ('INFO','WARNING','ERROR')),
    issue_description       TEXT NOT NULL,
    resolution_status       VARCHAR(20) NOT NULL DEFAULT 'OPEN'
        CHECK (resolution_status IN ('OPEN','RESOLVED','ACCEPTED')),
    logged_at               TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_posts_dataset ON content_posts(dataset_id);
CREATE INDEX IF NOT EXISTS idx_posts_published_at ON content_posts(published_at);
CREATE INDEX IF NOT EXISTS idx_metrics_post_id ON content_metrics(post_id);
CREATE INDEX IF NOT EXISTS idx_annotations_hook ON content_annotations(hook_type);
CREATE INDEX IF NOT EXISTS idx_annotations_pillar ON content_annotations(content_pillar);

-- Derived metrics view. Rates are NULL where the required denominator is unavailable.
CREATE OR REPLACE VIEW vw_content_performance AS
SELECT
    p.post_id,
    ds.dataset_code,
    p.source_record_id,
    p.platform,
    p.published_at,
    p.post_type,
    p.source_content_category,
    p.video_duration_seconds,
    m.observed_at,
    m.observation_type,
    m.views, m.impressions, m.reach, m.likes, m.comments, m.shares, m.saves,
    m.profile_visits, m.follows,
    (COALESCE(m.likes, 0) + COALESCE(m.comments, 0) +
     COALESCE(m.shares, 0) + COALESCE(m.saves, 0)) AS total_interactions,
    CASE WHEN m.reach > 0 THEN
        (COALESCE(m.likes, 0) + COALESCE(m.comments, 0) +
         COALESCE(m.shares, 0) + COALESCE(m.saves, 0))::NUMERIC / m.reach
    END AS engagement_rate_by_reach,
    CASE WHEN m.impressions > 0 THEN
        (COALESCE(m.likes, 0) + COALESCE(m.comments, 0) +
         COALESCE(m.shares, 0) + COALESCE(m.saves, 0))::NUMERIC / m.impressions
    END AS engagement_rate_by_impressions,
    CASE WHEN m.reach > 0 THEN m.shares::NUMERIC / m.reach END AS share_rate_by_reach,
    CASE WHEN m.reach > 0 THEN m.saves::NUMERIC / m.reach END AS save_rate_by_reach,
    m.reported_interaction_rate,
    m.is_synthetic,
    a.hook_type,
    a.cta_type,
    a.content_pillar,
    a.annotation_method
FROM content_posts p
JOIN dataset_sources ds ON ds.dataset_id = p.dataset_id
LEFT JOIN content_metrics m ON m.post_id = p.post_id
LEFT JOIN content_annotations a ON a.post_id = p.post_id;
