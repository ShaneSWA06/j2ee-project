-- =====================================================
-- Migration: Add admin_reply column to feedback table
-- =====================================================

-- Add admin_reply column to feedback table
ALTER TABLE feedback ADD COLUMN IF NOT EXISTS admin_reply TEXT;

-- Add timestamp for when admin replied
ALTER TABLE feedback ADD COLUMN IF NOT EXISTS admin_reply_at TIMESTAMP;

-- Add index for faster queries on feedback with replies
CREATE INDEX IF NOT EXISTS idx_feedback_admin_reply ON feedback(admin_reply);

-- Verify the changes
SELECT column_name, data_type, is_nullable 
FROM information_schema.columns 
WHERE table_name = 'feedback' 
ORDER BY ordinal_position;
